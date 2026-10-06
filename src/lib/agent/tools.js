import fs from 'node:fs';
import path from 'node:path';

let endpointConfig = null;

function loadEndpoints() {
  if (endpointConfig) return endpointConfig;
  try {
    const filePath = path.resolve(process.cwd(), 'prompts/default/endpoints.json');
    if (fs.existsSync(filePath)) {
      endpointConfig = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }
  } catch (err) {
    console.error('Failed to load endpoints.json:', err.message);
  }
  return endpointConfig || {};
}

/**
 * Executes get_doctors tool against the configured API
 */
export async function executeGetDoctors(params = {}) {
  const endpoints = loadEndpoints();
  const doctorEndpoint = endpoints.get_doctors || {
    url: 'https://ski-compliance-metiska-farma-api.flexurio.com/customers/no-auth',
    method: 'GET'
  };

  const url = new URL(doctorEndpoint.url);
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') {
      url.searchParams.append(key, String(value));
    }
  }

  const headers = {
    'Accept': 'application/json'
  };
  if (doctorEndpoint.token) {
    headers['Authorization'] = doctorEndpoint.token.startsWith('Bearer ')
      ? doctorEndpoint.token
      : `Bearer ${doctorEndpoint.token}`;
  }

  try {
    console.log(`[Tool get_doctors] Fetching ${url.toString()}`);
    const res = await fetch(url.toString(), {
      method: doctorEndpoint.method || 'GET',
      headers,
      signal: AbortSignal.timeout(15000)
    });

    if (!res.ok) {
      return {
        error: `HTTP ${res.status}: ${res.statusText}`,
        success: false
      };
    }

    const data = await res.json();
    return data;
  } catch (err) {
    console.error('[Tool get_doctors] Error:', err.message);
    return {
      error: `Gagal memanggil API dokter: ${err.message}`,
      success: false
    };
  }
}

import { exec } from 'node:child_process';
import { promisify } from 'node:util';
import mysql from 'mysql2/promise';

const execAsync = promisify(exec);

let poolCache = new Map();

function getDbPool(database) {
  if (poolCache.has(database)) return poolCache.get(database);

  const host = process.env.MYSQL_HOST || '';
  const port = Number.parseInt(process.env.MYSQL_PORT || '5721', 10);
  const user = process.env.MYSQL_USER;
  const password = process.env.MYSQL_PASSWORD;

  if (!user || !password) return null;

  try {
    const pool = mysql.createPool({
      host,
      port,
      user,
      password,
      database,
      waitForConnections: true,
      connectionLimit: 5,
      queueLimit: 0,
      connectTimeout: 10000
    });
    poolCache.set(database, pool);
    return pool;
  } catch (e) {
    console.warn('[Tool SafeDbQuery] Pool creation warning:', e.message);
    return null;
  }
}

/**
 * Resolves target database name for project
 */
export function getDatabaseForProject(project = 'visitflow', explicitDb = null) {
  if (explicitDb) return explicitDb;
  if (project === 'ski-compliance') {
    return process.env.MYSQL_DATABASE_SKI || 'SKI_MF_PROD';
  }
  return process.env.MYSQL_DATABASE_VISITFLOW || process.env.MYSQL_DATABASE || 'VISITFLOW_MF_PROD';
}

/**
 * Safely executes read-only SELECT queries to VisitFlow or SKI MySQL DB
 * @param {string} sqlQuery 
 * @param {Object} options
 * @returns {Promise<any>}
 */
