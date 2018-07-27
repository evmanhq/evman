<template>
  <div>
    <div class="nav nav-tabs">
      <div class="nav-item">
        <a href="#" :class="{'nav-link': true, 'active': isForm}" @click.prevent="view = 'form'">Write</a>
      </div>
      <div class="nav-item">
        <a href="#" :class="{'nav-link': true, 'active': isPreview}" @click.prevent="view = 'preview'">Preview</a>
      </div>

      <div class="spacer"></div>

      <a v-show="isForm" class="btn btn-light cursor-pointer font-weight-bold" @click="bold">B</a>
      <a v-show="isForm" class="btn btn-light cursor-pointer font-italic" @click="italic">I</a>
      <a v-show="isForm" class="btn btn-light cursor-pointer" @click="strike">S</a>
    </div>

    <textarea 
      v-show="isForm" 
      :name="name"
      :value="value" 
      ref="input"
      @input="$emit('input', $event.target.value)" class="form-control"></textarea>
    <div v-show="isPreview" v-html="markdownedValue" class="border preview"></div>
  </div>
</template>

<script>
import marked from 'marked'
import escaper from 'utils/escaper'
export default {
  props: ['name', 'value'],
  data () {
    return {
      view: 'form'
    }
  },

  methods: {
    bold() {
      this.modifySelection((s) => `**${s}**`)
    },

    italic() {
      this.modifySelection((s) => `_${s}_`)
    },

    strike() {
      this.modifySelection((s) => `~~${s}~~`)
    },

    modifySelection(modifier) {
      let ta = this.$refs.input
      let val = ta.value
      let from = ta.selectionStart
      let to = ta.selectionEnd
      let selected = val.slice(from, to)
      if(selected.length === 0) return
      let formatted = modifier(selected)
      let new_val = `${val.slice(0, from)}${formatted}${val.slice(to,val.length)}`
      ta.value = new_val
      this.$emit('input', new_val)
    },

    updateValue(event) {
      this.$emit('input', event.target.value)
    }
  },

  computed: {
    isForm() { return this.view == 'form' },
    isPreview() { return this.view == 'preview' },
    markdownedValue () {
      if(!this.value) return "Nothing to preview"
      return marked(escaper.escape(this.value))
    }
  }
}
</script>

<style scoped>
textarea {
  min-height: 120px;
}

.preview {
  padding: 0.375rem 0.75rem;
}

.spacer {
  flex-grow: 1;
}
</style>
