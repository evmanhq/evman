import Filterer from 'vue/wrappers/filterer'
import Events from 'vue/wrappers/events/loader'
import Forms from 'vue/wrappers/forms/loader'

import $ from 'jquery'
$.noConflict(true)

const WRAPPERS = {
  'Filterer': Filterer,
  'Events.Form': Events.Form,
  'Forms.Formular': Forms.Formular
}

export default class WrappersLoader {
  static get wrappers() {
    return WRAPPERS
  }

  static load() {
    $('*[data-js]').each(function() {
      WrappersLoader.loadWrapper(this)
    })
  }

  static loadWrapper(element) {
    element = $(element)
    let wrapperKey = element.data('js').render_vue
    let options = element.data('js').render_options

    if(!wrapperKey) return null
    let wrapperClass = WRAPPERS[wrapperKey]
    if(!wrapperClass) return null

    let wrapper = new wrapperClass(element[0], options)
    wrapper.render()

    element.data('js', null)
    element.attr('data-js', null)
  }
}