<template>
  <div class="constrain d-sm-flex">
    <input type="hidden" :value="name" name="filter[constrains][][name]">
    <div class="field">
      <multiselect :value="selected_field"
                   @input="selectField"
                   :options="field_definitions"
                   deselect-label=""
                   select-label=""
                   selected-label=""
                   track-by="name"
                   label="label"
                   :searchable="true"
                   :allow-empty="false">
      </multiselect>
    </div>

    <input type="hidden" v-model="condition" name="filter[constrains][][condition]">
    <div class="condition">
      <multiselect :value="selected_condition"
                   @input="selectCondition"
                   :options="selected_field.conditions"
                   deselect-label=""
                   select-label=""
                   selected-label=""
                   track-by="name"
                   label="label"
                   :searchable="false"
                   :allow-empty="false">
      </multiselect>
    </div>

    <div class="value">
      <input type="text"
             v-if="selected_field.type == 'text'"
             :value="values[0]"
             @input="setValue"
             @keypress.enter.prevent
             name="filter[constrains][][values][]"
             class="form-control">

      <input type="number"
             v-if="selected_field.type == 'number'"
             :value="values[0]"
             @input="setValue"
             @keypress.enter.prevent
             name="filter[constrains][][values][]"
             class="form-control">

      <input type="hidden" :value="v"
             name="filter[constrains][][values][]"
             v-for="v in value.values"
             v-if="isMultiselect">

      <multiselect :value="selected_values"
                   @input="setValues"

                   @search-change="loadOptions"
                   :options="options"
                   deselect-label=""
                   select-label=""
                   selected-label=""
                   track-by="value"
                   label="label"
                   :searchable="true"
                   :hide-selected="true"
                   :internalSearch="!selected_field.options_url"
                   :show-pointer="true"
                   :allow-empty="true"
                   :multiple="true"
                   :loading="optionsLoading"
                   v-if="isMultiselect">
      </multiselect>

      <flat-pickr v-if="selected_field.type == 'date' && condition !== 'range'" key="single"
                  name="filter[constrains][][values][]"
                  @input="setDateValue"
                  :config="{mode: 'single'}"
                  :value="values[0]"></flat-pickr>

      <flat-pickr v-if="selected_field.type == 'date' && condition === 'range'" key="range"
                  name="filter[constrains][][values][]"
                  @input="setDateValue"
                  :config="{mode: 'range'}"
                  :value="values[0]"></flat-pickr>
    </div>

    <button class="btn btn-danger" @click.prevent="$emit('remove-constrain')">
      <i class="fa fa-remove"></i>
    </button>
  </div>
</template>

<script>
import _ from 'underscore'
import Multiselect from 'vue-multiselect'
import FlatPickr from 'vue-flatpickr-component';

export default {
  components: { Multiselect, FlatPickr },
  props: {
    value: Object,
    field_definitions: Array
  },

  data() {
    return {
      options: [],
      optionsLoading: false,
      optionsQueryTimeout: null,
      flatPickrConfig: {}
    }
  },

  computed: {
    payload() { return this.value },
    name() { return this.payload.name },
    condition() { return this.payload.condition },
    values() { return this.payload.values },

    selected_field() {
      return this.findField(this.name)
    },

    selected_condition() {
      return _.find(this.selected_field.conditions, (c) => c.name === this.condition)
    },

    selected_values() {
      return _.filter(this.options, (o) => this.values.includes(o.value))
    },

    isMultiselect() {
      return ['multiple_choice', 'select'].includes(this.selected_field.type)
    }
  },

  watch: {
    selected_field(oldField, newField) {
      // has to check if the new field name is the same because Vue Watcher triggers the watcher whenever
      // the new value is an object or array, not necessarily a different one
      if(oldField === newField) return true

      // this.emitInput({ condition: this.selected_field.conditions[0].name, values: [] })
      this.options = this.selected_field.options || []
    },

    selected_condition(newValue, oldValue) {
      if(newValue === oldValue) return true

      if(this.selected_field.type === 'date' && (newValue.name === 'range' || oldValue.name === 'range')) {
        this.emitInput({ values: [] })
      }
    }
  },

  methods: {
    selectField(option) {
      let new_field = this.findField(option.name)
      this.emitInput({
        name: option.name,
        condition: new_field.conditions[0].name,
        values: []
      })
    },

    selectCondition(condition) {
      this.emitInput({ condition: condition.name })
    },

    setValue(event) {
      this.emitInput({ values: [event.target.value] })
    },

    setValues(selected) {
      this.emitInput({ values: _.map(selected, (o) => o.value) })
    },

    setDateValue(value) {
      this.emitInput({ values: [value] })
    },

    emitInput(changes) {
      let data = {
        name: this.name,
        condition: this.condition,
        values: this.values
      }

      Object.keys(changes).forEach( key => { data[key] = changes[key] })
      this.$emit('input', data)
    },

    findField(name) {
      return this.field_definitions.find((d) => d.name === name)
    },

    loadOptions(query) {
      if(!this.selected_field.options_url) return

      if(!query) return
      let delay = 250
      this.optionsLoading = true
      if(this.optionsQueryTimeout) clearTimeout(this.optionsQueryTimeout)

      let loadFn = () => {
        this.$http.get(this.selected_field.options_url, { params: { fulltext: query }}).then( response => {
          let selected_options = this.options.filter( o => this.values.includes(o.value) )
          this.options = selected_options.concat(response.body || [])
          this.optionsLoading = false
        })
      }

      this.optionsQueryTimeout = setTimeout(loadFn, delay)
    },

    loadSelectedOptions() {
      if(!this.selected_field.options_url) return
      if(this.values.length == 0) return

      this.$http.get(this.selected_field.options_url, { params: { ids: this.values }}).then( response => {
        this.options = response.body || []
      })
    }
  },

  beforeMount() {
    this.options = this.selected_field.options || []
    this.loadSelectedOptions()
  }
}
</script>

<style>
  @import '~flatpickr/dist/flatpickr.css';
</style>

<style scoped>
  .form-control[readonly] {
    background-color: #ffffff;
  }
</style>