export async function executeSafeDbQuery(sqlQuery, options = {}) {
  const database = options.database || getDatabaseForProject(options.project);
  const sanitized = sqlQuery.trim().replace(/;+$/g, '');

  // 1. Enforce read-only: Query must start with SELECT or EXPLAIN
  if (!/^(SELECT|EXPLAIN)\b/i.test(sanitized)) {
    return { error: 'Operasi ditolak. Hanya query SELECT read-only yang diizinkan.', success: false };
  }

  // 2. Strict blacklist: Absolutely NO mutation, DDL, DML, or administrative commands
  const forbiddenKeywords = /\b(INSERT|UPDATE|DELETE|DROP|ALTER|TRUNCATE|CREATE|REPLACE|RENAME|GRANT|REVOKE|LOCK|CALL|EXEC|EXECUTE|SET|HANDLER)\b/i;
  if (forbiddenKeywords.test(sanitized)) {
    return { error: 'Operasi dibatalkan: Dilarang keras mengeksekusi DML/DDL (UPDATE, DELETE, ALTER, DROP, INSERT, dll). Sistem hanya beroperasi dalam mode Read-Only.', success: false };
  }

  // 3. Primary: Try native mysql2 connection pool (pure JavaScript, no CLI dependency)
  const pool = getDbPool(database);
  if (pool) {
    try {
      const [rows] = await pool.query(sanitized);
      return { success: true, data: Array.isArray(rows) ? rows : [rows] };
    } catch (poolErr) {
      console.warn('[Tool SafeDbQuery] mysql2 query failed, falling back to CLI:', poolErr.message);
    }
  }

  // 4. Secondary: Try local MySQL login-path (if mysql client is installed)
  const command = `mysql --login-path=visitflow-production-readonly --database=${database} -e "START TRANSACTION READ ONLY; ${sanitized}; COMMIT;"`;

  try {
    const { stdout } = await execAsync(command, { timeout: 15000 });
    const lines = stdout.trim().split('\n');
    if (lines.length === 0 || !lines[0]) return { success: true, data: [] };

    const headers = lines[0].split('\t');
    const rows = lines.slice(1).map(line => {
      const cols = line.split('\t');
      const obj = {};
      headers.forEach((h, i) => {
        obj[h] = cols[i];
      });
      return obj;
    });

    return { success: true, data: rows };
  } catch (err) {
    // Fallback using direct env credentials if login-path fails
    const host = process.env.MYSQL_HOST;
    const port = process.env.MYSQL_PORT || '3306';
    const user = process.env.MYSQL_USER;
    const password = process.env.MYSQL_PASSWORD;

    if (!host || !user) {
      console.error('[Tool SafeDbQuery] Login-path and DB env credentials not available:', err.message);
      return { error: `Gagal menjalankan query: ${err.message}`, success: false };
    }

    const fallbackCmd = `mysql -h ${host} -P ${port} -u ${user} -p'${password || ''}' ${database} -e "START TRANSACTION READ ONLY; ${sanitized}; COMMIT;"`;

    try {
      const { stdout } = await execAsync(fallbackCmd, { timeout: 15000 });
      const lines = stdout.trim().split('\n');
      if (lines.length === 0 || !lines[0]) return { success: true, data: [] };

      const headers = lines[0].split('\t');
      const rows = lines.slice(1).map(line => {
        const cols = line.split('\t');
        const obj = {};
        headers.forEach((h, i) => {
          obj[h] = cols[i];
        });
        return obj;
      });

      return { success: true, data: rows };
    } catch (fallbackErr) {
      console.error('[Tool SafeDbQuery] Error:', fallbackErr.message);
      return { error: fallbackErr.message, success: false };
    }
  }
}

/**
 * Helper for quick visit statistics in VisitFlow (VISITFLOW_MF_PROD)
 */
export async function getVisitStatistics({ targetDate = null, structureId = null } = {}) {
  const dateCondition = targetDate 
    ? `DATE(v.checkin_time) = '${targetDate}'` 
    : `DATE(v.checkin_time) = CURDATE()`;
  
  const structCondition = structureId ? `AND (v.structure_id = '${structureId}' OR vm.structure_id = '${structureId}')` : '';

  const query = `
    SELECT 
      COUNT(DISTINCT CASE WHEN v.checkout_time IS NOT NULL OR v.status IN ('check-out', 'closed', 'realization-approved', 'approved') THEN v.id END) as total_kunjungan_sah,
      COUNT(DISTINCT CASE WHEN v.checkout_time IS NULL AND v.status = 'check-in' THEN v.id END) as total_checkin_berjalan,
      COUNT(DISTINCT v.id) as total_aktivitas_lapangan,
      COUNT(DISTINCT v.structure_id) as total_user_aktif,
      COUNT(DISTINCT v.customer_id) as total_dokter_dikunjungi
    FROM visits v
    LEFT JOIN visit_members vm ON vm.visit_id = v.id AND vm.deleted_at IS NULL
    WHERE v.deleted_at IS NULL
      AND ${dateCondition}
      ${structCondition}
  `;

  return executeSafeDbQuery(query, { database: 'VISITFLOW_MF_PROD' });
}

/**
 * Helper for live sales statistics and available periods in Ski Compliance (SKI_MF_PROD)
 */
