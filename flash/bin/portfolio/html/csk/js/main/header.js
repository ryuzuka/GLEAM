/**
 * @author ryuzuka
 */



function Header(){
    
    var $header = null;
    
    
    var $depth1 = null;
    
    var $logo = null;
    
    var depth1Index = 100;
    var depth2Index = 100;
    
    var arrDepth1 = [];
    var arrDepth2 = [];
    var arrDepth2Height = [];
    
    var depth1Timer = null;
    var depth2Timer = null;
    var depth2depth1Timer = null;
    
    
    this.init = function(){
        
        setInstance();
        setMenu();
        
        $header.css("overflow", "hidden");
        $header.css("width", 0);
        
        if(depth1Index > arrDepth2.length-1)
        {
            return;
        }
        if(depth2Index > arrDepth2[depth1Index].length-1)
        {
            return;
        }
        arrDepth2[depth1Index][depth2Index].trigger(jQuery.Event("mouseenter"));
    }
    
    this.intro = function(){
        TweenMax.to($header, 0.9, {css:{"width":200}, ease:Cubic.easeInOut});
    }
    
    
    function setInstance(){
        $header = $("#header");
        $logo = $(".logo");
        $depth1 = $(".depth1");
    }
    
    function setMenu(){
         $depth1.each(function(i){
             var depth2Height = 0;
             
             arrDepth1[i] = $(this);
             depth2Height = arrDepth1[i].find(".depth2").css("height");
             if(depth2Height == undefined){
                depth2Height = 0 + "px";
             }
             arrDepth2Height[i] = depth2Height;
             arrDepth1[i].find(".depth2").css("height", 0);
             
             arrDepth1[i].data("index", i);
             arrDepth1[i].find(".menu").data("index", i);
             arrDepth1[i].bind("mouseenter", depth1MouseEvent);
             arrDepth1[i].bind("mouseleave", depth1MouseEvent);
             arrDepth1[i].find(".menu").bind("click", depth1MouseEvent);
             
             arrDepth2[i] = [];
             
             arrDepth1[i].find(".depth2 li").each(function(j){
                 arrDepth2[i][j] = $(this);
                 arrDepth2[i][j].data("depth1Index", i);
                 arrDepth2[i][j].data("depth2Index", j);
                 arrDepth2[i][j].bind("mouseenter", depth2MouseEvent);
                 arrDepth2[i][j].bind("mouseleave", depth2MouseEvent);
                 arrDepth2[i][j].bind("click", depth2MouseEvent);
             });
        });
    }
    
    function depth1MouseEvent(e){
        var chkNum = $(this).data("index");
        switch(e.type)
        {
            case "mouseenter":
                    clearInterval(depth1Timer);
                    onDepth1(chkNum);
                break;
            case "mouseleave":
                    depth1Timer = setTimeout(function(){
                        onDepth1(depth1Index);
                    },300);
                break;
            case "click":
                    depth1Index = chkNum;
                break;
        }
    }
    
    function depth2MouseEvent(e){
        var chkIndex = $(this).data("depth1Index");
        var chkNum = $(this).data("depth2Index");
        
        switch(e.type)
        {
            case "mouseenter":
                    clearInterval(depth2Timer);
                    onDepth2(chkIndex, chkNum);
                break;
            case "mouseleave":
                    depth2Timer = setTimeout(function(){
                        onDepth2(depth1Index, depth2Index);   
                    },300);
                break;
            case "click":
                    depth1Index = chkIndex;
                    depth2Index = chkNum;
                break;
        }
    }
    
    function onDepth1($depth1Index){
        for(var i=0; max=arrDepth1.length, i<max; i++)
        {
            if(i == $depth1Index)
            {
                arrDepth1[i].find(".menu img").attr("src", arrDepth1[i].find(".menu img").attr("src").replace("off", "on"));
                TweenMax.to(arrDepth1[i].find(".depth2"), 0.2, {css:{"height":arrDepth2Height[i]}});
            }
            else
            {
                arrDepth1[i].find(".menu img").attr("src", arrDepth1[i].find(".menu img").attr("src").replace("on", "off"));
                TweenMax.to(arrDepth1[i].find(".depth2"), 0.3, {css:{"height":0}});
            }
        }
    }
    
    function onDepth2($depth1Index, $depth2Index){
        
        for(var i=0; i<arrDepth2.length; i++)
        {
            for( var j=0; j<arrDepth2[i].length; j++)
            {
                arrDepth2[i][j].find("img").attr("src", arrDepth2[i][j].find("img").attr("src").replace("on", "off"));
            }
        }
        
        if($depth1Index > arrDepth2.length-1)
        {
            return;
        }
        if($depth2Index > arrDepth2[$depth1Index].length-1)
        {
            return;
        }
        
        for(var i=0; i<arrDepth2[$depth1Index].length; i++)
        {
            if(i == $depth2Index)
            {
                arrDepth2[$depth1Index][i].find("img").attr("src", arrDepth2[$depth1Index][i].find("img").attr("src").replace("off", "on"));
            }
            else
            {
                arrDepth2[$depth1Index][i].find("img").attr("src", arrDepth2[$depth1Index][i].find("img").attr("src").replace("on", "off"));
            }
        }
    }
    
    
    
}