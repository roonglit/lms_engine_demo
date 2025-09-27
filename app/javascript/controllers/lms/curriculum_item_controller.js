import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "videoArea"]

  connect() {
  }

  removeCurriculumItem(event) {
    event.preventDefault();
    this.checkboxTarget.checked = true;
    this.element.classList.add("hidden")
  }

  toggleVideoArea() {
    // toggle hidden class on videoArea target
    this.videoAreaTarget.classList.toggle("hidden");
  }
}
