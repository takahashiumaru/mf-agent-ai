import { getKnowledgeIndex } from './indexer.js';

const STOP_WORDS = new Set([
  'yang', 'di', 'dan', 'ini', 'itu', 'untuk', 'pada', 'adalah', 'dengan', 'dari',
  'ke', 'akan', 'atau', 'dalam', 'bisa', 'ada', 'tidak', 'jika', 'oleh', 'sebagai',
  'the', 'is', 'at', 'which', 'on', 'and', 'a', 'an', 'in', 'to', 'for', 'of', 'with'
]);

/**
 * Tokenizes text preserving alphanumeric, underscores and dots for code terms
 */
function tokenize(text) {
  if (!text) return [];
  const words = text
    .toLowerCase()
    .replace(/[^\w\s._-]/g, ' ')
    .split(/\s+/)
    .filter(w => w.length > 1 && !STOP_WORDS.has(w));
  return words;
}

/**
 * Searches the repository knowledge base and returns top relevant chunks
 */
export function retrieveContext(query, topK = 5) {
  const chunks = getKnowledgeIndex();
  if (!chunks || chunks.length === 0) return [];

  const queryTokens = tokenize(query);
  if (queryTokens.length === 0) {
    // If empty or purely stop words, return top general chunks (system.md, rules.md)
    return chunks
      .filter(c => c.source.includes('system.md') || c.source.includes('rules.md') || c.source.includes('tools.md'))
      .slice(0, topK);
  }

  // Pre-calculate document frequencies (DF)
  const N = chunks.length;
  const df = new Map();
  let totalLength = 0;

  const docTokenMap = chunks.map(chunk => {
    const textToTokenize = `${chunk.source} ${chunk.section} ${chunk.content}`;
    const tokens = tokenize(textToTokenize);
    totalLength += tokens.length;

    const uniqueTokens = new Set(tokens);
    for (const token of uniqueTokens) {
      df.set(token, (df.get(token) || 0) + 1);
    }

    // Token counts for this chunk
    const termFreq = new Map();
    for (const token of tokens) {
      termFreq.set(token, (termFreq.get(token) || 0) + 1);
    }

    return { chunk, tokens, termFreq, len: tokens.length };
  });

  const avgDocLength = totalLength / (N || 1);
  const k1 = 1.2;
  const b = 0.75;

  const scored = docTokenMap.map(doc => {
    let score = 0;
    const lowerQuery = query.toLowerCase();
    const lowerContent = doc.chunk.content.toLowerCase();
    const lowerSection = doc.chunk.section.toLowerCase();
    const lowerSource = doc.chunk.source.toLowerCase();

    // Exact phrase bonus in content or section
    if (lowerContent.includes(lowerQuery)) {
      score += 10.0;
    }
    if (lowerSection.includes(lowerQuery) || lowerSource.includes(lowerQuery)) {
      score += 8.0;
    }

    for (const qToken of queryTokens) {
      const docFreq = df.get(qToken) || 0;
      if (docFreq === 0) continue;

      // BM25 IDF
      const idf = Math.log(1 + (N - docFreq + 0.5) / (docFreq + 0.5));
      const tf = doc.termFreq.get(qToken) || 0;

      // BM25 TF component
      const tfScore = (tf * (k1 + 1)) / (tf + k1 * (1 - b + b * (doc.len / avgDocLength)));
      
      let termScore = idf * tfScore;

      // Boost if term is in header/filename
      if (lowerSection.includes(qToken) || lowerSource.includes(qToken)) {
        termScore *= 2.0;
      }

      score += termScore;
    }

    return {
      chunk: doc.chunk,
      score
    };
  });

  scored.sort((a, b) => b.score - a.score);

  const topResults = scored
    .filter(item => item.score > 0)
    .slice(0, topK)
    .map(item => ({
      ...item.chunk,
      score: item.score
    }));

  return topResults;
}

/**
 * Formats retrieved chunks into a prompt-ready context block
 */
export function formatContextBlock(chunks) {
  if (!chunks || chunks.length === 0) {
    return 'Tidak ada konteks dokumen khusus yang ditemukan untuk pertanyaan ini.';
  }

  return chunks.map((c, i) => {
    return `### [Sumber ${i + 1}]: \`${c.source}\` (Bagian: ${c.section})\n${c.content}\n`;
  }).join('\n---\n\n');
}
