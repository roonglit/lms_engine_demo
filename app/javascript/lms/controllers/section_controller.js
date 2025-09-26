import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "container"]
  static values = {
    template: String,
    templateId: Number
  }

  connect() {
  }

  removeSection(event) {
    event.preventDefault();
    this.checkboxTarget.checked = true;
    this.element.classList.add("hidden")
  }

  addCurriculumItem(event) {
    event.preventDefault();

    // Use the controller's templateValue and templateIdValue
    if (!this.templateValue) {
      console.error("No template value found");
      return;
    }

    // Use the placeholder ID from the controller's templateIdValue
    const placeholderId = this.templateIdValue;
    
    // Generate unique timestamp-based ID
    const uniqueId = new Date().getTime();
    
    // Replace the placeholder ID with the unique timestamp
    const regexp = new RegExp(placeholderId, 'g');
    const template = this.templateValue.replace(regexp, uniqueId);

    // Insert the processed template
    const container = this.containerTarget;
    container.insertAdjacentHTML('beforeend', template);
  }
}
