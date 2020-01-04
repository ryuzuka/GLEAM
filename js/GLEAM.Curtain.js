/*!
 *
 * GLEAM
 * @version 20151224 ryuzuka
 *
 */

window.GLEAM.Curtain = ( function ( window, $ ) {
	'use strct'

	var _callback = null;

	var _$window = $( window ),
		_$curtain = $( '#curtain' ),
		_$line = _$curtain.find( '.line' ),
		_$mask = _$curtain.find( '.mask' ),
		_$emblem = _$curtain.find( '.emblem' ),
		_$black = _$curtain.find( '.black' );

// ------------------------------------------------------------ method
	function openCurtain () {
		TweenMax.to( _$mask, 1.2, { 'top': _$window.height() / 2, 'height': 0, ease: Expo.easeInOut } );
		TweenMax.to( _$emblem, 1.5, { 'opacity': 1, ease:Back.easeIn, onComplete: open } );
	}

	function open () {
		_callback.call( this, { type: 'CURTAIN_OPEN' } );
		TweenMax.to( _$emblem, 0.2, { 'opacity': 0 } );
		TweenMax.to( _$line, 0.2, { 'opacity': 0 } );
		TweenMax.to( _$black.eq(0), 0.3, { 'width': 0, ease: Expo.easeInOut } );
		TweenMax.to( _$black.eq(1), 0.3, { 'left': _$window.width(), 'width': 0, ease: Expo.easeInOut, onComplete: completeCurtain } );
	}

	function completeCurtain () {
		_callback.call( this, { type: 'CURTAIN_COMPLETE_OPEN' } );
		_$curtain.css( 'display', 'none' );
		window.GLEAM.Curtain.resize = function () {
			return false;
		}
	}

	function noneCurtain () {
		_callback.call( this, { type: 'CURTAIN_OPEN' } );
		completeCurtain();
	}

// ------------------------------------------------------- public
	return {
		init: function ( callback ) {
			console.log( 'GLEAM.Curtain.init();' );

			_callback = callback;
		},
		resize: function ( $win ) {
			_$window = $win;
			TweenMax.killTweensOf( _$mask );
			TweenMax.killTweensOf( _$emblem );

			_$curtain.css( { 'width': _$window.width(), 'height': _$window.height() } );
			_$line.css( { 'left': ( _$window.width() - _$line.width() ) / 2 } );
			_$mask.css( 'top', ( _$window.height() - _$mask.height() ) / 2 );
			_$emblem.css( {
				'left': ( _$window.width() - _$emblem.width() ) / 2,
				'top': ( _$window.height() - _$emblem.height() ) / 2
			} );
			_$black.each( function ( index ) {
				$( this ).css( {
					'left': index * _$window.width() / 2,
					'width': _$window.width() / 2
				} );
			} );

			// if ( !SessionStorage.get( 'sessionIndex' ) /*|| ( _gleamIndex == 0 )*/ ) {
			if ( _gleamIndex == 0 ) {
				// alert( '준비중입니다.' );
				openCurtain();
			} else {
				noneCurtain();
			}
		},
		start: function () {
			this.resize();
		}
	};
}( window, jQuery ) );