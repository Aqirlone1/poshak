import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { minLength: Number }

  submitOnEnter(event) {
    if (event.key === "Enter" || event.target.value.length >= (this.minLengthValue || 3)) {
      this.element.requestSubmit()
    }
  }
}
