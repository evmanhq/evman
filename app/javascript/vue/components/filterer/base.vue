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

                <input type="submit" class="btn btn-primary btn-sm" value="Filter" ref="submit_button">
            </div>
        </div>
        <div class="card-body">
            <div class="constrains d-sm-flex">
                <constrain v-model="constrain.data"
                           :field_definitions="definition"
                           :key="constrain.data.id"
                           v-for="(constrain, index) in constrains"
                           @change="handleChange"
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
    }
  },

  components: {
    'constrain': Constrain
  },

  data() {
    return {
      constrains: _.map(this.constrains_data, (data) => {
        return { data: _.extend(data, { id: this.newConstrainId() }) }
      }),
      changeTimeout: null
    }
  },

  methods: {
    addConstrain() {
      let definition = this.definition[0]
      this.constrains.push({
        data: {
          id: this.newConstrainId(),
          name: definition.name,
          condition: definition.conditions[0].name,
          values: []
        }
      })
    },

    clearConstrains() {
      this.constrains = []
      this.$nextTick( () => { this.submitForm() })
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