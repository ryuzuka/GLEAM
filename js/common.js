/*!
 *
 * GLEAM
 * @version 20160107 ryuzuka
 *
 */

window.SessionStorage = (function(window, $) {
  'use strict'

  return {
    get: function(key) {
      return window.sessionStorage.getItem(key)
    },
    set: function(key, value) {
      window.sessionStorage.setItem(key, value)
    },
    clear: function() {
      window.sessionStorage.clear()
    }
  }
})(window, jQuery)

jQuery.fn.animateTitle = function(options) {
  'use strict'

  var $this = $(this),
    $img = $this.find('img'),
    $bg = $('<div class="bg"></div>'),
    $mask = $('<div class="mask"></div>')

  $this.append($bg).append($mask)
  $mask.append($img)

  $mask.css({ position: 'absolute', overflow: 'hidden', width: '0%' })
  $bg.css({ position: 'absolute', left: '0', top: '0', width: '0', height: '100%', 'background-color': '#ddd' })

  return {
    start: function(completeFunc) {
      TweenMax.to($bg, 0.6, { width: $img.width(), ease: Quart.easeInOut })
      TweenMax.to($mask, 0.8, {
        width: $img.width(),
        ease: Expo.easeOut,
        delay: 0.5,
        onComplete: function() {
          if (completeFunc) {
            completeFunc()
          }
        }
      })
      TweenMax.to($bg, 0.6, { left: $img.width(), width: '0', ease: Expo.easeInOut, delay: 0.8 })
    },
    end: function(completeFunc) {
      TweenMax.to($bg, 0.6, { left: '0%', width: $img.width(), ease: Quart.easeInOut })
      TweenMax.to($mask, 0.8, {
        left: '0',
        width: '0',
        ease: Expo.easeOut,
        delay: 0.5,
        onComplete: function() {
          if (completeFunc) {
            completeFunc()
          }
        }
      })
      TweenMax.to($bg, 0.6, { left: '0', width: '0', ease: Expo.easeInOut, delay: 0.55 })
    }
  }
}
