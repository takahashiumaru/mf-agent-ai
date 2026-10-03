import fs from 'node:fs';
import path from 'node:path';

const IGNORED_DIRS = new Set([
  '.git',
  'node_modules',
  '.svelte-kit',
  'build',
  'dist',
  '.vite',
  'data',
  'src',
  '.gemini',
  'scratch'
]);

const IGNORED_FILES = new Set([
  '.env',
  '.env.local',
  '.DS_Store',
  'package.json',
  'package-lock.json',
  'svelte.config.js',
  'vite.config.js',
  'bun.lockb',
  'datatags-agent-ai-aarch64-apple-darwin',
  'datatags-agent-ai-x86_64-apple-darwin'
]);

const ALLOWED_EXTENSIONS = new Set([
  '.md',
  '.json',
  '.sql',
  '.txt',
  '.go'
]);

let cachedChunks = null;
let lastIndexedTime = 0;

/**
 * Recursively scans directory for knowledge files
 */
function scanDir(dirPath, rootDir, fileList = []) {
  if (!fs.existsSync(dirPath)) return fileList;
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dirPath, entry.name);
    const relPath = path.relative(rootDir, fullPath);

    if (entry.isDirectory()) {
      if (IGNORED_DIRS.has(entry.name)) {
        continue;
      }
      if (entry.name.startsWith('.') && entry.name !== '.agent' && entry.name !== '.agents') {
        continue;
      }
      scanDir(fullPath, rootDir, fileList);
    } else if (entry.isFile()) {
      if (IGNORED_FILES.has(entry.name)) continue;
      if (entry.name.startsWith('.')) continue;
      
      const ext = path.extname(entry.name).toLowerCase();
      if (ALLOWED_EXTENSIONS.has(ext)) {
        try {
          const stats = fs.statSync(fullPath);
          // Skip oversized JSON/SQL dumps (> 150KB) to prevent RAG pollution
          if (stats.size > 150 * 1024 && (ext === '.json' || ext === '.sql')) {
            continue;
          }
          fileList.push({ fullPath, relPath, ext });
        } catch (e) {}
      }
    }
  }

  return fileList;
}

/**
 * Splits markdown and text files into logical sections/chunks
 */
function chunkDocument(content, relPath) {
  const chunks = [];
  const lines = content.split('\n');

  let currentHeader = path.basename(relPath);
  let currentLines = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    
    // Check if line is a Markdown header (e.g. #, ##, ###)
    const headerMatch = line.match(/^(#{1,4})\s+(.+)$/);
    if (headerMatch) {
      if (currentLines.length > 0) {
        const text = currentLines.join('\n').trim();
        if (text.length > 20) {
          chunks.push({
            id: `${relPath}#chunk-${chunks.length + 1}`,
            source: relPath,
            section: currentHeader,
            content: text
          });
        }
        currentLines = [];
      }
      currentHeader = headerMatch[2].trim();
      currentLines.push(line);
    } else {
      currentLines.push(line);
      
      // If current chunk exceeds 1500 chars, break cleanly at a paragraph
      if (currentLines.join('\n').length > 1500 && line.trim() === '') {
        const text = currentLines.join('\n').trim();
        if (text.length > 20) {
          chunks.push({
            id: `${relPath}#chunk-${chunks.length + 1}`,
            source: relPath,
            section: currentHeader,
            content: text
          });
        }
        currentLines = [];
      }
    }
  }

  // Final chunk
  if (currentLines.length > 0) {
    const text = currentLines.join('\n').trim();
    if (text.length > 20) {
      chunks.push({
        id: `${relPath}#chunk-${chunks.length + 1}`,
        source: relPath,
        section: currentHeader,
        content: text
      });
    }
  }

  if (chunks.length === 0 && content.trim().length > 0) {
    chunks.push({
      id: `${relPath}#full`,
      source: relPath,
      section: path.basename(relPath),
      content: content.trim()
    });
  }

  return chunks;
}

/**
 * Loads all knowledge files stored locally within this repository
 */
export function getKnowledgeIndex(forceRefresh = false) {
  const rootDir = process.cwd();
  const now = Date.now();

  // Cache for 60 seconds unless forced
  if (cachedChunks && !forceRefresh && (now - lastIndexedTime < 60000)) {
    return cachedChunks;
  }

  // Scan all local project knowledge (including knowledge/ski-compliance, prompts/, .agent/)
  const localFiles = scanDir(rootDir, rootDir);
  const allChunks = [];

  for (const file of localFiles) {
    try {
      const content = fs.readFileSync(file.fullPath, 'utf8');
      const chunks = chunkDocument(content, file.relPath);
      allChunks.push(...chunks);
    } catch (err) {
      console.warn(`[Knowledge Indexer] Skipping ${file.relPath}:`, err.message);
    }
  }

  cachedChunks = allChunks;
  lastIndexedTime = now;
  console.log(`[Knowledge Indexer] Indexed ${localFiles.length} local knowledge files into ${allChunks.length} chunks.`);

  return allChunks;
}
