export function greet(name) {
  const trimmed = (name ?? '').trim()
  return `Hello, ${trimmed || 'world'}!`
}
