import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["primary"]

  show(event) {
    const src = event.currentTarget.dataset.src
    if (src) this.primaryTarget.src = src
  }
}
