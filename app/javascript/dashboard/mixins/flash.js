export default {
  data: () => ({
    messages: []
  }),
  created () {
    const metaFlashes = document.querySelectorAll('meta[name="flash"]')
    const messages = []
    for (const metaFlash of metaFlashes) {
      messages.push(metaFlash.content)
      metaFlash.remove()
    }
    this.messages.push(...messages)
  }
}
