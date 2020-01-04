/**
 * @author Ryuzuka
 */



$(document).ready(function(){
	footerBanner = new FooterBanner();
	footerBanner.init();
});




var footerBanner = null;



function FooterBanner(){
	
	var timer = null;
	
	var arrArrow = [];
	var arrBanner = [];
	var arrActualBanner = [];
	
	var imgNum = 0;
	var isMove = false;
	
	var VIEW_LENGTH = 4;	
	var IMG_WIDTH = 190;
	var IMG_GAP = 40;
	
	FooterBanner.prototype.init = function(){
		imgNum = $(".als-viewport").find("img").length;

		$(".als-viewport").find("img").each(function(i){
			arrBanner[i] = $(this);
			arrBanner[i].data("index", i);
			arrBanner[i].css("left", (IMG_WIDTH + IMG_GAP)*i);
		});

		$(".controller").find("div").each(function(i){
			arrArrow[i] = $(this);
			arrArrow[i].data("index", i);
		});

		for(var i=0, max=VIEW_LENGTH; i<max; i++)
		{
			arrActualBanner[i] = arrBanner[i];
		}
		
		setEvent();
		arrArrow[0].trigger("mouseleave", startTimer);
	}
	
	
	function setEvent(){
		var i = null;
		for(i=0, max=arrArrow.length; i<max; i++)
		{
			arrArrow[i].bind("click", clickArrow);
			arrArrow[i].bind("mouseenter", stopTimer);
			arrArrow[i].bind("mouseleave", startTimer);
		}
		for(i=0, max=arrBanner.length; i<max; i++)
		{
			arrBanner[i].bind("mouseenter", stopTimer);
			arrBanner[i].bind("mouseleave", startTimer);
		}
	}
	
	function clickArrow(e){
		var chkNum = $(this).data("index");
		var addIndex = null;
		if(isMove == false)
		{
			isMove = true;
			if(chkNum == 0)
			{
				addIndex = arrActualBanner[0].data("index") - 1;
				if(addIndex<0){
					addIndex = imgNum - 1;
				}
			}
			else
			{
				addIndex = arrActualBanner[arrActualBanner.length-1].data("index") + 1;
				if(addIndex>imgNum-1){
					addIndex = 0;
				}
			}
			addBanner(chkNum, addIndex);
			moveBanner(chkNum);
		}
	}
	
	function startTimer(e){
		timer = setInterval(function(){
			arrArrow[1].trigger("click", clickArrow);
		}, 3000);
	}
	function stopTimer(e){
		clearInterval(timer);
	}
	
	function addBanner($chkNum, $addIndex){
		var addX = null;
		if($chkNum == 0)
		{
			addX = -230;
			arrActualBanner.unshift(arrBanner[$addIndex]);
		}
		else
		{
			addX = 920;
			arrActualBanner.push(arrBanner[$addIndex]);
		}
		arrBanner[$addIndex].css("left", addX);
	}
	
	function moveBanner($chkNum){
		var moveDis = null;
		
		if($chkNum == 0)
		{
			moveDis = 230;	
		}
		else
		{
			moveDis = -230;
		}
		
		for(var i=0, max=arrActualBanner.length; i<max; i++)
		{
			TweenMax.to(arrActualBanner[i],0.9, {css:{left:parseInt(arrActualBanner[i].css("left")) + moveDis}, ease:Quint.easeInOut});
		}
		
		TweenMax.delayedCall(0.9, function(){
			if($chkNum == 0)
			{
				arrActualBanner.pop();
			}
			else
			{
				arrActualBanner.shift();
			}
			isMove = false;
		});
	}
}





