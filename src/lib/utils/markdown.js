import { Marked } from 'marked';
import hljs from 'highlight.js';

const markedInstance = new Marked();

// Configure marked with custom highlight.js renderer
markedInstance.setOptions({
  gfm: true,
  breaks: true,
  pedantic: false
});

// Custom renderer for code blocks and tables to ensure mobile scrollability
const renderer = {
  table(token) {
    let header = '';
    let cell = '';
    for (let j = 0; j < token.header.length; j++) {
      cell += this.tablecell(token.header[j]);
    }
    header += this.tablerow({ text: cell });
    let body = '';
    for (let j = 0; j < token.rows.length; j++) {
      const row = token.rows[j];
      cell = '';
      for (let k = 0; k < row.length; k++) {
        cell += this.tablecell(row[k]);
      }
      body += this.tablerow({ text: cell });
    }
    if (body) body = `<tbody>${body}</tbody>`;
    return `
      <div class="table-responsive-container">
        <table>
          <thead>${header}</thead>
          ${body}
        </table>
      </div>
    `;
  },
  code({ text, lang }) {
    const validLang = lang && hljs.getLanguage(lang) ? lang : '';
    let highlighted = text;

    try {
      if (validLang) {
        highlighted = hljs.highlight(text, { language: validLang }).value;
      } else {
        highlighted = hljs.highlightAuto(text).value;
      }
    } catch (e) {
      highlighted = escapeHtml(text);
    }

    const displayLang = validLang || 'code';
    const encodedRaw = encodeURIComponent(text);

    return `
      <div class="code-block-wrapper">
        <div class="code-block-header">
          <span>${displayLang}</span>
          <button class="code-copy-btn" data-code="${encodedRaw}" onclick="window.__copyCode(this)">
            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg>
            <span>Salin</span>
          </button>
        </div>
        <div class="code-block-content">
          <pre><code class="hljs ${validLang ? `language-${validLang}` : ''}">${highlighted}</code></pre>
        </div>
      </div>
    `;
  }
};

markedInstance.use({ renderer });

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

export function renderMarkdown(content) {
  if (!content) return '';
  try {
    return markedInstance.parse(content);
  } catch (err) {
    console.error('Markdown parse error:', err);
    return `<p>${escapeHtml(content)}</p>`;
  }
}
