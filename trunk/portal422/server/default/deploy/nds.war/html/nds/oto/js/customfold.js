var cf=null;
var cusfold=Class.create();
cusfold.prototype={
	initialize: function() {
		this.dia=null;
		this.dis=null;
	},
	inarrays:function(elem,array){
		var len = array.length;
		var index=-1;
		var sameCount=0;
		var allCount=Object.getOwnPropertyNames(elem).length;
		for (var i=0 ; i < len; i++ ) {
			sameCount=0;
			for(k in array[i]){
				if(elem[k]!=array[i][k]){break;}
				sameCount++;
				if(sameCount==allCount){return i;}
			}
		}
		return index;
	},
	selectnode:function(node,current,parent,children,isParent){ //删除参数nextparent
		var currentString;
		var parentString=jQuery(parent).attr("text");
		var reg=new RegExp("("+parentString+".[^(<br>)]*<br>)+");
		reg.compile(reg);
		var result=jQuery("#result").html();
		var allcount=jQuery(children).find('input[type="checkbox"]').size();
		if(!pjson){pjson=[];}
		if(isParent){
			jQuery(children).find('input[type="checkbox"]').prop("checked", node.checked);
			if(node.checked){
				if(allcount==0){
					result+=parentString+"<br>";
					pjson.push({id:jQuery(parent).attr("value"),name:parentString});
				}else{
					result+=parentString+"<br>";
					jQuery(children).each(function(index){
						currentString=parentString+"."+jQuery(this).attr("text")+"<br>";
						if(!new RegExp(currentString,"i").test(result)){
							if(reg.test(result)){
								var lastreg=reg.exec(result)[0];
								if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
								else{result+=currentString;}
							}else{
								result+=currentString;
							}
							pjson.push({id:jQuery(this).attr("value"),name:parentString+"."+jQuery(this).attr("text")});
						}
					});
				}
			}else{
				var index=-1;
				if(allcount==0){
					result=result.replace(parentString+"<br>","");
					index=cf.inarrays({id:jQuery(parent).attr("value"),name:parentString},pjson);
					if(index>-1){pjson.splice(index,1);}
				}else{
					result=result.replace(parentString+"<br>","");
					jQuery(children).each(function(index){
						currentString=parentString+"."+jQuery(this).attr("text")+"<br>";
						result=result.replace(currentString,"");
						index=cf.inarrays({id:jQuery(this).attr("value"),name:parentString+"."+jQuery(this).attr("text")},pjson);
						if(index>-1){pjson.splice(index,1);}
					});
				}
			}
		}else{
			if(allcount==0){currentString=jQuery(current).attr("text")+"<br>";}
			else{currentString=parentString+"."+jQuery(current).attr("text")+"<br>";}
			
			var checkedcount=jQuery(children).find('input[type="checkbox"]:checked').size();
			if(checkedcount==0&&allcount>0){
				jQuery(parent).find('input[type="checkbox"]').removeAttr("checked");
				index=cf.inarrays({id:jQuery(parent).attr("value"),name:jQuery(parent).attr("text")},pjson);
				if(index>-1){pjson.splice(index,1);}
				result=result.replace((jQuery(parent).attr("text")+"<br>"),"");
			}
			else if(checkedcount>0&&allcount>0){
				jQuery(parent).find('input[type="checkbox"]').attr({"checked":true});
				if(checkedcount==1&&node.checked){
					pjson.push({id:jQuery(parent).attr("value"),name:jQuery(parent).attr("text")});
					result+=jQuery(parent).attr("text")+"<br>";
				}
			}
			
			if(node.checked){
				if(reg.test(result)){
					var lastreg=reg.exec(result)[0];
					if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
					else{result+=currentString;}
				}
				else{result+=currentString;}
				pjson.push({id:jQuery(current).attr("value"),name:currentString.replace("<br>","")});
			}else{
				var index=-1;
				result=result.replace(currentString,"");
				index=cf.inarrays({id:jQuery(current).attr("value"),name:currentString.replace("<br>","")},pjson);
				if(index>-1){pjson.splice(index,1);}
			}
		}
		jQuery("#result").html(result);
	},
	showFold:function (ele){
		var val=jQuery(ele).prev().val();
		var table=jQuery(ele).attr("tab");
		/*try{
			val=jQuery.parseJSON(val);
			val=JSON.stringify(val);
		}catch(e){}*/
		var url="/html/nds/oto/product/category.jsp?table="+table+"&eid="+ele.id;
		var options=$H({padding: 0,width:'700px',height:'370px',top:'7%',title:'商品分类',skin:'chrome',drag:true,lock:true,esc:true,effect:false});
		//val="{\"table\":\"WX_APPENDGOODS\",\"id\":\"101\",\"name\":\"服装.女装\"}";
		/*new Ajax.Request(url, {
			method: 'post',
			data:{"category":val},
			onSuccess: function(data) {
				options.content=data.responseText;
				cf.dia=art.dialog(options);
			},
			onFailure:function(data){
				alert(data);
			}
		});*/
		jQuery.ajax({
			url:url,
			type:"post",
			data:{"category":val},
			success:function(data){
				options.content=data;
				cf.dia=art.dialog(options);
				//executeLoadedScript(data);
			},
			error:function(data){
				alert("error");
			}
		});
	},
	savefold:function(json){
		if(eid){
			var temjson=json;
			if(temjson){
				try{
					temjson=JSON.stringify(json).replace(new RegExp("^\"|\"$","g"),"");
					temjson=JSON.stringify(json).replace(new RegExp("(\\\\\")","g"),"\"");
					temjson=JSON.stringify(json).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
				}catch(e){
					temjson=json;
				}
			}
			jQuery(eid).prev().val(temjson);
			jQuery(eid).prev().attr("json",JSON.stringify(json));
			jQuery(eid).prev().prev().val(jQuery("#result").html());
			if(cf.dia){cf.dia.close();}
		}
	},
	closefold:function(){
		if(cf.dia){cf.dia.close();}   
	},
	fold:function (ci,currentnode){ //删除参数 nextnode
		var rowstate=jQuery(currentnode).attr("currentrowstate");
		if(!rowstate||rowstate=="show"){
			jQuery(currentnode).hide();
			jQuery(currentnode).attr({"currentrowstate":"hide"});
			jQuery(ci).attr("src","/html/nds/oto/themes/01/images/fold-hidden.png");
		}else{
			jQuery(currentnode).show();
			jQuery(currentnode).attr({"currentrowstate":"show"});
			jQuery(ci).attr("src","/html/nds/oto/themes/01/images/fold-show.png");
		}
	},
	showSpace:function(ele){
		var name=jQuery(ele).attr("ac");
		//var node=jQuery("#div_"+name).find('input[type="text"][name="'+name+'"]');
		var node=jQuery("#div_"+name+" input[type=\"text\"][name=\""+name+"\"]");
		if(node.size()<=0){return;}
		
		var space=jQuery(node).val();
		var objid=jQuery(ele).attr("objid");
		var url="/html/nds/oto/object/spacification.jsp?eleid="+name+"&objid="+objid;

		var options=$H({padding: 0,width:'700px',height:'370px',top:'7%',title:'商品规格',skin:'chrome',drag:true,lock:true,esc:true,effect:false});
		jQuery.ajax({
			url:url,
			type:"post",
			data:{"spaces":space},
			success:function(data){
				options.content=data;
				cf.dis=art.dialog(options);
				//executeLoadedScript(data);
			},
			error:function(data){
				alert("error");
			}
		});
	},
	closeSpace:function(){
		if(cf.dis){cf.dis.close();}
	},
	changesku:function(pele,index,trindex,cid,pid){
		var node=document.getElementById("iframe_"+pele).contentWindow;
		if(node){node.extendspace.changesku(index,trindex,cid,pid);}
	},
	addspace:function(ele){
		var name=jQuery(ele).attr("ac");
		if(!name){return;}
		var node=document.getElementById("iframe_"+name).contentWindow;
		if(node){node.extendspace.addsku();}
	},
	deleteallspace:function(ele){
		var name=jQuery(ele).attr("ac");
		if(!name){return;}
		var node=document.getElementById("iframe_"+name).contentWindow;
		if(node){node.extendspace.deleteallsku();}
	},
	savespace:function(ele){
		var name=jQuery(ele).attr("ac");
		if(!name){return;}
		var node=document.getElementById("iframe_"+name).contentWindow;
		if(node){node.extendspace.saveAlias();}
	},
	showSpaceItem:function(url,space){
		jQuery.ajax({
			url:url,
			type:"post",
			data:{"specification":space},
			success:function(data){
				alert(data);
				//options.content=data;
				//cf.dis=art.dialog(options);
				//executeLoadedScript(data);
			},
			error:function(data){
				alert(data);
			}
		});
	}
}
cusfold.main = function () {
    cf=new cusfold();
};
jQuery(document).ready(cusfold.main);