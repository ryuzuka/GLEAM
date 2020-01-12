/*!
 *
 * GLEAM
 * @version 20160107 ryuzuka
 *
 */

window.GLEAM.Footer = ( function ( window, $ ) {
	'use strict';

	var _callback = null;

	var _$window = null,
		_$footer = $( '#footer' ),
		_$copyright = _$footer.find( '.copyright' );

	return {
		init: function () {
			console.log( 'GLEAM.Footer.init();' );
		},
		listener: function ( callback ) {
			_callback = callback;
		},
		resize: function ( $win ) {
			_$window = $win;
		},
		start: function () {
			TweenMax.to( _$footer, 0.7, { 'bottom': 0, ease:Back.easeInOut } );
		},
		end: function () {
			TweenMax.to( _$footer, 0.4, { 'bottom': -1 * _$footer.height(), ease:Quint.easeInOut } );
		}
	}
}( window, jQuery ) );