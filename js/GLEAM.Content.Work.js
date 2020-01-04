/*!
 *
 * GLEAM
 * @version 20151229 ryuzuka
 *
 */

'use strict';

_gleamIndex = 2;

window.GLEAM.Content = ( function ( window, $ ) {
	'use strict';

	var _callback = null;

	var _$window = null,
		_$content = $( '#content' );

	var _centerX = parseInt( ( $( window ).width() - _$content.width() ) / 2 ),
		_centerY = parseInt( ( ( $( window ).height() + ( Static.headerHeight - Static.footerHeight ) ) - _$content.height() ) / 2 );

// ------------------------------------------------------- public
	return {
		init: function ( callback ) {
			console.log( 'GLEAM.Content.init();' );

			_callback = callback;
			TweenMax.to( _$content, 0, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px )' } );
			_$content.css( 'visibility', 'visible' );
		},
		resize: function ( $win ) {
			_$window = $win;

			_centerX = parseInt( ( _$window.width() - _$content.width() ) / 2 );
			_centerY = parseInt( ( ( _$window.height() + ( Static.headerHeight - Static.footerHeight ) ) - _$content.height() ) / 2 );
			if ( _centerY < 90 ) {
				_centerY = 90;
			}
			TweenMax.to( _$content, 0.5, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px )', ease:Quart.easeInOut } );
		},
		start: function () {
			_callback.call( this, { type: 'CONTENT_START' } );
		},
		end: function () {
			_callback.call( this, { type: 'CONTENT_COMPLETE_END' } );
		}
	}
}( window, jQuery ) );