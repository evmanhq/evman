import _ from 'underscore'

// List of HTML entities for escaping.
const escapeMap = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#x27;'
};
const unescapeMap = _.invert(escapeMap);

// Functions for escaping and unescaping strings to/from HTML interpolation.
const createEscaper = function (map) {
  const escaper = function (match) {
    return map[match];
  };
  // Regexes for identifying a key that needs to be escaped.
  const source = '(?:' + _.keys(map).join('|') + ')';
  const testRegexp = RegExp(source);
  const replaceRegexp = RegExp(source, 'g');
  return function (string) {
    string = string == null ? '' : '' + string;
    return testRegexp.test(string) ? string.replace(replaceRegexp, escaper) : string;
  };
};

export default {
  escape: createEscaper(escapeMap),
  unescape: createEscaper(unescapeMap)
}