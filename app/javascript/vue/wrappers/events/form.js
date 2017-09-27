import {Wrapper, Vue, Vuex} from 'vue/wrappers/wrapper'
import PropertiesForm from 'vue/components/events/properties_form'
import EventForm from 'vue/components/events/event_form'
import store from 'vue/components/events/store'

export default class Form extends Wrapper {
  render() {
    super.render()
    if(!this.options.event.properties_assignments) this.options.event.properties_assignments = {}

    store.dispatch('loadInitialState', {
      event_properties: this.options.event_properties,
      event: this.options.event,
      event_types: this.options.event_types,
      owners: this.options.owners,
      record_name: 'event'
    })

    const vueApp = new Vue({
      el: this.container,
      store,
      components: { PropertiesForm, EventForm }
    })
  }
}