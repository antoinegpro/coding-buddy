import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-form"
export default class extends Controller {
  static targets = ["button"]

  send(event) {
    event.preventDefault() // pas de retour à la ligne
    if (this.buttonTarget.disabled) return // évite un double envoi
    this.element.requestSubmit(this.buttonTarget) // comme un clic sur "Envoyer"
  }
}
