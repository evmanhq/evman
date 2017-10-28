<template>
  <div class="constrain d-sm-flex">
    <input type="hidden" v-model="name" name="filter[constrains][][name]">
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

      <input type="hidden" :value="value"
             name="filter[constrains][][values][]"
             v-for="value in values"
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
      name: this.value.name,
      values: this.value.values || [],
      condition: this.value.condition,
      options: [],
      optionsLoading: false,
      optionsQueryTimeout: null,
      flatPickrConfig: {}
    }
  },

  computed: {
    selected_field() {
      return _.find(this.field_definitions, (d) => d.name === this.name)
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
    selected_field() {
      this.options = this.selected_field.options || []
      this.condition = this.selected_field.conditions[0].name
      this.values = []
    },

    values() { this.$emit('change') },
    name() { this.$emit('change') },
    condition(newValue, oldValue) {
      this.$emit('change')

      if(this.selected_field.type === 'date' && (newValue === 'range' || oldValue === 'range')) {
        this.values = []
      }
    }
  },

  methods: {
    selectField(option) {
      this.name = option.name
    },

    selectCondition(condition) {
      this.condition = condition.name
    },

    setValue(event) {
      console.log(event)
      this.values = [event.target.value]
    },

    setValues(selected) {
      this.values = _.map(selected, (o) => o.value)
    },

    setDateValue(value) {
      this.values = [value]
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