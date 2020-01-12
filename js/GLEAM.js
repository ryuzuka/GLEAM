/*!
 *
 * GLEAM
 * @version 20200107 ksg
 *
 */

var _gleamIndex = null

var Static = {
  url: ['/gleam/GLEAM.html', '/gleam/about.html', '/gleam/work.html', '/gleam/board.html', '/gleam/contact.html'],
  headerHeight: 80,
  footerHeight: 20
}

window.GLEAM = (function(window, $) {
  'use strict'

  // ------------------------------------------------------- handler
  function curtainHandler(e) {
    switch (e.type) {
      case 'CURTAIN_OPEN': // ------------------------- start
        //console.log( 'CURTAIN_OPEN' );

        GLEAM.Ryuzuka.start()
        GLEAM.Header.start()
        GLEAM.Footer.start()
        break
      case 'CURTAIN_COMPLETE_OPEN':
        //console.log( 'CURTAIN_COMPLETE_OPEN' );

        GLEAM.Content.start()
        break
      case 'CURTAIN_CLOSE':
        //console.log( 'CURTAIN_CLOSE' );

        break
    }
  }

  function headerHandler(e) {
    switch (e.type) {
      case 'HEADER_START':
        //console.log( 'HEADER_START' );

        break
      case 'HEADER_END':
        //console.log( 'HEADER_END' );

        _gleamIndex = e.index
        GLEAM.Header.end()
        GLEAM.Ryuzuka.end()
        GLEAM.Footer.end()
        GLEAM.Content.end()
        // GLEAM.Curtain.close()
        break
      case 'HEADER_MENU_CLICK':
        _gleamIndex = e.index
        GLEAM.Header.end()
        GLEAM.Ryuzuka.end()
        GLEAM.Footer.end()
        GLEAM.Content.end()
        break
    }
  }

  function contentHandler(e) {
    switch (e.type) {
      case 'CONTENT_START':
        //console.log( 'CONTENT_START' );
        break
      case 'CONTENT_COMPLETE_START':
        //console.log( 'CONTENT_COMPLETE_START' );
        break
      case 'CONTENT_END':
        //console.log( 'CONTENT_END' );
        break
      case 'CONTENT_COMPLETE_END':
        console.log('CONTENT_COMPLETE_END')
        GLEAM.Curtain.close(function() {
          window.location.href = Static.url[_gleamIndex]
        })
        break
    }
  }

  // ------------------------------------------------------- public
  return {
    init: function() {
      // console.log('GLEAM.init();')

      GLEAM.Curtain.init(curtainHandler)
      GLEAM.Header.init(headerHandler)
      GLEAM.Content.init(contentHandler)
      GLEAM.Ryuzuka.init()
      GLEAM.Footer.init()
      GLEAM.Window.init()

      $(window).trigger('resize') // ---------------------- start
    }
  }
})(window, jQuery)
