import {Wrapper, Vue} from 'vue/wrappers/wrapper'
import Editor from 'vue/components/markdown_editor/editor'

export default class MarkdownEditor extends Wrapper {
  render () {
    super.render()

    const vueApp = new Vue({
      el: this.container,
      data: {
        name: this.options.name,
        value: this.options.value
      },
      components: { 
        'MarkdownEditor': Editor
       }
    })
  }
}