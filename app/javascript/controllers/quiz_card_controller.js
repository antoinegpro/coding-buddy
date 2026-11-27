import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.messages = [
      "Génération du quiz…",
      "Je choisis les meilleures questions…",
      "Je prépare les réponses…",
      "Presque prêt !"
    ]
    this.reset()
  }

  start(event) {
    // Formular erst nach dem Start der Animation abschicken
    event.preventDefault()

    if (this.started) return
    this.started = true

    this.element.classList.add("is-loading")
    this.element.closest(".theme-grid")?.classList.add("has-loading")

    let index = 0
    this.timer = setInterval(() => {
      index = Math.min(index + 1, this.messages.length - 1)
      this.messageTarget.textContent = this.messages[index]
      if (index === this.messages.length - 1) clearInterval(this.timer)
    }, 1800)

    setTimeout(() => this.element.form?.requestSubmit(this.element), 300)
  }

  reset() {
    clearInterval(this.timer)
    this.started = false
    this.element.classList.remove("is-loading")
    this.element.closest(".theme-grid")?.classList.remove("has-loading")
    if (this.hasMessageTarget) this.messageTarget.textContent = this.messages[0]
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
