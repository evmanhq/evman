import _ from 'underscore'

class RestrictionsResolver {
  constructor(event, restrictions) {
    this.event = event
    this.restrictions = restrictions
  }

  resolve() {
    if(!this.restrictions) return true
    if(!this.restrictions === []) return true

    return _.all(this.restrictions, (r) => {
      return this.resolveRestriction(r)
    })
  }

  resolveRestriction(restriction) {
    switch(restriction.type) {
      case 'field':
        return this.resolveField(restriction.id, restriction.condition, restriction.values)
        break;
      case 'event_property':
        return this.resolveEventProperty(restriction.id, restriction.condition, restriction.values)
        break;
      default:
        return true;
    }
  }

  resolveField(name, condition, values) {
    return testCondition(this.event[name], condition, values)
  }

  resolveEventProperty(id, condition, values) {
    let actual = this.event.properties_assignments[id] || []
    actual = actual.map((id) => parseInt(id))
    return this.testCondition(actual, condition, values)
  }

  testCondition(actual, condition, expected_values) {
    switch(condition) {
      case 'equals':
        return actual[0] === expected_values[0]
      case 'not_equals':
        return actual[0] !== expected_values[0]
      case 'includes':
        if(!actual) actual = []
        return _.intersection(actual, expected_values).length > 0
      case 'excludes':
        if(!actual) actual = []
        return _.intersection(actual, expected_values).length == 0
      default:
        return true
    }
  }
}

export default RestrictionsResolver