import objectToFormData from 'object-to-formdata'

let CSRF = {
  token: function () {
    let token = document.querySelector('meta[name="csrf-token"]');
    return token && token.getAttribute('content');
  },
  param: function () {
    let param = document.querySelector('meta[name="csrf-param"]');
    return param && param.getAttribute('content');
  }
};

class Navigation {
  static visit({url, method, data}) {
    method = (method || 'GET').toUpperCase()
    if(method !== 'GET')
      return Navigation.visitUsingForm(url, method, data)

    let formData = objectToFormData(data)
    let queryString = [...formData].map( ([n,v]) => `${n}=${v}` ).join('&')

    if(url.indexOf('?') >= 0)
      url += `&${encodeURI(queryString)}`
    else
      url += `?${encodeURI(queryString)}`

    if(typeof Turbolinks !== 'undefined')
      Turbolinks.visit(url)
    else
      window.location = url
    return true
  }

  static visitUsingForm(url, method, data) {
    if (CSRF.param() && CSRF.token()) {
      data[CSRF.param()] = CSRF.token();
    }

    let formData = objectToFormData(data)
    let form = document.createElement('form')
    form.method = 'POST'
    form.action = url
    form.style.display = 'none'

    if (method !== 'POST') {
      let input = document.createElement('input');
      input.setAttribute('type', 'hidden');
      input.setAttribute('name', '_method');
      input.setAttribute('value', method);
      form.appendChild(input);
    }

    for ([name, value] of formData) {
      let input = document.createElement('input');
      input.setAttribute('type', 'hidden');
      input.setAttribute('name', name);
      input.setAttribute('value', value);
      form.appendChild(input);
    }

    document.body.appendChild(form);
    form.submit();
    return true;
  }
}

export default Navigation