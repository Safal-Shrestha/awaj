import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["department", "category"]

  connect() {
    this.filter()
  }

  filter() {
    const departmentId = this.departmentTarget.value
    const options = this.categoryTarget.querySelectorAll("option")

    options.forEach((option) => {
      if (!option.value) return // always keep the blank prompt visible

      const matches = option.dataset.departmentId === departmentId
      option.hidden = !matches
      option.disabled = !matches
    })

    // if a previously-selected category no longer matches, clear it
    const selected = this.categoryTarget.selectedOptions[0]
    if (selected?.disabled) this.categoryTarget.value = ""

    this.categoryTarget.disabled = !departmentId
  }
}