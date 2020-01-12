/*!
 *
 * GLEAM
 * @version 20200111 ryuzuka
 *
 */

_gleamIndex = 0

window.GLEAM.Content = (function(window, $) {
  'use strict'

  var _callback = null

  var _$window = null,
    _$content = $('#content'),
    _$title = _$content.find('.title'),
    _$list = _$content.find('> ul li')

  var _animateTitle = null,
    _centerX = parseInt(($(window).width() - _$content.width()) / 2),
    _centerY = parseInt(($(window).height() + (Static.headerHeight - Static.footerHeight) - _$content.height()) / 2)

  var _arrMT = [10, 23, 20, 2, 2, 18]
  // ------------------------------------------------------- public
  return {
    init: function(callback) {
      console.log('GLEAM.Content( main ).init();')

      _callback = callback
      _$content.css('visibility', 'visible')
      TweenMax.to(_$content, 0, { transform: 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px )' })
      _animateTitle = _$title.animateTitle()

      _$list.each(function(index) {
        $(this).css({ opacity: 0, 'margin-top': 0 })
        _$title.css('left', (_$title.parent().width() - _$title.width()) / 2)
      })
    },
    resize: function($win) {
      _$window = $win

      _centerX = parseInt((_$window.width() - _$content.width()) / 2)
      _centerY = parseInt((_$window.height() + (Static.headerHeight - Static.footerHeight) - _$content.height()) / 2)
      if (_centerY < 90) {
        _centerY = 90
      }
      TweenMax.to(_$content, 0.5, { transform: 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px )', ease: Quart.easeInOut })
    },
    start: function() {
      _animateTitle.start()
      for (var i = 0; i < _$list.length; ++i) {
        TweenMax.to(_$list.eq(i), 0.5, {
          opacity: 1,
          'margin-top': _arrMT[i],
          ease: Back.easeOut,
          delay: 0.3 + 0.04 * i,
          onCompleteParams: [i],
          onComplete: function(index) {
            if (index == _$list.length - 1) {
              _callback.call(this, { type: 'CONTENT_COMPLETE_START' })
            }
          }
        })
      }
    },
    end: function() {
      var completeEnd = function() {
        _callback.call(this, { type: 'CONTENT_COMPLETE_END' })
      }
      _animateTitle.end(completeEnd)
      for (var i = 0; i < _$list.length; ++i) {
        TweenMax.to(_$list.eq(i), 0.2, { opacity: 0, 'margin-top': 0, ease: Expo.easeOut, delay: 0.3 + 0.02 * i })
      }
    }
  }
})(window, jQuery)
