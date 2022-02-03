/* global nodeListForEach */
//  = require ../vendor/polyfills/common.js
// This component relies on JavaScript from GOV.UK Frontend
// = require govuk/components/accordion/accordion.js
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {}
window.GOVUK.Modules.GovukAccordion = window.GOVUKFrontend.Accordion;

(function (Modules) {
  function GemAccordion ($module) {
    this.$module = $module
    this.sectionClass = 'govuk-accordion__section'
    this.sectionHeaderClass = 'govuk-accordion__section-header'
    this.sectionInnerContent = 'govuk-accordion__section-content'

    // Translated component content and language attribute pulled from data attributes
    this.$module.actions = {}
    this.$module.actions.locale = this.$module.getAttribute('data-locale')
    this.$module.actions.showText = this.$module.getAttribute('data-show-text')
    this.$module.actions.hideText = this.$module.getAttribute('data-hide-text')
    this.$module.actions.showAllText = this.$module.getAttribute('data-show-all-text')
    this.$module.actions.hideAllText = this.$module.getAttribute('data-hide-all-text')
    this.$module.actions.thisSectionVisuallyHidden = this.$module.getAttribute('data-this-section-visually-hidden')
  }

  GemAccordion.prototype.init = function () {
    // Indicate that JavaScript has worked
    this.$module.classList.add('gem-c-accordion--active')

    // Feature flag for anchor tag navigation used on manuals
    if (this.$module.getAttribute('data-anchor-navigation') === 'true') {
      this.openByAnchorOnLoad()
      this.addEventListenersForAnchors()
    }
  }

  // Navigate to and open accordions with anchored content on page load if a hash is present
  GemAccordion.prototype.openByAnchorOnLoad = function () {
    var splitHash = window.location.hash.split('#')[1]

    if (window.location.hash && document.getElementById(splitHash)) {
      this.openForAnchor(splitHash)
    }
  }

  // Add event listeners for links to open accordion sections when navigated to using said anchor links on the page
  // Adding an event listener to all anchor link a tags in an accordion is risky but we circumvent this risk partially by only being a layer of accordion behaviour instead of any sort of change to link behaviour
  GemAccordion.prototype.addEventListenersForAnchors = function () {
    var links = this.$module.querySelectorAll('.' + this.sectionInnerContent + ' a[href*="#"]')
    nodeListForEach(links, function (link) {
      if (link.pathname === window.location.pathname) {
        link.addEventListener('click', this.openForAnchor.bind(this, link.hash.split('#')[1]))
      }
    }.bind(this))
  }

  // Find the parent accordion section for the given id and open it
  GemAccordion.prototype.openForAnchor = function (hash) {
    var target = document.getElementById(hash)
    var $section = this.getContainingSection(target)
    var $header = $section.querySelector('.' + this.sectionHeaderClass)
    // Pass the selected section to "Accordion.prototype.onSectionToggle" to open
    $header.click()
  }

  // Loop through the given id's ancestors until the parent section class is found
  GemAccordion.prototype.getContainingSection = function (target) {
    while (!target.classList.contains(this.sectionClass)) {
      target = target.parentElement
    }
    return target
  }

  GemAccordion.prototype.filterLocale = function (key) {
    if (this.$module.actions.locale && this.$module.actions.locale.indexOf('{') !== -1) {
      var locales = JSON.parse(this.$module.actions.locale)
      return locales[key]
    } else if (this.$module.actions.locale) {
      return this.$module.actions.locale
    }
  }

  Modules.GemAccordion = GemAccordion
})(window.GOVUK.Modules)
