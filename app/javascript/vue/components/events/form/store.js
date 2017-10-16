import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'
import _ from 'underscore'
import RestrictionsResolver from './restrictions_resolver'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    record_name: null,
    event: {},
    event_properties: [],
    event_types: [],
    owners: [],
    visible_event_properties: [],
    visible_event_property_options: {},
    selected_event_property_options: {}
  },

  getters: {
    eventType(state) {
      return state.event_types.filter((t) => parseInt(t.id) === parseInt(state.event.event_type_id))[0]
    },

    propertyAssignments(state) {
      return (id) => {
        return state.event.properties_assignments[id]
      }
    },

    propertyDefinition(state) {
      return (id) => {
        return state.event_properties.filter((property) => {
          return parseInt(property.id) === parseInt(id)
        })[0]
      }
    },

    visibleProperties(state) {
      return state.visible_event_properties
    },

    visibleOptions(state) {
      return (id) => {
        return state.visible_event_property_options[id]
      }
    },

    selectedOptions(state, getters) {
      return (id) => {
        return state.selected_event_property_options[id] || []
      }
    }
  },

  mutations: {
    setRecordName(state, record_name) {
      state.record_name = record_name
    },

    setEvent(state, event) {
      state.event = event
      state.event.properties_assignments = state.event.properties_assignments || {}
      for(let id in state.event.properties_assignments) {
        let definition = state.event_properties.filter((ep) => parseInt(ep.id) === parseInt(id))[0]
        let values = state.event.properties_assignments[id]
        if(definition.behaviour === 'text' && values.length > 0) {
          state.selected_event_property_options[id] = [{ id: values[0] }]
          continue
        }
        state.selected_event_property_options[id] = definition.options.filter( (option) => {
          return values.map((i) => parseInt(i)).includes(parseInt(option.id))
        })
      }
    },

    setProperties(state, event_properties) {
      state.event_properties = event_properties
      state.visible_event_properties = event_properties

      event_properties.forEach( (property) => {
        state.visible_event_property_options[property.id] = property.options
      })
    },

    setEventTypes(state, event_types) {
      state.event_types = event_types
    },

    setOwners(state, owners) {
      state.owners = owners
    },

    setEventField(state, {name, value}) {
      if(name === 'begins_at' && !state.event.ends_at)
        state.event.ends_at = value
      state.event[name] = value
    },

    setVisibleProperties(state, properties) {
      state.visible_event_properties = properties
    },

    setVisibleOptions(state, {id, values}) {
      let new_obj = {}
      new_obj[id] = values
      state.visible_event_property_options = Object.assign({}, state.visible_event_property_options, new_obj)
    },

    setSelectedOptions(state, {id, values}) {
      let new_obj = {}
      new_obj[id] = values
      state.selected_event_property_options = Object.assign({}, state.selected_event_property_options, new_obj)
    },

    setPropertiesAssignments(state, {id, values}) {
      let new_obj = {}
      new_obj[id] = values.map((o) => o.id)
      state.event.properties_assignments = Object.assign({}, state.event.properties_assignments, new_obj)
    }
  },

  actions: {
    loadInitialState(context, {record_name, event, event_properties, event_types, owners}) {
      context.commit('setRecordName', record_name)
      context.commit('setProperties', event_properties)
      context.commit('setEvent', event)
      context.commit('setEventTypes', event_types)
      context.commit('setOwners', owners)
      context.dispatch('updateVisibleProperties')
      context.dispatch('updateVisibleOptions')
    },

    eventPropertyUpdate(context, {id, values}) {
      let valuesArray = _.flatten([values]) // Array.wrap, ensures values is array
      context.commit('setSelectedOptions', { id, values: valuesArray })
      context.commit('setPropertiesAssignments', { id, values: valuesArray })
      context.dispatch('updateVisibleProperties')
      context.dispatch('updateVisibleOptions')
    },

    updateVisibleProperties(context) {
      let updates = []
      let resultCache = {}
      context.getters.visibleProperties.forEach((property) => {
        resultCache[property.id] = new RestrictionsResolver(context.state.event, property.restrictions).resolve()
        if(!resultCache[property.id]) updates.push(property.id)
      })

      let visible_properties = context.state.event_properties.filter((property) => {
        let result = resultCache[property.id] || new RestrictionsResolver(context.state.event, property.restrictions).resolve()
        return result
      })
      context.commit('setVisibleProperties', visible_properties)
      updates.forEach((id) => {
        context.dispatch('eventPropertyUpdate', { id: id, values: [] })
      })
    },

    updateVisibleOptions(context) {
      context.state.event_properties.forEach((property) => {
        if(property.behaviour === 'text') return

        let new_visible_options = property.options.filter( (option) => {
          return new RestrictionsResolver(context.state.event, option.restrictions).resolve()
        })

        let selected = context.getters.selectedOptions(property.id)
        let common = _.intersection(selected.map((o) => o.id), new_visible_options.map((o) => o.id))

        context.commit('setVisibleOptions', {
          id: property.id,
          values: new_visible_options
        })

        if(common.length !== selected.length) {
          let new_selected = selected.filter( (o) => common.includes(o.id) )
          context.dispatch('eventPropertyUpdate', { id: property.id, values: new_selected})
        }
      })
    }
  }
})