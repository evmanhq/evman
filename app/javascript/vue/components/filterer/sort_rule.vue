<template>
  <div class="sort-rule d-sm-flex">
    <div class="field">
      <input type="hidden" :value="name" :name="`${record_name}[sort_rules][][name]`">
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
    <div class="direction">
      <input type="hidden" :value="direction" :name="`${record_name}[sort_rules][][direction]`">
      <multiselect :value="selected_direction"
                   @input="selectDirection"
                   :options="directions"
                   deselect-label=""
                   select-label=""
                   selected-label=""
                   placeholder="Select"
                   track-by="name"
                   label="label"
                   :searchable="true"
                   :allow-empty="false">
      </multiselect>
    </div>

    <button class="btn btn-danger" @click.prevent="$emit('remove-sort-rule')">
      <i class="fa fa-remove"></i>
    </button>
  </div>
</template>

<script>
  import Multiselect from 'vue-multiselect'
  export default {
    components: { Multiselect },
    props: {
      value: Object,
      field_definitions: Array,
      record_name: {
        type: String,
        default: 'filter'
      }
    },

    data() {
      return {
        directions: [
          { name: 'asc', label: 'A to Z' },
          { name: 'desc', label: 'Z to A' },
        ]
      }
    },

    computed: {
      payload() { return this.value },
      name() { return this.payload.name },
      direction() { return this.payload.direction },

      selected_field() {
        return this.findField(this.name)
      },

      selected_direction() {
        return this.directions.find((d) => d.name === this.direction)
      }
    },

    methods: {
      selectField(option) {
        this.emitInput({
          name: option.name
        })
      },

      selectDirection(option) {
        this.emitInput({
          direction: option.name
        })
      },

      findField(name) {
        return this.field_definitions.find((d) => d.name === name)
      },

      emitInput(changes) {
        let data = {
          name: this.name,
          direction: this.direction
        }

        Object.keys(changes).forEach( key => { data[key] = changes[key] })
        this.$emit('input', data)
      },
    },

    mounted() {
      console.log('mmm', this)
    }
  }
</script>