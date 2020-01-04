/*!
 *
 * GLEAM.Ryuzuka
 * @version 20150102 ryuzuka
 *
 */

window.GLEAM.Ryuzuka = ( function ( window, $ ) {
	'use strict';

	var _$window = null,
		_$ryuzukaWrap = $( '#ryuzukaWrap' ),
		_$ryuzuka = _$ryuzukaWrap.find( '.ryuzuka' ),
		_$ryuzuka3d = _$ryuzuka.find( '.ryuzuka3d' );

	var _scale = 0.5,
		_centerX = ( $( window ).width() - _$ryuzuka.width() ) / 2,
		_centerY = ( ( $( window ).height() + ( Static.headerHeight - Static.footerHeight ) ) - _$ryuzuka.height() ) / 2;

	var ANGLE = 40;
	
// ------------------------------------------------------------ handler
	function windowMoveHandler (e) {
		var mouseX = e.clientX - _centerX - ( _$ryuzuka.width() / 2 ),
			mouseY = e.clientY - _centerY - ( _$ryuzuka.height() / 2 );
		var halfWidth = _$window.width() / 2,
			halfHeight = _$window.height() / 2;
		var rotateX = ROTATE_ANGLE( -1 * halfHeight, halfHeight, ANGLE, ANGLE * -1, mouseY ),
			rotateY = ROTATE_ANGLE( -1 * halfWidth, halfWidth, ANGLE *-1, ANGLE, mouseX );
		TweenMax.to( _$ryuzuka3d, 1.2, { 'transform': 'rotateX( ' + rotateX + 'deg ) rotateY( ' + rotateY + 'deg )', ease: Expo.easeOut } );
	}

	function windowDownHandler (e) {
		_$window.off( 'mousemove', windowMoveHandler );
		TweenMax.to( _$ryuzuka, 0.6, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX( 0.9 ) scaleY( 0.9 )', ease: Expo.easeOut } );
		TweenMax.to( _$ryuzuka3d, 0.6, { 'transform': 'rotateX(0) rotateY(0)', ease: Quart.easeOut } );
	}

	function windowUpHandler (e) {
		_$window.on( 'mousemove', windowMoveHandler );
		TweenMax.to( _$ryuzuka, 0.6, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX(1) scaleY(1)', ease: Expo.easeOut } );
		TweenMax.to( _$ryuzuka3d, 0.6, { 'transform': 'rotateX(0) rotateY(0)', ease: Quart.easeOut } );
	}

// ------------------------------------------------------------ method
	function ROTATE_ANGLE ( a, b, c, d, x ) {
		return Math.round( ( d - c ) / ( b - a ) * ( x - a ) + c );
	}

	function onWindowListener () {
		if ( _gleamIndex != 1 ) {
			_$window.on( {
				'mousedown': windowDownHandler,
				'mouseup': windowUpHandler,
				'mousemove': windowMoveHandler
			} );
		}
	}

	function offWindowListener () {
		if ( _$window ) {
			_$window.off( {
				'mousedown': windowDownHandler,
				'mouseup': windowUpHandler,
				'mousemove': windowMoveHandler
			} );
		}
	}

// ------------------------------------------------------- public
	return {
		init: function () {
			console.log( 'GLEAM.Ryuzuka.init();' );
			TweenMax.to( _$ryuzuka, 0, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX(' + 0 + ') scaleY(' + 0 + ')' } );
		},
		resize: function ( $win ) {
			_$window = $win;
			_centerX = ( _$window.width() - _$ryuzuka.width() ) / 2;
			_centerY = ( ( _$window.height() + ( Static.headerHeight - Static.footerHeight ) ) - _$ryuzuka.height() ) / 2;
			if ( _gleamIndex == 1 ) { //about
				_centerY = 180;
			}
			TweenMax.to( _$ryuzuka3d, 0.7, { 'transform': 'rotateX(0) rotateY(0)', ease: Expo.easeOut } );
			TweenMax.to( _$ryuzuka, 0.7, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX(' + _scale + ') scaleY(' + _scale + ')', ease:Quint.easeInOut } );
		},
		start: function () {
			if ( _gleamIndex == 1) { //about
				TweenMax.to( _$ryuzukaWrap, 1, { 'transform': 'translateX( -100px )', ease:Back.easeInOut } );
			}
			_scale = 1;
			TweenMax.to( _$ryuzuka, 0.7, { 'opacity': 0.8, ease:Quad.easeInOut } );
			TweenMax.to( _$ryuzuka, 0.9, { 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX(' + _scale + ') scaleY(' + _scale + ')', ease:Back.easeOut, onComplete: onWindowListener } );
		},
		end: function () {
			offWindowListener();
			TweenMax.to( _$ryuzuka3d, 0.3, { 'transform': 'rotateX(0) rotateY(0)' } );
			TweenMax.to( _$ryuzuka, 0.3, { 'opacity': 0, 'transform': 'translate3d( ' + _centerX + 'px, ' + _centerY + 'px, 0px ) scaleX( 1.5 ) scaleY( 1.5 )' } );
			if ( _gleamIndex == 1 ) {
				TweenMax.to( _$ryuzukaWrap, 0.5, { 'transform': 'translateX( 0px )' } );
				TweenMax.to( _$ryuzuka3d, 0.5, { 'transform': 'rotateX(0) rotateY(0)' } );
			}
		}
	};
}( window, jQuery ) );