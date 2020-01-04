/**
 * @author ryuzuka
 */

function Container()
{
    var $rect = null;
    var $doubleRect = null;
    var $doubleRect2 = null;
    var $box18 = null;
    
    var arrRect = [];
    var arrDoubleRect = [];
    
    
    this.init = function(){
        
        setInstance();
        setArray();
        setRect();
        
        Main.lineNum = arrRect.length;
    }
    
    this.intro = function(){
        var h = null;
        var w = null;
        for(var i=0; i<arrRect.length; i++)
        {
            for(var j=0; j<arrRect[i].length; j++)
            {  
                if(arrRect[i][j].data("type") == "double")
                {
                    w = 200;
                    h = 400;
                    TweenMax.to(arrRect[i][j], 0.9,{css:{"width":w, "height":h}, ease:Cubic.easeInOut, delay:0.04*i + 0.04*j});
                }  
                else if(arrRect[i][j].data("type") == "double2")
                {
                    w = 400;
                    h = 200;
                    TweenMax.to(arrRect[i][j], 0.9,{css:{"width":w, "height":h}, ease:Cubic.easeInOut, delay:0.04*i + 0.04*j});
                }         
                else
                {
                    w = 200;
                    h = 200;
                    TweenMax.to(arrRect[i][j], 0.9,{css:{"width":w, "height":h}, ease:Cubic.easeInOut, delay:0.04*i + 0.04*j});
                }
                
            }
        }
    }
    
    function setInstance(){
        $box18 = $("#box18");
        $rect = $(".rect");
        $rect.each(function(i){
            $(this).data("type", "single");
        });
        $doubleRect = $(".doubleRect");
        $doubleRect.each(function(i){
            $(this).data("type", "double");
        });
        $doubleRect2 = $(".doubleRect2");
        $doubleRect2.each(function(i){
            $(this).data("type", "double2");
        });
    }
    
    function setArray(){
        for(var i=0; i<6; i++)
        {
            arrRect[i] = [];
        }
        $rect.each(function(i){
            var group = parseInt(i/4);
            arrRect[group].push($(this));
        });
    }
    
    function setRect(){
        for(var i=0; i<arrRect.length; i++)
        {
            for(var j=0; j<arrRect[i].length; j++)
            {
                arrRect[i][j].css({"left": 200*i, "top":200*j});
                if(i%2 == 0)
                {
                    arrRect[i][j].css({"width":200, "height":0});
                }
                else
                {
                    arrRect[i][j].css({"width":0, "height":200});
                }
                
                if(arrRect[i][j].data("type") == "double")
                {
                    arrRect[i][j].css({"width":200, "height":0});
                }
                if(arrRect[i][j].data("type") == "double2")
                {
                    arrRect[i][j].css({"width":0, "height":0});
                }
            }
        }
    }
    
    this.switchBox18 = function($type){
        if($type == "double")
        {
            $(".desTxt.single").css("display", "none");
            $(".desTxt.double").css("display", "block");
        }
        else if($type == "single")
        {
            $(".desTxt.single").css("display", "block");
            $(".desTxt.double").css("display", "none");
        }
    }
    
    
    
    
    
    
    
    
    
}
