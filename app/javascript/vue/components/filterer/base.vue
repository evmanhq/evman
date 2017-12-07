<template>
    <div class="filterer card">
        <div class="card-header">
            Search
            <div class="pull-right">
                <button class="btn btn-success btn-sm"
                        @click.prevent="addConstrain">
                    Add <i class="fa fa-plus"></i>
                </button>

                <button class="btn btn-warning btn-sm" @click.prevent="clearConstrains">
                    Clear
                </button>

                <input v-if="showSubmit" type="submit" class="btn btn-primary btn-sm" :value="submitText" ref="submit_button">
            </div>
        </div>
        <div class="card-body">
            <div class="constrains d-sm-flex">
                <constrain v-for="(constrain, index) in constrains"
                           v-model="constrains[index]"
                           :field_definitions="definition"
                           :key="index"
                           @remove-constrain="constrains.splice(index, 1)">
                </constrain>
            </div>
        </div>
    </div>
</template>

<script>
import Constrain from './constrain'
import _ from 'underscore'
export default {
  props: {
    constrains_data: Array,
    definition: Array,
    triggerChange: {
      type: Boolean,
      default: false
    },
    showSubmit: {
      type: Boolean,
      default: true
    },
    submitText: {
      type: String,
      default: 'Filter'
    },
    savePath: {
      type: String,
      default: ''
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
      if(this.triggerChange) this.$nextTick( () => { this.submitForm() })
    },

    submitForm() {
      this.$refs['submit_button'].click()
    },

    newConstrainId() {
      let max_id = _.max(_.map(this.constrains, (c) => c.data.id))
      if(!max_id || max_id == -Infinity) max_id = 0
      return max_id + 1
    },

    handleChange() {
      if(!this.triggerChange) return
      let delay = 500
      if(this.changeTimeout) clearTimeout(this.changeTimeout)

      this.changeTimeout = setTimeout(this.submitForm, delay)
    }
  }
}
</script>