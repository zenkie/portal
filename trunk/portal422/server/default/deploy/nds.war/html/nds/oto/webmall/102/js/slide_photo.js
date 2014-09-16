
$(document).ready(function(){
	  var slide_w=$(".slide_photo").width();
	  var body_w=$(".body").width();
	  var w=(body_w-slide_w)/2;
	  $(".slide_photo").css("marginLeft",""+w+"px")
	  
	  var h =$(".body").height()-130;
	 var top =( h-$(".slide_photo").height()) /2;
	 $(".slide_photo").css("paddingTop",""+top+"px");
	 //$(".slide_photo").css("height",""+h+"px")
	  
	 setInterval(doNext, "3000");  
	  $(".slide_photo span").click(function(event){	
			event.preventDefault();
			var span_type=this.classList;
			if(span_type=="right")
			{
				doNext();
				
			}
			else{
				doPrev();
			}
	  });
});

var doNext= function(li_on,li_next){
	
	var li_on=$(".slide_photo ul li.on");
	if(li_on.length==0){
		var li_first= 	$(".slide_photo ul li:first");
		li_first.addClass("on");
		li_on=li_first;
	}
	
	var li_next=$(li_on).next();
		
	if(li_next.length==0){
		li_next=$(".slide_photo ul li:first");
	}
			
	li_on.animate({'z-index':'1','left':'40px',"right":'-40px'},"slow");
	li_on.animate({'left':'0px',"right":"0"},"slow");
	li_on.animate({'z-index':'-1'},1)
  	li_next.animate({'z-index':'2','left':'-40px',"right":'40px'},"slow");
	li_next.animate({'left':'0px',"right":"0"},"slow");
	li_on.addClass("addtrans");
	li_on.removeClass("remtrans");

	li_next.removeClass("addtrans");
	li_next.addClass("remtrans");
	
	li_on.removeClass("on");	
	li_next.addClass("on");	
	
	var li_next_next=$(li_next).next();				
	if(li_next_next.length==0){
		li_next_next=$(".slide_photo ul li:first");
	}
	li_next_next.animate({'z-index':'1'},1);
	li_next_next.addClass("addtrans");
	li_next_next.removeClass("remtrans");

}

var doPrev =function(li_on,li_prev){
	
	var li_on=$(".slide_photo ul li.on");
	if(li_on.length==0){
		var li_first= 	$(".slide_photo ul li:first");
		li_first.addClass("on");
		li_on=li_first;
	}
	var li_prev =$(li_on).prev();
	if(li_prev.length==0){
		li_prev =	$(".slide_photo ul li:last");
	}
	li_prev.animate({'z-index':'2','left':'40px',"right":'-40px'},"slow");
	li_prev.animate({'left':'0px',"right":"0"},"slow");
  	li_on.animate({'z-index':'1','left':'-40px',"right":'40px'},"slow");
	li_on.animate({'left':'0px',"right":"0"},"slow");
	
	li_on.addClass("addtrans");
	li_on.removeClass("remtrans");

	li_prev.removeClass("addtrans");
	li_prev.addClass("remtrans");
	
	li_on.removeClass("on");	
	li_prev.addClass("on");
	
	var li_prev_prev=$(li_prev).prev();				
	if(li_prev_prev.length==0){
		li_prev_prev=$(".slide_photo ul li:last");
	}
	li_prev_prev.show();
	li_prev_prev.addClass("addtrans");
	li_prev_prev.removeClass("remtrans");

}

				function classify(){
					$(document).ready(function(){
						  set_classify_li_w();
						  
						  classify=$(".classify").get(0);
						  classify.addEventListener("touchstart", classifyEvt, false);
						  classify.addEventListener("mousedown", classifyEvt, false);
							
						  classify.addEventListener("touchmove", classifyEvt, false);
						  classify.addEventListener("mousemove", classifyEvt, false);
							
						  classify.addEventListener("touchend", classifyEvt, false);
						  classify.addEventListener("mouseup", classifyEvt, false);
						
					
					});
					var classifyEvt = {
						startPos:{x:0, y:0},
						endPos:{x:0, y:0},
						handleEvent: function(evt){
							if(!evt.touches){
								evt.touches = new Array(evt);
								evt.scale = false;
							}
							//document.t = evt.type;
							switch(evt.type){
									case "touchstart":
									case "mousedown":	
										this.startPos.x = evt.touches[0].pageX;
										this.startPos.y = evt.touches[0].pageY;
									break;
									case "touchmove":
									case "mousemove":
										evt.preventDefault();
										this.endPos.x = evt.touches[0].pageX;
										this.endPos.y = evt.touches[0].pageY;	
									break;
									case "touchend":
									case "mouseup":	
										console.log(evt);					
										var directX = (this.startPos.x -this.endPos.x);
										if(directX>10){
											classify_slide("left",directX)
										}
										else if(directX<-10){
											classify_slide("right",directX)
										}
										else{}
									break;
							}
						}	
					}
					function classify_slide(type,dir){
						var ul_w =$(".classify ul").width();
						var ul_li_w =$(".classify ul li").width();
						var body_w=$("body").width();
						var ul_li_x = ul_w-body_w;
						var ul_m =$(".classify ul").css("marginLeft");
						ul_m_int=parseInt(ul_m.replace("px",""));
						if(dir<0){ dir = -dir;}
						var count =(parseInt(dir/ul_li_w) +1);
						dir = count*ul_li_w;
						if(type=="right")
							dir =-count*ul_li_w;;
						
						var ord=ul_li_x+ul_m_int;
						if(ord>=0&ul_m_int<=0&ord<=ul_li_x){
							if(ord>dir){
								ul_m_int_up =ul_m_int-dir;
								if(ul_m_int_up>0){ul_m_int_up=0}
							}
							if(ord<dir){
								ul_m_int_up =-ul_li_x;
							}
							if((ul_m_int==0)&type=="right")
								ul_m_int_up =0;
							
							
							$(".classify ul").animate({'marginLeft':''+ul_m_int_up+'px'},"1000");
						}
							
						
					}
					
					function set_classify_li_w(){
						var classify=$(".classify");
						classify_li_w = classify.width()/4;
						$(".classify li").css("width",""+classify_li_w+"px");
						var ul_w = $(".classify li").length*(classify.width()/4);
						$(".classify ul").css("width",""+ul_w+"px");
						$(".classify ul").css("marginLeft","0px");
					}
				}
				classify();