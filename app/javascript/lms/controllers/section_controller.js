import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
  }

  removeSection(event) {
    event.preventDefault();

    console.log("targets:", this.checkboxTarget);

    this.checkboxTarget.checked = true;

    console.log("targets:", this.checkboxTarget);
    
    // add hidden class to this section element
    // this.element.classList.add("hidden")
  }
}