export async function getSkiSalesStatistics({ period = null, structureId = null, limit = 12 } = {}) {
  if (period) {
    const structClause = structureId ? `AND marketing_structure_id = '${structureId}'` : '';
    const query = `
      SELECT 
        period,
        COUNT(*) as total_transaksi,
        MIN(invoice_date) as tanggal_pertama,
        MAX(invoice_date) as tanggal_terakhir,
        COUNT(DISTINCT outlet_id) as total_outlet,
        COUNT(DISTINCT product_id) as total_produk,
        SUM(qty) as total_qty,
        SUM(value_sales) as gross_sales_value,
        SUM(total_claim) as total_klaim,
        SUM(qty_final) as final_qty,
        SUM(value_sales_final) as final_sales_value
      FROM sales_ffs
      WHERE period = '${period}'
        ${structClause}
      GROUP BY period
    `;
    return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
  }

  // Summary per period (last N periods)
  const structClause = structureId ? `WHERE marketing_structure_id = '${structureId}'` : '';
  const query = `
    SELECT 
      period,
      COUNT(*) as total_transaksi,
      MIN(invoice_date) as tanggal_pertama,
      MAX(invoice_date) as tanggal_terakhir,
      SUM(value_sales) as gross_sales_value,
      SUM(total_claim) as total_klaim,
      SUM(value_sales_final) as final_sales_value
    FROM sales_ffs
    ${structClause}
    GROUP BY period
    ORDER BY period DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for live doctor agreement statistics (discount_proposals) in Ski Compliance (SKI_MF_PROD)
 */
export async function getSkiDoctorAgreements({ status = null, period = null, limit = 10 } = {}) {
  const whereClauses = ['deleted_at IS NULL'];
  if (status) whereClauses.push(`status = '${status}'`);
  if (period) whereClauses.push(`period = '${period}'`);

  const query = `
    SELECT 
      status,
      COUNT(*) as total_proposal,
      SUM(amount_actual) as total_nominal_aktual,
      SUM(amount_estimation) as total_nominal_estimasi
    FROM discount_proposals
    WHERE ${whereClauses.join(' AND ')}
    GROUP BY status
    ORDER BY total_proposal DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for live marketing targets in Ski Compliance (SKI_MF_PROD)
 */
export async function getSkiTargetStatistics({ period = null, limit = 6 } = {}) {
  const periodClause = period ? `WHERE period = '${period}'` : '';
  const query = `
    SELECT 
      period,
      COUNT(*) as total_target_records,
      COUNT(DISTINCT code_mr) as total_mr,
      COUNT(DISTINCT product_code) as total_produk,
      SUM(qty) as total_target_qty,
      SUM(value) as total_target_value
    FROM target_marketing
    ${periodClause}
    GROUP BY period
    ORDER BY period DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for master data summary in Ski Compliance (SKI_MF_PROD)
 */
export async function getSkiMasterSummary() {
  const query = `
    SELECT 
      (SELECT COUNT(*) FROM customers WHERE deleted_at IS NULL) as total_customers,
      (SELECT COUNT(*) FROM outlets WHERE deleted_at IS NULL) as total_outlets,
      (SELECT COUNT(*) FROM marketing_structures WHERE deleted_at IS NULL) as total_marketing_structures,
      (SELECT COUNT(*) FROM discount_proposals WHERE deleted_at IS NULL) as total_discount_proposals,
      (SELECT MAX(period) FROM sales_ffs) as latest_sales_period
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for live Credit Notes / SPC summary in Ski Compliance (from table credit_notes in SKI_MF_PROD)
 */
export async function getSkiCreditNotes({ period = null, limit = 12 } = {}) {
  const whereClauses = ['deleted_at IS NULL'];
  if (period) whereClauses.push(`period = '${period}'`);
  const query = `
    SELECT 
      period,
      COUNT(*) as total_transaksi_cn,
      MIN(invoice_date) as tanggal_invoice_pertama,
      MAX(invoice_date) as tanggal_invoice_terakhir,
      SUM(value) as total_nominal_cn
    FROM credit_notes
    WHERE ${whereClauses.join(' AND ')}
    GROUP BY period
    ORDER BY period DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for live Payment / Transfer SKI in Ski Compliance (from table discount_proposal_payments in SKI_MF_PROD)
 */
export async function getSkiPayments({ period = null, limit = 12 } = {}) {
  const whereClauses = [
    'deleted_at IS NULL',
    'transferred = 1',
    '(canceled_transferred = 0 OR canceled_transferred IS NULL)'
  ];
  if (period) whereClauses.push(`period = '${period}'`);
  
  const query = `
    SELECT 
      period,
      COUNT(*) as total_transaksi_transfer,
      MIN(transferred_at) as tgl_transfer_pertama,
      MAX(transferred_at) as tgl_transfer_terakhir,
      SUM(transferred_amount) as total_nominal_transfer,
      SUM(submission_amount) as total_nominal_pengajuan
    FROM discount_proposal_payments
    WHERE ${whereClauses.join(' AND ')}
    GROUP BY period
    ORDER BY period DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

/**
 * Helper for live Approved Estimations SKI in Ski Compliance (from table discount_proposal_estimations in SKI_MF_PROD)
 */
export async function getSkiEstimations({ period = null, limit = 12 } = {}) {
  const whereClauses = [
    'dp.deleted_at IS NULL',
    'dpe.deleted_at IS NULL',
    "dp.status = 'APPROVE'"
  ];
  if (period) whereClauses.push(`dp.period = '${period}'`);

  const query = `
    SELECT 
      dp.period,
      COUNT(DISTINCT dp.id) as total_proposal_approved,
      COUNT(dpe.id) as total_item_estimasi,
      SUM(dpe.total) as total_nominal_estimasi
    FROM discount_proposals dp
    INNER JOIN discount_proposal_estimations dpe 
      ON dp.id = dpe.discount_proposal_id
    WHERE ${whereClauses.join(' AND ')}
    GROUP BY dp.period
    ORDER BY dp.period DESC
    LIMIT ${limit}
  `;
  return executeSafeDbQuery(query, { database: 'SKI_MF_PROD' });
}

