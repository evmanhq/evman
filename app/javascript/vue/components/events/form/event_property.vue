<template>
  <div class="form-group row">
    <label class="col-form-label col-lg-3">{{ definition.name }}</label>
    <div class="col-lg-9">
      <multiselect
          v-if="isMultiselect"
          v-model="selected_options"
          track-by="id"
          label="name"
          :options="visible_options"
          :searchable="true"
          :allow-empty="true"
          :closeOnSelect="!isMultiple"
          :multiple="isMultiple">
      </multiselect>

      <input
          v-if="!isMultiselect"
          class="form-control"
          type="text"
          v-model="text_value"
          />
    </div>

    <input type="hidden"
           v-for="value in values"
           :value="value"
           :name="fieldName">
  </div>
</template>

<script>
  import Multiselect from 'vue-multiselect'
  import {mapState} from 'vuex'
  export default {
    components: { Multiselect },
    props: {
      definition: Object
    },
    computed: {
      ...mapState(['record_name']),
      isMultiselect() {
        if(this.definition.behaviour === 'multiple_choice') return true
        if(this.definition.behaviour === 'select') return true
        return false
      },

      isMultiple() {
        if(this.definition.behaviour === 'multiple_choice') return true
        return false
      },

      visible_options() {
        return this.$store.getters.visibleOptions(this.definition.id)
      },

      values() {
        return this.$store.getters.propertyAssignments(this.definition.id)
      },

      fieldName() {
        return `${this.record_name}[properties_assignments][${this.definition.id}][]`
      },

      selected_options: {
        get() {
          let selected = this.$store.getters.selectedOptions(this.definition.id)
          if(this.definition.behaviour === 'select')
            return selected[0]
          return selected
        },

        set(values) {
          this.$store.dispatch('eventPropertyUpdate', { id: this.definition.id, values })
        }
      },

      text_value: {
        get() {
          let obj = this.$store.getters.selectedOptions(this.definition.id)[0] || {}
          return obj.id
        },

        set(value) {
          this.$store.dispatch('eventPropertyUpdate', { id: this.definition.id, values: [{ id: value }] })
        }
      }
    }
  }

</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>