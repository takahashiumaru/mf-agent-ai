import fs from 'node:fs';
import path from 'node:path';

const DB_DIR = path.resolve(process.cwd(), 'data');
const DB_PATH = path.join(DB_DIR, 'conversations_store.json');

// Ensure data directory exists
if (!fs.existsSync(DB_DIR)) {
  fs.mkdirSync(DB_DIR, { recursive: true });
}

function loadData() {
  if (!fs.existsSync(DB_PATH)) {
    const initial = { conversations: [], messages: [] };
    try {
      fs.writeFileSync(DB_PATH, JSON.stringify(initial, null, 2), 'utf8');
    } catch (e) {}
    return initial;
  }
  try {
    const raw = fs.readFileSync(DB_PATH, 'utf8');
    return JSON.parse(raw) || { conversations: [], messages: [] };
  } catch (err) {
    console.warn('[DB Client] Error reading database file, resetting:', err.message);
    return { conversations: [], messages: [] };
  }
}

function saveData(data) {
  try {
    const tmpPath = `${DB_PATH}.tmp`;
    fs.writeFileSync(tmpPath, JSON.stringify(data, null, 2), 'utf8');
    fs.renameSync(tmpPath, DB_PATH);
  } catch (err) {
    console.error('[DB Client] Error saving database file:', err.message);
  }
}

export function getDbStore() {
  return {
    get: loadData,
    save: saveData
  };
}

