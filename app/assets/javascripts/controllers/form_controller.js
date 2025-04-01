import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "spinner"]

  connect() {
    console.log("Form controller connected")
  }

  submit() {
    // Disable submit button and show spinner
    if (this.hasSubmitButtonTarget && this.hasSpinnerTarget) {
      this.submitButtonTarget.disabled = true
      this.spinnerTarget.classList.remove("d-none")
    }
  }

  success() {
    // Reset form after successful submission
    this.element.reset()

    // Re-enable submit button and hide spinner
    if (this.hasSubmitButtonTarget && this.hasSpinnerTarget) {
      this.submitButtonTarget.disabled = false
      this.spinnerTarget.classList.add("d-none")
    }
  }

  error() {
    // Re-enable submit button and hide spinner on error
    if (this.hasSubmitButtonTarget && this.hasSpinnerTarget) {
      this.submitButtonTarget.disabled = false
      this.spinnerTarget.classList.add("d-none")
    }
  }
}

