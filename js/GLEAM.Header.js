/*!
 *
 * GLEAM
 * @version 20151208 ryuzuka
 *
 */

window.GLEAM.Header = (function(window, $) {
  'use strict'

  var _callback = null

  var _$window = null,
    _$header = $('#header'),
    _$bg = _$header.find('.bg'),
    _$nav = _$header.find('.nav'),
    _$title = _$header.find('.title'),
    _$gnb = _$header.find('.gnb')

  var _$arrMenu = []

  var MENU_GAP = 10

  // ------------------------------------------------------------ handler
  function headerEventHandler(e) {
    switch (e.type) {
      case 'mouseenter':
        switchHeader(true)
        break
      case 'mouseleave':
        switchHeader(false)
        activateMenu(_gleamIndex)
        break
    }
  }

  function titleEventHandler(e) {
    var i = null
    switch (e.type) {
      case 'mouseenter':
        for (i = 0; i < _$arrMenu.length; ++i) {
          _$arrMenu[i].find('img').attr('src', '/gleam/image/menu' + i + '_blue.png')
        }
        break
      case 'mouseleave':
        for (i = 0; i < _$arrMenu.length; ++i) {
          _$arrMenu[i].find('img').attr('src', '/gleam/image/menu' + i + '_off.png')
        }
        activateMenu(_gleamIndex)
        break
      case 'click':
        if (_gleamIndex == 0) {
          return false
        }
        $(this).css('cursor', 'default')
        _callback.call(this, { type: 'HEADER_END', index: 0 })
        return false
        break
    }
  }

  function gnbEventHandler(e) {
    var menuIdx =
      $(this)
        .parent()
        .index() + 1
    switch (e.type) {
      case 'mouseenter':
        activateMenu(menuIdx)
        break
      case 'click':
        if (menuIdx != _gleamIndex) {
          $(this).css('cursor', 'default')
          _callback.call(this, { type: 'HEADER_END', index: menuIdx })
        }
        return false
        break
    }
  }

  // ------------------------------------------------------------ method
  function switchHeader(isOver) {
    TweenMax.killChildTweensOf(_$header)
    if (isOver) {
      TweenMax.to(_$bg, 0.3, { top: -25, ease: Quint.easeOut })
      TweenMax.to(_$title, 0.3, { top: 30, ease: Quint.easeOut })
      TweenMax.to(_$gnb, 0.3, { top: 50, ease: Quint.easeOut })
      TweenMax.to(_$nav, 0.3, { height: 95, ease: Quint.easeOut })
    } else if (!isOver) {
      TweenMax.to(_$bg, 0.3, { top: -40, ease: Strong.easeInOut })
      TweenMax.to(_$title, 0.3, { top: 18, ease: Quint.easeInOut })
      TweenMax.to(_$gnb, 0.3, { top: 35, ease: Quint.easeInOut })
      TweenMax.to(_$nav, 0.3, { height: 80, ease: Strong.easeInOut })
    }
  }

  function activateMenu(idx) {
    var src = null
    for (var i = 0; i < _$arrMenu.length; ++i) {
      src = _$arrMenu[i].find('img').attr('src')
      if (i == idx - 1) {
        _$arrMenu[i].find('img').attr('src', src.replace('_off', '_ccc'))
      } else {
        _$arrMenu[i].find('img').attr('src', src.replace('_ccc', '_off'))
      }
    }
  }

  // ------------------------------------------------------------ public
  return {
    init: function(callback) {
      console.log('GLEAM.Header.init();')

      _callback = callback
      var arrMenuWidth = [54, 48, 55, 75]
      _$gnb.find('li').each(function(index) {
        _$arrMenu[index] = $(this)
        var menuX = 0
        if (index > 0) {
          menuX = parseInt(_$arrMenu[index - 1].css('left')) + parseInt(arrMenuWidth[index - 1]) + MENU_GAP
        }
        $(this).css({ position: 'absolute', left: menuX })
      })
    },
    resize: function($win) {
      _$window = $win
      _$nav.css('left', (_$window.width() - _$nav.width()) / 2)
      TweenMax.to($(this), 0.4, { height: 0, ease: Quint.easeInOut })
    },
    start: function() {
      _callback.call(this, { type: 'HEADER_START' })
      activateMenu(_gleamIndex)
      TweenMax.to(_$bg, 1, { top: -40, ease: Back.easeInOut })
      TweenMax.to(_$title, 0.5, { top: 18, ease: Back.easeOut, delay: 0.6 })
      TweenMax.to(_$gnb, 0.2, {
        top: 35,
        ease: Cubic.easeInOut,
        delay: 0.9,
        onComplete: function() {
          _$header.on('mouseenter mouseleave', headerEventHandler)
          _$title.find('a').on('mouseenter mouseleave click', titleEventHandler)
          _$gnb
            .find('li')
            .find('a')
            .on('mouseenter click', gnbEventHandler)
        }
      })
    },
    end: function() {
      _$header.off('mouseenter mouseleave', headerEventHandler)
      _$gnb.find('li > a').off('mouseenter click', gnbEventHandler)
      TweenMax.to(_$nav, 0.4, { height: 0, ease: Quint.easeInOut })
      TweenMax.to(_$bg, 0.4, { top: -1 * _$bg.height(), ease: Quint.easeInOut })
    }
  }
})(window, jQuery)
