<template>
  <div>
    <event-property
        v-for="(event_property, index) in visibleProperties"
        :key="index"
        :definition="event_property">
    </event-property>
  </div>
</template>

<script>
  import RestrictionsResolver from './restrictions_resolver'
  import EventProperty from './event_property.vue'
  import {mapGetters} from 'vuex'
  export default {
    components: { EventProperty },
    computed: {
      ...mapGetters(['visibleProperties'])
    }
  }

</script>