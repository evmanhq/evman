import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'
import 'vue/rails_resource'
Vue.config.productionTip = false

class Wrapper {
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

export {Wrapper, Vue, Vuex}