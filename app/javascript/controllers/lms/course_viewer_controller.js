import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "item"]

  connect() {
    this.sidebarVisible = true
    // Highlight active item on page load if needed
    this.highlightActiveItem()
  }

  toggleSidebar() {
    this.sidebarVisible = !this.sidebarVisible

    if (this.sidebarVisible) {
      this.sidebarTarget.classList.remove('hidden', 'w-0')
      this.sidebarTarget.classList.add('w-96')
    } else {
      this.sidebarTarget.classList.remove('w-96')
      this.sidebarTarget.classList.add('w-0', 'overflow-hidden')

      setTimeout(() => {
        if (!this.sidebarVisible) {
          this.sidebarTarget.classList.add('hidden')
        }
      }, 300)
    }
  }

  selectItem(event) {
    // Remove active state from all items
    this.itemTargets.forEach(item => {
      item.classList.remove('bg-blue-50', 'border-l-4', 'border-blue-500')
    })

    // Add active state to clicked item
    const clickedItem = event.currentTarget
    clickedItem.classList.add('bg-blue-50', 'border-l-4', 'border-blue-500')
  }

  highlightActiveItem() {
    // Check URL for curriculum item ID and highlight if present
    const url = new URL(window.location.href)
    const pathParts = url.pathname.split('/')
    const curriculumItemIndex = pathParts.indexOf('curriculum_items')

    if (curriculumItemIndex !== -1 && pathParts[curriculumItemIndex + 1]) {
      const itemId = pathParts[curriculumItemIndex + 1]
      const activeItem = this.itemTargets.find(item =>
        item.dataset.curriculumItemId === itemId
      )

      if (activeItem) {
        activeItem.classList.add('bg-blue-50', 'border-l-4', 'border-blue-500')
      }
    }
  }
}
