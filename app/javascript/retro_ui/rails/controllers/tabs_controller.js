import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { defaultValue: String }

  connect() {
    const value = this.defaultValue || this.activeTriggerValue || this.firstTriggerValue
    if (value) this.activate(value)
  }

  select(event) {
    this.activate(event.params.value)
  }

  activate(value) {
    this.triggerTargets.forEach((trigger) => {
      const active = trigger.dataset.retroUiTabsValueParam === value
      trigger.dataset.state = active ? "active" : "inactive"
      trigger.setAttribute("aria-selected", active ? "true" : "false")
    })

    this.contentTargets.forEach((content) => {
      content.hidden = content.dataset.retroUiTabsValue !== value
    })
  }

  get defaultValue() {
    return this.hasDefaultValueValue ? this.defaultValueValue : null
  }

  get activeTriggerValue() {
    const trigger = this.triggerTargets.find((item) => item.dataset.state === "active")
    return trigger ? trigger.dataset.retroUiTabsValueParam : null
  }

  get firstTriggerValue() {
    return this.triggerTargets[0] ? this.triggerTargets[0].dataset.retroUiTabsValueParam : null
  }
}
