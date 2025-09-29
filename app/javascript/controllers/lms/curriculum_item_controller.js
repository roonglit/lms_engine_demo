import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "videoArea", "toggleIcon"]

  connect() {
    // Set initial icon state
    this.updateToggleIcon();
  }

  removeCurriculumItem(event) {
    event.preventDefault();
    this.checkboxTarget.checked = true;
    this.element.classList.add("hidden")
  }

  toggleVideoArea() {
    // toggle hidden class on videoArea target
    this.videoAreaTarget.classList.toggle("hidden");
    
    // Update icon based on videoArea visibility
    this.updateToggleIcon();
  }

  updateToggleIcon() {
    const isHidden = this.videoAreaTarget.classList.contains("hidden");
    
    if (isHidden) {
      // VideoArea is hidden, show chevron-down (expand)
      this.toggleIconTarget.className = "iconify lucide--chevron-down";
    } else {
      // VideoArea is visible, show chevron-up (collapse)
      this.toggleIconTarget.className = "iconify lucide--chevron-up";
    }
  }
}
