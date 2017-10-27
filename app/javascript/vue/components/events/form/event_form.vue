<template>
  <div>
    <field name="name" label="Name" :required="true"></field>
    <field name="description" label="Description" type="textarea"></field>

    <div class="form-group row">
      <label :class="['col-form-label', labelClass]">Type <b class="text-danger">*</b></label>
      <input type="hidden" :name="fieldName('event_type_id')" :value="event.event_type_id">
      <div :class="[valueClass]">
        <multiselect
            :value="eventType"
            @input="setEventFieldMultiselect('event_type_id', $event)"
            deselect-label=""
            select-label=""
            selected-label=""
            track-by="id"
            label="name"
            :options="event_types"
            :searchable="true"
            :allow-empty="true"
            :multiple="false">
        </multiselect>
      </div>
    </div>

    <div class="form-group row">
      <label :class="['col-form-label', labelClass]">City<b class="text-danger">*</b></label>
      <input type="hidden" :name="fieldName('city_id')" :value="event.city_id">
      <div :class="[valueClass]">
        <multiselect
            :value="city"
            @input="setEventFieldMultiselect('city_id', $event)"
            @search-change="findCities"
            track-by="id"
            label="name"
            placeholder="Search for city"
            :options="cities"
            :searchable="true"
            :internalSearch="false"
            :show-pointer="true"
            :allow-empty="true"
            :loading="citiesLoading"
            :multiple="false">
        </multiselect>
      </div>
    </div>

    <field name="location" label="Location / Venue" :required="true"></field>

    <div class="form-group row">
      <div class="col-xl-6">
        <field name="begins_at" label="Begins" type="datepicker" labelClass="col-xl-4" valueClass="col-xl-8" :required="true"></field>
      </div>
      <div class="col-xl-6">
        <field name="ends_at" label="Ends" type="datepicker" labelClass="col-xl-4" valueClass="col-xl-8" :required="true"></field>
      </div>
    </div>

    <field name="url" label="URL 1"></field>
    <field name="url2" label="URL 2"></field>
    <field name="url3" label="URL 3"></field>
    <field name="sponsorship" label="Sponsorship"></field>
    <field name="sponsorship_date" label="Sponsorship deadline" type="datepicker"></field>
    <field name="cfp_url" label="CFP URL"></field>
    <field name="cfp_date" label="CFP deadline" type="datepicker"></field>

    <div class="form-group row">
      <label :class="['col-form-label', labelClass]">Owner<b class="text-danger">*</b></label>
      <input type="hidden" :name="fieldName('owner_id')" :value="event.owner_id">
      <div :class="[valueClass]">
        <multiselect
            :value="owner"
            @input="setEventFieldMultiselect('owner_id', $event)"
            track-by="id"
            label="name"
            :options="owners"
            :searchable="true"
            :allow-empty="true"
            :multiple="false">
        </multiselect>
      </div>
    </div>

  </div>
</template>

<script>
  import Multiselect from 'vue-multiselect'
  import _ from 'underscore'
  import {mapState, mapGetters} from 'vuex'
  import Field from './field.vue'
  import EventMixin from './event_mixin'

  export default {
    components: {Multiselect, Field},
    mixins: [EventMixin],
    data() {
      return {
        cities: [],
        citiesQueryTimeout: null,
        citiesLoading: false,
        labelClass: 'col-xl-2',
        valueClass: 'col-xl-10'
      }
    },
    computed: {
      city() {
        return this.cities.find((c) => parseInt(c.id) === parseInt(this.event.city_id))
      },

      owner() {
        return this.owners.find((o) => parseInt(o.id) === parseInt(this.event.owner_id))
      }
    },

    methods: {
      findCities(query) {
        if(!query) return
        let delay = 250
        this.citiesLoading = true
        if(this.citiesQueryTimeout) clearTimeout(this.citiesQueryTimeout)

        let loadFn = () => {
          this.$http.get('/geo/cities.json', { params: { fulltext: query }}).then( response => {
            this.cities = response.body || []
            this.citiesLoading = false
          })
        }

        this.citiesQueryTimeout = setTimeout(loadFn, delay)
      },

      loadSelectedCity() {
        if(!this.event.city_id) return

        this.$http.get('/geo/cities.json', { params: { ids: this.event.city_id }}).then( response => {
          this.cities = response.body
        })

      }

    },

    mounted() {
      this.loadSelectedCity()
    }
  }

</script>