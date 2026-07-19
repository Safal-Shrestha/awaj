import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { voted: Boolean, url: String, count: Number }
  static targets = ["icon", "count"]

  toggle() {
    const wasVoted = this.votedValue
    const method = wasVoted ? "DELETE" : "POST"

    // optimistic update — flip immediately
    this.votedValue = !wasVoted
    this.countValue += wasVoted ? -1 : 1
    this.render()

    fetch(this.urlValue, {
      method,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        Accept: "application/json"
      }
    }).then(res => {
      if (!res.ok) {
        // revert on failure
        this.votedValue = wasVoted
        this.countValue += wasVoted ? 1 : -1
        this.render()
      }
    })
  }

  render() {
    this.iconTarget.classList.toggle("filled", this.votedValue)
    this.countTarget.textContent = this.countValue
  }
}