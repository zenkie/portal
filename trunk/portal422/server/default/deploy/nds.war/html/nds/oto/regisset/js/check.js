$(document).ready(function(){
var save={};
var obj={};

function switchName(oob){
	switch(oob.TYPE){
			case "image":
				
				var objj = jQuery('<div class=\"cont-bottom\">'+
				'<div class=\"cont-bottom-r\"><label id=\"name\">'+oob.NAME+'</label></div>'+
				'<div class=\"cont-bottom-l\"><a><img src=\"images/photo.png\" width=\"40\"  height=\"40\"/></a></div>'+
				'</div>');
			 obj['\"'+oob.NAME+'\"']=objj;
			break;
			case "datetime":
				var objj = jQuery('<div class=\"cont-birth\">'+
						'<div class=\"cont-birth-r\"><label id=\"birth\">'+oob.NAME+'</label></div>'+

						'<div class=\"cont-birth-l\"><div class=\"cont-birth-l-y\"><select id="selectYear"></select></div>'+
        				'<div class=\"cont-birth-l-m\"><select id="selectMonth"></select></div>'+
                       '<div class=	\"cont-birth-l-d\"><select id="selectDate"></select></div>'+
					'</div></div>');
			  
			  obj['\"'+oob.NAME+'\"']=objj;				  
			break;
			case "address":
				var objj = jQuery('<div class=\"cont-birth\">'+
						'<div class=\"cont-birth-r\"><label id=\"birth\">'+oob.NAME+'</label></div>'+

						'<div class=\"cont-birth-l\"><div class=\"cont-birth-l-y\"><select id=\"province\"></select></div>'+
        				'<div class=\"cont-birth-l-m\"><select id=\"city\"></select></div>'+
                       '<div class=	\"cont-birth-l-d\"><select id=\"regionId\"></select></div>'+
					'</div></div>');
			  
			  obj['\"'+oob.NAME+'\"']=objj;
			break;
			case "select":
				var  arr=oob.OPTIONAL.split("/");
				var objj='<div class=\"cont-sex\">'+'<div class="cont-sex-r"><label id="sex">'+oob.NAME+' :</label></div>'+
				'<div class=\"cont-sex-l\"><select>';
				for(var i=0;i<arr.length;i++){
					objj+='<option>'+arr[i]+'</option>'
				}
				objj+="</select></div></div>"; 
			  var bb=jQuery(objj);
			  obj['\"'+oob.NAME+'\"']=bb;
					
			break;
			case "text":
				var objj = jQuery('<div class=\"cont-top\">'+
				'<div class=\"cont-top-r\"><label id=\"phone\">'+oob.NAME+' :</label></div>'+
				'<div class=\"cont-top-l\"><input type=\"text\" /></div>'+
				'</div>');
				obj['\"'+oob.NAME+'\"']=objj;
				break;
				
		}
}

window.onload=function(){
	var con=jQuery("#ddd").val();
	if(con != ""){
		var conjson=eval("("+con+")");
		for(var key in conjson){
		   jQuery("li input[name="+key+"]").attr("checked","checked");
		}
	}
	jQuery("li input").each(function(){
		var json=eval("("+this.value+")");
		switchName(json);
	});
	jQuery("li input[type=checkbox]:checked").each(function(){	
		window.ifr.jQuery(".content2").append(obj['\"'+eval("("+this.value+")").NAME+'\"']);
	});
}
jQuery("li input[type=checkbox]").change(function(){	
	var json = eval("("+this.value+")");
	
	if(jQuery(this).attr('checked')=="checked"){
	save[json["KEY"]]=json;
	switchName(save[json["KEY"]]);
		window.ifr.jQuery(".content2").append(obj['\"'+json.NAME+'\"']);
	}
	else if(!(jQuery(this).attr('checked')=="checked")){
		window.ifr.jQuery(obj['\"'+json.NAME+'\"']).remove();
	}
});
});