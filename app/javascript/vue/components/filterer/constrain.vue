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
                   :options="options"
                   deselect-label=""
                   select-label=""
                   selected-label=""
                   track-by="value"
                   label="label"
                   :searchable="true"
                   :allow-empty="true"
                   :multiple="true"
                   v-if="isMultiselect">
      </multiselect>
    </div>

    <button class="btn btn-danger" @click.prevent="$emit('remove-constrain')">
      <i class="fa fa-remove"></i>
    </button>
  </div>
</template>

<script>
import _ from 'underscore'
import Multiselect from 'vue-multiselect'

export default {
  components: { Multiselect },
  props: {
    value: Object,
    field_definitions: Array
  },

  data() {
    return _.extend(this.value, { options: [] })
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
      this.options = this.selected_field.options
      this.condition = this.selected_field.conditions[0].name
      this.values = []
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
      this.values = [event.target.value]
    },

    setValues(selected) {
      this.values = _.map(selected, (o) => o.value)
    }
  },

  beforeMount() {
    this.options = this.selected_field.options
  }
}
</script>