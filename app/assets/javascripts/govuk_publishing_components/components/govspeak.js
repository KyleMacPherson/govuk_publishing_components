window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.Govspeak = function () {
    this.start = function ($element) {
      if (!$element.hasClass('disable-youtube')) {
        this.embedYoutube($element)
      }
    }

    this.embedYoutube = function ($element) {
      var enhancement = new window.GOVUK.GovspeakYoutubeLinkEnhancement($element)
      enhancement.init()
    }
  }
})(window.GOVUK.Modules)
