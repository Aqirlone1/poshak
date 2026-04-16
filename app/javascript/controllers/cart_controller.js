import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]

  increment() {
    this.quantityTarget.stepUp()
    this.quantityTarget.dispatchEvent(new Event("change"))
  }

  decrement() {
    this.quantityTarget.stepDown()
    this.quantityTarget.dispatchEvent(new Event("change"))
  }
}
