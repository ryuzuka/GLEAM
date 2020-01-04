/**
 * @author ryuzuka
 */

function Navigator()
{
    var _this = null;
    
    var $nav = null;
    var $arrow0 = null;
    var $arrow1 = null;
    var $center = null;
    
    var arrArrow = [];
    
    var navY = 0;
    
    var navDur = 1;
    
    
    this.init = function(){
        _this = this;
        
        setInstance();
        setArray();
        setResize();
        setArrow();
        setCenter();
        
        setNavY();
        $nav.css({"top":383, "left":0});
        TweenMax.to($nav, 0.8, {css:{"opacity":100},ease:Expo.easeInOut, delay:0});
        
        TweenMax.delayedCall(1, function(){
            //alert("ASD");
            $center.trigger(jQuery.Event("click"));
        });
        TweenMax.delayedCall(3, function(){
            //alert("ASD");
            $center.trigger(jQuery.Event("click"));
        });
    }
    
    function setInstance(){
        $nav = $("#nav");
        $arrow0 = $("#nav .left");
        $arrow1 = $("#nav .right");
        $center = $("#nav .center");
    }
    
    function setArray(){
        arrArrow = [$arrow0, $arrow1];
    }
    
    function setResize(){
       window.addEventListener("resize", function(e){
           onResize();
       });
    }
    
    function onResize(){
        setNavY();
        TweenMax.to($nav, navDur, {css:{"left":navY},ease:Expo.easeInOut});
        navDur = 0.07;
    }
    
    function setNavY(){
        if($(window).width() < 1400 || $(window).width() > 1400)    navY = 549;
        if($(window).width() < 1200)    navY = 349;
        if($(window).width() < 1000)    navY = 200;
    }
    
    function setArrow(){
        for(var i=0; max=arrArrow.length, i<max; i++)
        {
            arrArrow[i].data("index", i);
            arrArrow[i].bind("click", function(e){
                var chkNum = $(this).data("index");
                if(Main.isOpen == false && Main.lineNum == 6)
                {
                    return;
                }
                if(Main.isMove == false) {
                    Main.moveContainer(chkNum);   
                }
            });
        }
    }
    
    
    
    
    function setCenter(){
        $center.bind("click", function(e){
            if(Main.isMove == false)
            {
                if(Main.isHighlight == false)
                {
                    Main.openHighlight();  
                }
            }
        });
    }
     
     
     
    this.toggleArrow = function($visible){
        var i = null;
        
        if($visible == "false"){
            for(i=0; i<arrArrow.length; i++){
                arrArrow[i].css("visibility", "hidden");
            }  
        }
        else if($visible == "true"){
            for(i=0; i<arrArrow.length; i++){
                arrArrow[i].css("visibility", "visible");
            }
        }
    }
    
    
    
    
        /*
        //alert($visible);
        if($visible == true){
            for(i=0; i<arrArrow.length; i++){
                arrArrow[i].css("display", "block");
            }
        }
        else if($visible == false){
            for(i=0; i<arrArrow.length; i++){
                arrArrow[i].css("display", "none");
            }
        }
        */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
