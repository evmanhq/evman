<template>
    <div class="filterer card">
        <div class="card-header">
            Search
            <div class="pull-right btn-group">
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
        <div class="card-body">
            <div class="constrains d-sm-flex">
                <constrain v-for="(constrain, index) in constrains"
                           v-model="constrains[index]"
                           :field_definitions="definition"
                           :key="index"
                           :record_name="ui_options.record_name"
                           @remove-constrain="constrains.splice(index, 1)">
                </constrain>
            </div>
        </div>
    </div>
</template>

<script>
import Constrain from './constrain'
import _ from 'underscore'
import Navigation from 'vue/navigation'

export default {
  props: {
    constrains_data: Array,
    definition: Array,
    ui_options: {
      type: Object
    }
  },

  components: {
    'constrain': Constrain
  },

  data() {
    return {
      constrains: Object.values(this.constrains_data || {}),
      changeTimeout: null
    }
  },

  watch: {
    constrains() {
      this.handleChange()
    }
  },

  methods: {
    addConstrain() {
      let definition = this.definition[0]
      this.constrains.push({
        name: definition.name,
        condition: definition.conditions[0].name,
        values: []
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
      console.log(path, method);
      Navigation.visit({url: path, method: method, data: { constrains: this.constrains }})
    }
  },

  mounted() {
    if(this.ui_options.trigger_change) this.$nextTick( () => { this.submitForm() })
  }
}
</script>