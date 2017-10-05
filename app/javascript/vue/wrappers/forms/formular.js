import {Wrapper, Vue, Vuex} from 'vue/wrappers/wrapper'
import FormBuilder from 'vue/components/forms/builder'
import {store} from 'vue/components/forms/store'

export default class Form extends Wrapper {
  render() {
    super.render()
    this.disableEnterSubmit()

    let data = this.options.data || {}
    let fields = data.fields || []

    store.dispatch('loadInitialState', {
      fields: fields,
      record_name: 'form[data]'
    })

    new Vue({
      el: this.container,
      store,
      components: { FormBuilder }
    })
  }

  disableEnterSubmit() {
    this.element.addEventListener('keypress', (e) => {
      if(e.keyCode == 13) e.preventDefault()
    })
  }
}