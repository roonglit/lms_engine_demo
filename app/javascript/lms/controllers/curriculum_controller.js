import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    template: String
  }

  connect() {
    console.log("value: ", this.templateValue);
  }

  addSection(event) {
    event.preventDefault();

    const template = this.templateValue;

    const container = this.containerTarget;
    container.insertAdjacentHTML('beforeend', template);
    console.log("section template:", this.templateValue);
  }
}
