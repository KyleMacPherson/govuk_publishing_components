/* eslint-env jquery */

// This adds in javascript that initialises components and dependencies
// that are provided by Slimmer in public frontend applications.
// = require jquery/dist/jquery
// = require ./modules.js

var useJquery = useJquery || true

if (useJquery) {
  console.log('using jQuery')
  $(document).ready(function () {
    'use strict'

    window.GOVUK.modules.start()
  })
} else {
  console.log('not using jQuery')
  document.addEventListener("DOMContentLoaded", function() {
    window.GOVUK.modules.start()
  })
}
