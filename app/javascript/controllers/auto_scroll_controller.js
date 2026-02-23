import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.scrollToBottom()
    this.observeMutations()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  scrollToBottom() {
    if (this.hasContainerTarget) {
      this.containerTarget.scrollTop = this.containerTarget.scrollHeight
    }
  }

  observeMutations() {
    if (!this.hasContainerTarget) return

    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.containerTarget, {
      childList: true,
      subtree: true
    })
  }
}
