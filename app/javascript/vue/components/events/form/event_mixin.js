import {mapState, mapGetters} from 'vuex'
export default {
  computed: {
    ...mapState(['record_name', 'event', 'event_types', 'owners']),
    ...mapGetters(['eventType'])
  },
  methods: {
    setEventField(name, value) {
      this.$store.commit('setEventField', {name, value})
    },

    setEventFieldMultiselect(name, payload) {
      let id = payload ? payload.id : null
      this.$store.commit('setEventField', {name, value: id })
    },

    fieldName(name) {
      return `${this.record_name}[${name}]`
    }
  }
}