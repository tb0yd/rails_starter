import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Dropdown controller connected")
  }

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("show")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }
}

