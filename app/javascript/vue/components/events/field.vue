<template>
  <div class="form-group row">
    <label :class="['col-form-label', labelClass]">
      {{ label }}
      <b v-if="required" class="text-danger">*</b>
    </label>
    <div :class="[valueClass]">
      <input v-if="isText"
             type="text"
             :name="fieldName(name)"
             :value="event[name]"
             @input="setEventField(name, $event)"
             class="form-control"/>

      <textarea v-if="isTextArea"
                :name="fieldName(name)"
                :value="event[name]"
                @input="setEventField(name, $event)"
                rows="5"
                class="form-control"></textarea>

      <datepicker v-if="isDatePicker"
                  :name="fieldName(name)"
                  :value="event[name]"
                  @input="setEventField(name, { target: { value: $event }})"
                  input-class="vue-date-picker"
                  :bootstrap-styling="true"
                  :clear-button="true"

                  clear-button-icon="fa fa-times"></datepicker>
    </div>
  </div>
</template>

<script>
  import Datepicker from 'vuejs-datepicker'
  import EventMixin from './event_mixin'

  export default {
    components: { Datepicker },
    mixins: [EventMixin],
    props: {
      name: String,
      label: String,
      labelClass: {
        type: String,
        default: 'col-xl-2'
      },
      valueClass: {
        type: String,
        default: 'col-xl-10'
      },
      type: {
        type: String,
        default: 'text'
      },
      required: {
        type: Boolean,
        default: false
      }
    },

    computed: {
      isText() {
        return this.type === 'text'
      },
      isTextArea() {
        return this.type === 'textarea'
      },
      isDatePicker() {
        return this.type === 'datepicker'
      }
    },
    data() {
      return {
        showDatePicker: false
      }
    }
  }
</script>

<style>
  .vue-date-picker[readonly] {
    background-color: #fff;
    z-index: 0 !important; /* fix for vue-multiselect dropdown overlay */
  }
</style>