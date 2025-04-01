// This is the main JavaScript entry point for the application
// Import libraries
import jQuery from "jquery"
import "jquery-ui"
import "bootstrap"
import "select2"
import "daterangepicker"
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// Make jQuery available globally
window.$ = window.jQuery = jQuery

// Initialize Stimulus application
const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Document ready function
$(document).on("turbo:load", () => {
  // Initialize Select2 dropdowns
  $(".select2").select2({
    theme: "bootstrap4",
    width: "100%",
  })

  // Initialize DateRangePicker
  $(".daterangepicker-field").daterangepicker({
    autoUpdateInput: false,
    locale: {
      cancelLabel: "Clear",
      applyLabel: "Apply",
      format: "MM/DD/YYYY",
    },
  })

  $(".daterangepicker-field").on("apply.daterangepicker", function (ev, picker) {
    $(this).val(picker.startDate.format("MM/DD/YYYY") + " - " + picker.endDate.format("MM/DD/YYYY"))
  })

  $(".daterangepicker-field").on("cancel.daterangepicker", function (ev, picker) {
    $(this).val("")
  })
})

