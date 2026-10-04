export function normalizeConversationTitle(title) {
  return typeof title === 'string' ? title.trim() : '';
}
