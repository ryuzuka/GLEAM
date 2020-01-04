/*!
 *
 * GLEAM
 * @version 20151221 ryuzuka
 *
 */

_gleamIndex = 1;

window.GLEAM.Content = ( function ( window, $ ) {
	'use strict';

	var _callback = null;

	var _$window = null,
		_$content = $( '#content' ),
		_$title = _$content.find( '.title' ),
		_$list = _$content.find( '> ul li' );

	var _animateTitle = null,
		_arrListW = [58, 111, 34, 37, 75, 101, 99, 146];
		
	var _centerX = parseInt( ( $( window ).width() - _$content.width() ) / 2 ),
		_centerY = parseInt( ( ( $( window ).height() + ( Static.headerHeight - Static.footerHeight ) ) - _$content.height() ) / 2 );

// ------------------------------------------------------- public
	return {
		init: function ( callback ) {
			console.log( 'GLEAM.Content.init();' );

			_callback = callback;
			_$content.css( 'visibility', 'visible' );
			TweenMax.to( _$content, 0, { 'transform': 'translate3d( ' + _centerX + 'px, 0px, 0px )' } );
			_animateTitle = _$title.animateTitle();
		},
		resize: function ( $win ) {
			_$window = $win;
			_centerX = parseInt( ( _$window.width() - _$content.width() ) / 2 ),
			_centerY = parseInt( ( ( _$window.height() + ( Static.headerHeight - Static.footerHeight ) ) - _$content.height() ) / 2 );
			TweenMax.to( _$content, 0.8, { 'transform': 'translate3d( ' + _centerX + 'px, ' + '0px, 0px )', ease:Quart.easeInOut } );
		},
		start: function () {
			_animateTitle.start();
			for ( var i = 0; i < _$list.length; ++i ) {
				TweenMax.to( _$list.eq(i), 0.7, { 'width': _arrListW[i], ease: Back.easeInOut, delay: 0.3 } );
			}
		},
		end: function () {
			var completeClose = function () {
				_callback.call( this, { type: 'CONTENT_COMPLETE_END' } );
			}
			_animateTitle.end( completeClose );
			$( 'body' ).css( 'overflow', 'hidden' );
			for ( var i = 0; i < _$list.length; ++i ) {
				TweenMax.to( _$list.eq(i), 0.7, { 'width': 0, ease: Expo.easeInOut } );
			}
		}
	}

}( window, jQuery ) );