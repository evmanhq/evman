<template>
  <div class="form-group row event-field">
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
      <div class="input-group" v-if="isDatePicker">
        <flat-pickr :name="fieldName(name)"
                    :value="event[name]"
                    input-class="form-control"
                    :config="{ altInput: true }"
                    @input="setEventField(name, { target: { value: $event }})"
                    ></flat-pickr>

        <span class="input-group-btn" v-if="event[name] !== '' && event[name] !== null">
          <button class="btn btn-secondary" type="button" @click.prevent="setEventField(name, { target: { value: null }})">
            <i class="fa fa-remove"></i>
          </button>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
  import Datepicker from 'vuejs-datepicker'
  import EventMixin from './event_mixin'
  import FlatPickr from 'vue-flatpickr-component';

  export default {
    components: { Datepicker, FlatPickr },
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
  @import '~flatpickr/dist/flatpickr.css';

  .vue-date-picker[readonly] {
    background-color: #fff;
    z-index: 0 !important; /* fix for vue-multiselect dropdown overlay */
  }

  .event-field .form-control[readonly] {
    background-color: #ffffff;
  }
</style>