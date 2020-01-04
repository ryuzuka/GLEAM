/*!
 *
 * GLEAM
 * @version 20151218 ryuzuka
 *
 */

window.GLEAM.Window = (function(window, $) {
  'use strict'

  var _$window = $(window)

  // ------------------------------------------------------- handler
  function windowResizeHandler(e) {
    GLEAM.Ryuzuka.resize(_$window)
    GLEAM.Curtain.resize(_$window)
    GLEAM.Header.resize(_$window)
    GLEAM.Footer.resize(_$window)
    GLEAM.Content.resize(_$window)
    return false
  }

  function windowUnloadHandler(e) {
    SessionStorage.set('sessionIndex', _gleamIndex)
    return false
  }

  return {
    init: function() {
      console.log('GLEAM.Window.init();')

      _$window.on({
        resize: windowResizeHandler,
        unload: windowUnloadHandler
      })
      _$window.trigger('resize')
    },
    resize: function() {
      _$window.trigger('resize')
    },
    locationHref: function(index) {
      window.location.href = Static.url[index]
    }
  }
})(window, jQuery)
