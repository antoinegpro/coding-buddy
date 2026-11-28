import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-form"
export default class extends Controller {
  send(event) {
    // Entrée seule dans le textarea uniquement
    if (event.target.tagName !== "TEXTAREA") return
    // Maj+Entrée = retour à la ligne ; saisie IME (accents) en cours = on ne fait rien
    if (event.shiftKey || event.isComposing) return

    event.preventDefault()

    const button = this.element.querySelector("[type='submit']")
    if (button?.disabled) return

    this.element.requestSubmit(button)
  }
}
