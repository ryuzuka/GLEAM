/**
 * @author ryuzuka
 */

var Main = function()
{
    
    var header = null;
    var container = null;
    var nav = null;
    var highlight = null;
    
    var $container = null;
    var $highlight = null;
    
    var arrContainerX = [200, 0, -200, -400, -600, -800];
    
    Main.containerIndex = 0;
    Main.lineNum = 0;
    Main.totalLineNum = 6;
    Main.isMove = false;
    Main.isHighlight = false;
    
    Main.isOpen = false;
    var minusIndex = null;
    
    
    this.init = function(){
        initHeader();
        initContainer();
        initNavigator();
        initHighlight();
        
        setResize();
        
        intro();
    }
    
    function initHeader(){
       header = new Header();
       header.init();
    }
    
    function initContainer(){
        container = new Container();
        $container = $("#container");
        container.init();
    }
    
    function initNavigator(){
        nav = new Navigator();
        nav.init();
    }
    
    function initHighlight(){
        $highlight = $("#highlight");
        highlight = new Highlight();
        highlight.init();
    }
    
    function setResize(){
        window.addEventListener("resize", function(e){
            
            if(window.innerWidth < 1000)
            {
                $("#main").css("width", 800);
               Main.lineNum = 3;
               $highlight.css("width", 400);
               $highlight.find(".highlightContainer").css("left", -400);
               container.switchBox18("single");
            }
            if(window.innerWidth > 1000 && window.innerWidth < 1200)
            {
                $("#main").css("width", 1000);
                Main.lineNum = 4;
                $highlight.css("width", 600);
                $highlight.find(".highlightContainer").css("left", -300);
                container.switchBox18("single");
            }
            if(window.innerWidth > 1200 && window.innerWidth < 1400)
            {
                $("#main").css("width", 1200);
                Main.lineNum = 5;
                $highlight.css("width", 600);
                $highlight.find(".highlightContainer").css("left", -300);
                container.switchBox18("single");
            }
            if(window.innerWidth > 1400)
            {
                $("#main").css("width", 1400);
                Main.lineNum = 6;
                $highlight.css("width", 800);
                $highlight.find(".highlightContainer").css("left", -200);
                container.switchBox18("double");
                nav.toggleArrow("false");
            }
            else{
                nav.toggleArrow("true");
            }
            
            if(Main.isOpen == false){
                $highlight.css("left", Main.lineNum*200 + 200);
                minusIndex = 0;
            }
            else if(Main.isOpen == true){
                $highlight.css("left", Main.lineNum*200 + 200 - $highlight.width());
            }
            
            $container.css("left", 200);
            Main.containerIndex = 0;
        });
    }
    
    
    Main.moveContainer = function($chkNum){
        var containerX = parseInt($container.css("left"));
        if($chkNum == 0) {
            Main.containerIndex--;
            if(Main.containerIndex == Main.totalLineNum - Main.lineNum + minusIndex - 1)
            {
                container.switchBox18("single");
            }
            if(Main.containerIndex < 0){
                Main.containerIndex = 0;
                return;
            }
        }
        else
        {
            Main.containerIndex++;
            if(Main.containerIndex > Main.totalLineNum - Main.lineNum + minusIndex - 1){
                container.switchBox18("double");
            }
            if(Main.containerIndex > Main.totalLineNum - Main.lineNum + minusIndex){
                Main.containerIndex = Main.totalLineNum - Main.lineNum + minusIndex;
                return;
            }
        }

            Main.isMove = true;
        TweenMax.to($container,0.5,{css:{"left":arrContainerX[Main.containerIndex]}, ease:Expo.easeInOut, onComplete:function(){
            Main.isMove = false;
        }});
    }
    
    
    Main.openHighlight = function(){
        Main.isHighlight = true;
        
        var posLeft = $highlight.offset().left - $highlight.width();
        TweenMax.to($container,0.9,{css:{"left":200}, ease:Expo.easeInOut});
        
        if(Main.isOpen == false){
            Main.isOpen = true;
            Main.containerIndex = 0;
            minusIndex = $highlight.width()/100/2;
            TweenMax.to($highlight, 1, {css:{"left" : Main.lineNum*200 + 200 - $highlight.width()}, ease:Expo.easeInOut, onComplete:function(){
                Main.isHighlight = false;
            }});
        }
        else if(true){
            minusIndex = 0;
            Main.containerIndex = 0;
            if(Main.lineNum == 6){
                container.switchBox18("double");
            }
            else{
                container.switchBox18("single");
            }
            
             TweenMax.to($highlight, 1, {css:{"left" : Main.lineNum*200 + 200}, ease:Expo.easeInOut, onComplete:function(){
                Main.isOpen = false;
                Main.isHighlight = false;
            }});
        }
    }
    
    
    
    
    
    function intro(){
        header.intro();
        container.intro();
    }
    
    
}
