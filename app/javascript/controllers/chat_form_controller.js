import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]
  static values = { sessionId: Number }

  submit(event) {
    event.preventDefault()
    const content = this.inputTarget.value.trim()
    if (!content) return

    this.appendUserMessage(content)
    this.showTypingIndicator()

    const formData = new FormData(this.element)
    this.disableForm()
    fetch(this.element.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    }).then(response => {
      if (response.ok) return response.text()
      throw new Error("Request failed")
    }).then(html => {
      this.hideTypingIndicator()
      Turbo.renderStreamMessage(html)
      this.enableForm()
    }).catch(() => {
      this.hideTypingIndicator()
      this.enableForm()
    })

    this.inputTarget.value = ""
    this.autoResize()
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      // Enterのみの場合は改行（デフォルト動作）
      return
    }
  }

  autoResize() {
    const input = this.inputTarget
    input.style.height = "auto"
    input.style.height = Math.min(input.scrollHeight, 150) + "px"
  }

  appendUserMessage(content) {
    const container = document.getElementById("messages")
    const html = `
      <div class="flex items-start space-x-3 flex-row-reverse space-x-reverse">
        <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center flex-shrink-0">
          <span class="text-xs font-bold text-gray-600">You</span>
        </div>
        <div class="max-w-[75%] bg-indigo-600 text-white rounded-2xl rounded-tr-none px-4 py-3">
          <div class="text-sm whitespace-pre-wrap break-words">${this.escapeHtml(content)}</div>
        </div>
      </div>
    `
    container.insertAdjacentHTML("beforeend", html)
    this.scrollToBottom()
  }

  showTypingIndicator() {
    const indicator = document.getElementById("typing-indicator")
    if (indicator) indicator.classList.remove("hidden")
    this.scrollToBottom()
  }

  hideTypingIndicator() {
    const indicator = document.getElementById("typing-indicator")
    if (indicator) indicator.classList.add("hidden")
  }

  disableForm() {
    this.submitTarget.disabled = true
    this.inputTarget.disabled = true
  }

  enableForm() {
    this.submitTarget.disabled = false
    this.inputTarget.disabled = false
    this.inputTarget.focus()
  }

  scrollToBottom() {
    const container = document.getElementById("messages")
    if (container) {
      container.scrollTop = container.scrollHeight
    }
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
