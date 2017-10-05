<template>
  <div>
    <div v-for="(field, index) in fields">
      <field :fieldId="field.id"
            :key="index">
      </field>
    </div>


    <button class="btn btn-success btn-xs" @click.prevent="addEmptyField">
      <i class="fa fa-plus"></i> Add field
    </button>

  </div>
</template>

<script>
  import Field from './field.vue'
  import {mapState, mapGetters, mapActions} from 'vuex'
  export default {
    components: {Field},
    computed: {
      ...mapState(['fields'])
    },

    methods: {
      ...mapActions(['addEmptyField'])
    }
  }
</script>