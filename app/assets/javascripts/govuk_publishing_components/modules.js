;(function (global) {
  'use strict'

  var GOVUK = global.GOVUK || {}
  GOVUK.Modules = GOVUK.Modules || {}

  GOVUK.modules = {
    find: function (container) {
      container = container || document

      var modules
      var moduleSelector = '[data-module]'

      modules = container.querySelectorAll(moduleSelector)

      // var ps = document.querySelectorAll('p')
      // var divs = document.querySelector('div')
      // console.log('ps', ps)
      // console.log('divs', divs)
      //
      // var test = Array.prototype.slice.call(ps)
      // test.push(Array.prototype.slice.call(divs))
      // console.log(test)

      // Container could be a module too
      // if (container.is(moduleSelector)) {
      if (container !== document && container.getAttribute('data-module')) {
        modules = modules.add(container) // FIXME
      }

      return modules
    },

    start: function (container) {
      var modules = this.find(container)

      for (var i = 0, l = modules.length; i < l; i++) {
        var element = modules[i]
        var moduleNames = element.getAttribute('data-module').split(' ')

        for (var j = 0, k = moduleNames.length; j < k; j++) {
          var moduleName = camelCaseAndCapitalise(moduleNames[j])
          var started = element.getAttribute('data-' + moduleNames[j] + '-module-started')

          if (typeof GOVUK.Modules[moduleName] === 'function' && !started) {
            // GOV.UK Legacy Modules using jQuery
            if (!GOVUK.Modules[moduleName].prototype.init) {
              new GOVUK.Modules[moduleName]().start($(element))
              element.setAttribute('data-' + moduleNames[j] + '-module-started', true)
            }

            // Vanilla JavaScript GOV.UK Modules and GOV.UK Frontend Modules
            if (GOVUK.Modules[moduleName].prototype.init) {
              new GOVUK.Modules[moduleName](element).init()
              element.setAttribute('data-' + moduleNames[j] + '-module-started', true)
            }
          }
        }
      }

      // eg selectable-table to SelectableTable
      function camelCaseAndCapitalise (string) {
        return capitaliseFirstLetter(camelCase(string))
      }

      // http://stackoverflow.com/questions/6660977/convert-hyphens-to-camel-case-camelcase
      function camelCase (string) {
        return string.replace(/-([a-z])/g, function (g) {
          return g.charAt(1).toUpperCase()
        })
      }

      // http://stackoverflow.com/questions/1026069/capitalize-the-first-letter-of-string-in-javascript
      function capitaliseFirstLetter (string) {
        return string.charAt(0).toUpperCase() + string.slice(1)
      }
    }
  }

  global.GOVUK = GOVUK
})(window)
