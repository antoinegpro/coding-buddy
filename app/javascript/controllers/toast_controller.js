import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 5000 } }

  connect() {
    this.timeout = setTimeout(() => {
      this.element.classList.remove("show") // déclenche le fondu Bootstrap
      setTimeout(() => this.element.remove(), 500)
    }, this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}