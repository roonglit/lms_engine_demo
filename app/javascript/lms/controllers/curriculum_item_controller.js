import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
  }

  removeCurriculumItem(event) {
    event.preventDefault();
    this.checkboxTarget.checked = true;
    this.element.classList.add("hidden")
  }
}
