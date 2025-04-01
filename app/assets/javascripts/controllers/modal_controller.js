import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    console.log("Modal controller connected")
    // Close modal when clicking outside of it
    this.containerTarget.addEventListener("click", (event) => {
      if (event.target === this.containerTarget) {
        this.close()
      }
    })

    // Close modal when pressing escape key
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && this.containerTarget.classList.contains("show")) {
        this.close()
      }
    })
  }

  open() {
    this.containerTarget.classList.add("show")
    document.body.classList.add("modal-open")
  }

  close() {
    this.containerTarget.classList.remove("show")
    document.body.classList.remove("modal-open")
  }
}

