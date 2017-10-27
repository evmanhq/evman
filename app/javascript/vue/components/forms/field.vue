<template>
  <div class="card field">
    <div class="card-header">
      <div @click="toggle" role="button" class="label">
        <i class="fa fa-chevron-down" v-if="collapsed"></i>
        <i class="fa fa-chevron-up" v-else></i>
        &nbsp;
        {{ label }}
        &nbsp;
        <small class="text-muted">{{ type.label }}</small>
        <span class="text-danger" v-show="required">*</span>
      </div>
      <div class="actions">
        <a class="btn-minimize" @click="moveFieldUp(fieldId)">
          <i class="fa fa-arrow-up"></i>
        </a>

        <a class="btn-minimize" @click="moveFieldDown(fieldId)">
          <i class="fa fa-arrow-down"></i>
        </a>

        <a class="btn-close" @click="removeField(fieldId)">
          <i class="fa fa-remove"></i>
        </a>
      </div>
    </div>
    <div class="card-block" v-show="!collapsed">
      <div class="form">

        <input type="hidden" :value="fieldId" :name="buildName('id')">

        <div :class="[validationClass('label'),'form-group']">
          <label class="form-control-label">Label</label>
          <input type="text" v-model="label" :name="buildName('label')" placeholder="Question ..." class="form-control form-control-danger">
          <div class="form-control-feedback" v-if="!validations.label">Label cannot be empty !</div>
        </div>

        <div class="row">
          <div class="form-group col-md-6">
            <label class="form-control-label">Type</label>
            <input type="hidden" :name="buildName('type')" :value="type.name" ref="type">
            <multiselect v-model="type"
                         :options="types"
                         deselect-label="Can't remove this value"
                         track-by="name"
                         label="label"
                         :searchable="false"
                         :allow-empty="false">
              <template slot="option" slot-scope="props">
                <i :class="[props.option.icon, 'fa']"></i> &nbsp;
                {{ props.option.label }}
              </template>
            </multiselect>
          </div>

          <div class="form-group col-md-6">
            <label class="form-control-label">Required</label>

            <div class="form-check">
              <label class="switch switch-3d switch-danger">
                <input type="checkbox" class="switch-input" v-model="required" :name="buildName('required')">
                <span class="switch-label"></span>
                <span class="switch-handle"></span>
              </label>
            </div>
          </div>
        </div>

        <div v-show="hasChoices">
          <label for="choices">Choices</label>
          <ul class="list-unstyled fa-ul">
            <li v-for="(choice, index) in choices" class="choice">
              <i :class="[type.icon, 'fa']"></i>
              <input type="text" class="form-control"
                     :ref="'choice_' + index"
                     :name="buildName('choices', true)"
                     :value="choice"
                     @input="setChoice(index, $event)"
                     @blur="choiceBlur(index)"
                     @keypress.enter="focusNextChoice(index)"
              >
              <i class="fa fa-remove cursor-pointer" @click="deleteChoice(index)"></i>
            </li>

            <li class="choice new-choice">
              <i :class="[type.icon, 'fa']"></i>
              <input type="text" class="form-control" ref="new_choice" placeholder="New choice ..." @focus="createChoice">
            </li>
          </ul>
        </div>


      </div>
    </div>
  </div>
</template>

<script>
  import {mapActions, mapState, mapMutations} from 'vuex'
  import {FIELD_TYPES} from './store'
  import Multiselect from 'vue-multiselect'

  export default {
    components: { Multiselect },

    props: ['fieldId'],

    data() {
      return {
        validations: {
          label: true
        }
      }
    },
    computed: {
      ...mapState(['record_name']),

      label: {
        get() {
          return this.$store.getters.fieldAttribute(this.fieldId, 'label')
        },
        set(value) {
          this.$store.commit('updateFieldAttribute', { id: this.fieldId, attribute: 'label', value })
        }
      },

      collapsed: {
        get() {
          return this.$store.getters.fieldAttribute(this.fieldId, 'collapsed')
        },
        set(value) {
          this.$store.commit('updateFieldAttribute', { id: this.fieldId, attribute: 'collapsed', value })
        }
      },

      type: {
        get() {
          return this.$store.getters.type(this.fieldId)
        },
        set(typeObj) {
          this.$store.commit('updateFieldAttribute', { id: this.fieldId, attribute: 'type', value: typeObj.name })
        }
      },

      required: {
        get() {
          return this.$store.getters.fieldAttribute(this.fieldId, 'required')
        },
        set(value) {
          this.$store.commit('updateFieldAttribute', { id: this.fieldId, attribute: 'required', value })
        }
      },

      types() {
        return FIELD_TYPES
      },

      choices() {
        return this.$store.getters.fieldAttribute(this.fieldId, 'choices')
      },

      hasChoices() {
        return ['multiple-choice', 'checkboxes', 'dropdown'].includes(this.type.name)
      }
    },

    watch: {
      label(newValue, oldValue) {
        this.validations.label = newValue.trim() !== ''
      }
    },

    methods: {
      ...mapMutations(['moveFieldUp', 'moveFieldDown', 'removeField']),

      toggle() {
        this.collapsed = !this.collapsed
      },

      validationClass(field) {
        if(!this.validations[field]) return 'has-danger'
      },

      createChoice() {
        this.$store.commit('addChoice', { id: this.fieldId, choice: '' })
        this.$nextTick(() => {
          this.$refs[`choice_${this.choices.length -1}`][0].focus()
        })
      },

      deleteChoice(index) {
        this.$store.commit('deleteChoice', { id: this.fieldId, index })
      },

      choiceBlur(index) {
        let choices = this.$store.getters.fieldAttribute(this.fieldId, 'choices')
        if(choices[index].trim() != '') return
        this.deleteChoice(index)
      },

      focusNextChoice(index) {
        this.$nextTick(() => {
          let el = this.$refs[`choice_${index+1}`]
          if(el) el = el[0]
          el = el || this.$refs.new_choice
          el.focus()
        })
      },

      setChoice(index, event) {
        this.$store.commit('updateChoice', { fieldId:this.fieldId, choiceIndex: index, value: event.target.value })
      },

      buildName(name, multiple) {
        let base = `${this.record_name}[fields][][${name}]`
        if(multiple) base += '[]'
        return base
      }
    }
  }
</script>