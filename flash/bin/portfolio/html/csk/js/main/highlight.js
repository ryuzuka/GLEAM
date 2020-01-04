/**
 * @author ryuzuka
 */



function Highlight(){
    
    var $controller = null;
    var $highlightImg = null;
    var $title = null;
    var $bgContainer = null;
    
    var arrController = [];
    var arrTitle = [];
    var arrHighlightImg = [];
    var arrContainerX = [0, -1200, -2400];
    
    var timer = null;
    
    var length = 3;
    var chkIndex = 0;
    
    
    this.init = function(){
        setInstance();
        setHighlightImg();
        setTitle();
        setController();
        
        arrController[chkIndex].trigger(jQuery.Event("click"));
        arrController[chkIndex].trigger(jQuery.Event("mouseenter"));
    }
    
    function setInstance(){
        $controller = $(".controller");
        $highlightImg = $(".highlightImg");
        $title = $(".titleContainer .title");
        $bgContainer = $(".bgContainer");
    }
    
    function setHighlightImg(){
        $highlightImg.each(function(i){
			arrHighlightImg[i] = $(this);
        });
    }
    
    function setTitle(){
        $title.each(function(i){
            arrTitle[i] = $(this);
        });
    }
    
    function setController(){
        $controller.find("li").each(function(i){
        	arrController[i] = $(this);
            $(this).data("index", i);
            $(this).bind("mouseenter", controllerMouseEvent);
            $(this).bind("mouseleave", controllerMouseEvent);
            $(this).bind("click", controllerMouseEvent);
        });
    }
    function controllerMouseEvent(e){
        var chkNum = $(this).data("index");
        
        switch(e.type)
        {
            case "mouseenter":
            		clearTimeout(timer);
            		onController(chkNum);
                break;
           case "mouseleave":
           			timer = setTimeout(function(){
           				onController(chkIndex);
           			},300);
                break;
           case "click":
           			chkIndex = chkNum;
                    onTitle(chkIndex);
                    TweenMax.to($bgContainer, 0.7, {css:{"left":arrContainerX[chkIndex]}, ease:Cubic.easeInOut});
                break;
        }
    }
    
    function onTitle($chkIndex){
    	for(var i=0; max=arrTitle.length, i<max; i++)
    	{
    		if(i == $chkIndex)
    		{
    			TweenMax.to(arrTitle[i], 0.5, {css:{"opacity":1}, ease:Expo.easeInOut});
    		}
    		else
    		{
    			TweenMax.to(arrTitle[i], 0.5, {css:{"opacity":0}, ease:Expo.easeInOut});
    		}
    	}
    }
        
    function onController($chkIndex){
    	for(var i=0; max=arrTitle.length, i<max; i++)
    	{
    		if(i == $chkIndex)
    		{
    			arrController[i].find(".on").css("display", "block");
    			arrController[i].find(".off").css("display", "none");
    		}
    		else
    		{
    			arrController[i].find(".off").css("display", "block");
    			arrController[i].find(".on").css("display", "none");
    		}
    	}
    }
    
    
    
    
    
    
}