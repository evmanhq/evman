export default class Wrapper {
  constructor(element, options) {
    this.element = element
    this.options = options
  }

  render() {
    this.container = document.createElement('div')
    this.container.innerHTML = this.element.innerHTML
    this.element.innerHTML = ''
    this.element.appendChild(this.container)
  }
}