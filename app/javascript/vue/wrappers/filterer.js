/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'
import FiltererComponent from 'vue/components/filterer/base.vue'
import Wrapper from './wrapper'

export default class Filterer extends Wrapper {
  render() {
    super.render()
    const vueApp = new Vue({
      el: this.container,
      data: this.prepareData(),
      components: {
        'filterer': FiltererComponent
      }
    })
  }

  prepareData() {
    let definition = this.options.definition
    let payload = this.options.payload

    return {
      definition: definition,
      constrains: payload.constrains
    }
  }
}