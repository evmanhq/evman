<template>
  <div>
    <div class="filterer card">
      <div class="card-header">
        <div>
          <span @click="toggleConstrains" class="cursor-pointer">
            <i class="fa fa-chevron-down" v-show="showConstrains"></i>
            <i class="fa fa-chevron-right" v-show="!showConstrains"></i>
            Search
            <small v-if="constrains.length === 1">
              (1 condition)
            </small>
            <small v-if="constrains.length > 1">
              ({{constrains.length}} conditions)
            </small>
          </span>
          &nbsp;
          <span @click="toggleSorts" class="cursor-pointer" v-if="featureSortingEnabled">
            <i class="fa fa-chevron-down" v-show="showSorts"></i>
            <i class="fa fa-chevron-right" v-show="!showSorts"></i>
            Sort
            <small v-if="sort_rules.length === 1">
              (1 rule)
            </small>
            <small v-if="sort_rules.length > 1">
              ({{sort_rules.length}} rules)
            </small>
          </span>
        </div>

        <div class="btn-group">
            <button class="btn btn-success btn-sm" @click.prevent="addConstrain">
              <i class="fa fa-plus"></i> Add
            </button>

            <button class="btn btn-warning btn-sm" @click.prevent="clearConstrains">
              <i class="fa fa-times"></i>
                Clear
            </button>

            <button v-for="button in ui_options.action_buttons"
                    :class="['btn', 'btn-sm', button.class]"
                    @click.prevent="actionButton(button.path, button.method)">
              <i :class="['fa', `fa-${button.icon}`]" v-if="button.icon"></i>
                {{ button.label }}
            </button>


            <input v-if="ui_options.show_submit" type="submit" class="btn btn-primary btn-sm"
                   :value="ui_options.submit_text" ref="submit_button">
        </div>
      </div>
      <div class="card-text card-text-constrains" v-show="showConstrains">
          <div class="constrains d-sm-flex">
              <constrain v-for="(constrain, index) in constrains"
                         v-model="constrains[index]"
                         :field_definitions="definition.constrain_fields"
                         :key="index"
                         :record_name="ui_options.record_name"
                         @remove-constrain="constrains.splice(index, 1)">
              </constrain>
          </div>
      </div>

      <div class="card-text bg-light card-text-sort-rules" v-show="showSorts" v-if="featureSortingEnabled">


        <div class="sort-rules d-sm-flex">
          <div>Sort by:</div>
          <sort-rule v-for="(sort_rule, index) in sort_rules"
                     v-model="sort_rules[index]"
                     :field_definitions="definition.sort_rule_fields"
                     :key="index"
                     :record_name="ui_options.record_name"
                     @remove-sort-rule="sort_rules.splice(index, 1)">
          </sort-rule>
          <button class="btn btn-success btn-xs" @click.prevent="addSortRule">
            <i class="fa fa-plus"></i> Add
          </button>
        </div>


      </div>
    </div>
  </div>
</template>

<script>
import Constrain from './constrain'
import SortRule from './sort_rule'
import _ from 'underscore'
import Navigation from 'vue/navigation'

export default {
  props: {
    constrains_data: Array,
    sort_rules_data: Array,
    definition: Object,
    ui_options: {
      type: Object
    }
  },

  components: {
    'constrain': Constrain,
    'sort-rule': SortRule
  },

  data() {
    let constrains_data = Object.values(this.constrains_data || {})
    let sort_rules_data = Object.values(this.sort_rules_data || {})
    return {
      constrains: constrains_data,
      sort_rules: sort_rules_data,
      changeTimeout: null,
      showConstrains: constrains_data.length > 0,
      showSorts: true
    }
  },

  watch: {
    constrains() {
      this.handleChange()
    }
  },

  computed: {
    featureSortingEnabled() {
      if(this.ui_options.sorting == undefined) return true
      return this.ui_options.sorting
    }
  },

  methods: {
    addConstrain() {
      let definition = this.definition.constrain_fields[0]
      this.showConstrains = true
      this.constrains.push({
        name: definition.name,
        condition: definition.conditions[0].name,
        values: []
      })
    },

    addSortRule() {
      let definition = this.definition.sort_rule_fields[0]
      this.showSorts = true
      this.sort_rules.push({
        name: definition.name,
        direction: 'asc'
      })
    },

    clearConstrains() {
      this.constrains = []
      if(this.ui_options.trigger_change) this.$nextTick( () => { this.submitForm() })
    },

    submitForm() {
      this.$refs['submit_button'].click()
    },

    handleChange() {
      if(!this.ui_options.trigger_change) return
      let delay = 500
      if(this.changeTimeout) clearTimeout(this.changeTimeout)

      this.changeTimeout = setTimeout(this.submitForm, delay)
    },

    actionButton(path, method) {
      Navigation.visit({url: path, method: method, data: { constrains: this.constrains, sort_rules: this.sort_rules }})
    },

    toggleConstrains() {
      this.showConstrains = !this.showConstrains
    },

    toggleSorts() {
      this.showSorts = !this.showSorts
    }
  },

  mounted() {
    if(this.ui_options.trigger_change) this.$nextTick( () => { this.submitForm() })
  }
}
</script>