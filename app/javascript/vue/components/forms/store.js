import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

const FIELD_TYPES = [
  { name: 'text', label: 'Short text', icon: 'fa-align-left' },
  { name: 'text-area', label: 'Long text', icon: 'fa-align-justify'},
  { name: 'multiple-choice', label: 'Multiple choice', icon: 'fa-dot-circle-o' },
  { name: 'checkboxes', label: 'Checkboxes', icon: 'fa-check-square' },
  { name: 'dropdown', label: 'Dropdown', icon: 'fa-chevron-circle-down' }
]

let findField = function(fields, id) {
  return fields.find((f) => f.id === id)
}

const store = new Vuex.Store({
  state: {
    fields: [],
    record_name: null
  },

  getters: {
    fieldAttribute(state) {
      return (id, attribute) => {
        return findField(state.fields, id)[attribute]
      }
    },

    type(state) {
      return (id) => {
        let code = findField(state.fields, id).type
        return FIELD_TYPES.find((t) => t.name === code)
      }
    }
  },

  mutations: {
    setFields(state, fields) {
      state.fields = fields
    },

    setRecordName(state, record_name) {
      state.record_name = record_name
    },

    updateFieldAttribute(state, {id, attribute, value}) {
      let field = findField(state.fields, id)
      field[attribute] = value
    },

    addField(state, field) {
      state.fields.push(field)
    },

    moveFieldUp(state, id) {
      let field = findField(state.fields, id)
      let oldIndex = state.fields.indexOf(field)
      let newIndex = oldIndex - 1

      state.fields.splice(newIndex, 0, state.fields.splice(oldIndex, 1)[0])
    },

    moveFieldDown(state, id) {
      let field = findField(state.fields, id)
      let oldIndex = state.fields.indexOf(field)
      let newIndex = oldIndex + 1

      state.fields.splice(newIndex, 0, state.fields.splice(oldIndex, 1)[0])
    },

    removeField(state, id) {
      let field = findField(state.fields, id)
      let index = state.fields.indexOf(field)
      if(index >= 0) state.fields.splice(index, 1)
    },

    addChoice(state, {id, choice}) {
      let field = findField(state.fields, id)
      field.choices.push(choice)
    },

    deleteChoice(state, {id, index}) {
      let field = findField(state.fields, id)
      field.choices.splice(index, 1)
    },

    updateChoice(state, {fieldId, choiceIndex, value}) {
      let field = findField(state.fields, fieldId)
      field.choices.splice(choiceIndex, 1, value)
    }
  },

  actions: {
    loadInitialState(context, {fields, record_name}) {
      fields.forEach((f) => f.collapsed = true)

      context.commit('setFields', fields)
      context.commit('setRecordName', record_name)
    },

    addEmptyField(context) {
      let id = 1
      if(context.state.fields.length > 0)
        id = Math.max(...context.state.fields.map((f) => f.id)) + 1

      let field = {
        id: id,
        type: FIELD_TYPES[0].name,
        label: '',
        required: false,
        choices: [],
        collapsed: false
      }

      context.commit('addField', field)
    }
  }
})

export {store, FIELD_TYPES}