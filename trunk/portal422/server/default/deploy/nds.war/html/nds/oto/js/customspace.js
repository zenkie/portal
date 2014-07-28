var extendspace=null;
var customspaces=Class.create();

customspaces.prototype={
	initialize: function() {
		this.spaces=null;
		this.selectspace={};
		this.dk=[];
		this.eid=null;
		this.skunode=null;
		this.pricenode=null;
		this.costpricenode=null;
		this.inventorynode=null;
		this.skuss=null;
		this.price=null;
		this.costprice=null;
		this.inventory=null;
		this.ele=null;
		this.objid=null;
		
		application.addEventListener("SAVE_ALIAS", this._onSaveAlias, this);
		application.addEventListener("DELETE_ALIAS", this._onDeleteAlias, this);
		application.addEventListener("DELETE_ALL_ALIAS", this._onDeleteAllAlias, this);
		application.addEventListener("MODIFY_ALIAS", this._onModifyAlias, this);
		application.addEventListener("GET_PRODUCT_ALIAS", this._onGetProductAlias, this);
	},
	init:function(){
		var jo;
		var spaceCode=null;
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		this.skunode=w.jQuery("#div_"+this.eid).attr("sku");
		this.pricenode=w.jQuery("#div_"+this.eid).attr("price");
		this.costpricenode=w.jQuery("#div_"+this.eid).attr("costprice");	
		this.inventorynode=w.jQuery("#div_"+this.eid).attr("inventory");
		this.skuss=w.jQuery("input[type=text][name=\""+this.skunode+"\"]").val();	
		this.price=w.jQuery("input[type=text][name=\""+this.pricenode+"\"]").val();
		this.costprice=w.jQuery("input[type=text][name=\""+this.costpricenode+"\"]").val();
		this.inventory=w.jQuery("input[type=text][name=\""+this.inventorynode+"\"]").val();
		this.objid=w.jQuery("#div_"+this.eid).attr("objid");
		
		this.skuss=this.skuss||"";
		this.objid=this.objid?parseInt(this.objid):0;
		this.price=this.price?parseFloat(this.price):0;
		this.costprice=this.costprice?parseFloat(this.costprice):0;
		this.inventory=this.inventory?parseFloat(this.inventory):0;
		
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="GET_PRODUCT_ALIAS";
		var param={"productid":extendspace.objid};
		evt.param=Object.toJSON(param);
		evt.table="WX_ALIAS";
		evt.action = "json";
		evt.permission="r";
		extendspace._executeCommandEvent(evt);
	},
	
	_onGetProductAlias:function(result){
		//this.spaces=w.jQuery("#div_"+this.eid+" input[type=text][name="+this.eid+"]").val();
		try{this.spaces=eval('(' + result.getUserData().jsonResult + ')');}
		catch(e){this.spaces=null;}
		var spacehtml="<table id=\"table_spaceitem\"><thead id=\"spacehead\"><tr><th width='150'>货号</th>";
		if(this.spaces&&this.spaces.keys){
			for(var k=0;k<this.spaces.keys.length;k++){
				jo=this.spaces.keys[k];
				spacehtml+="<th id=\"th_"+jo.id+"\">"+jo.name+"</th>";
			}
		}
		spacehtml+="<th>库存</th><th>锁定库存</th><th>销售价</th><th>标准价</th><th>重量</th><th>是否上架</th><th>操作</th></tr></thead><tbody id=\"specitem\">";
		if(this.spaces&&this.spaces.child){
			var tempspace;
			var tempspaces;
			for(var i=0;i<this.spaces.child.length;i++){
				jo=this.spaces.child[i];
				spacehtml+="<tr><td id=\"spacesku\"><input type=\"text\" name=\"sku\" orival=\""+jo.sku+"\" value=\""+jo.sku+"\" class=\"spacestr\" onchange=\"extendspace.changedata(this,'sku','str');\" /></td>";
				tempspaces=jo.space;
				if(tempspaces){
					spaceCode="";
					this.dk.push(tempspaces);
					for(var j=0;j<tempspaces.length;j++){
						tempspace=tempspaces[j];
						if(!this.selectspace.hasOwnProperty(tempspace.pid)){this.selectspace[tempspace.pid]={};}
						if(!this.selectspace[tempspace.pid].hasOwnProperty(tempspace.id)){
							this.selectspace[tempspace.pid][tempspace.id]={pid:tempspace.pid,id:tempspace.id,name:tempspace.name,value:tempspace.value};
						}
						//if(spaceCode){spaceCode+="_";}
						//spaceCode+=tempspace.id;
						spacehtml+="<td id=\"th_"+tempspace.pid+"\"><span class=\"customsku\" onclick=\"extendspace.selectsku(this,"+tempspace.pid+","+j+")\" id=\"item_"+tempspace.pid+"_"+tempspace.id+"\" cid="+tempspace.id+" value=\""+tempspace.value+"\">"+tempspace.name+"</span></td>";
					}
					//spacehtml.replace(new RegExp("@spaceCode@","g"),spaceCode);
				}
				
				spacehtml+="<td><input type=\"text\" value="+jo.inventory+" onchange=\"extendspace.changedata(this,'inventory','int');\" class=\"spacenum\" /></td>";
				spacehtml+="<td><input type=\"text\" value="+jo.lockinventory+" onchange=\"extendspace.changedata(this,'lockinventory','int');\" class=\"spacenum\" /></td>";
				spacehtml+="<td><input type=\"text\" value="+jo.sellprice+" onchange=\"extendspace.changedata(this,'sellprice','float');\" class=\"spacenum\" /></td>";
				spacehtml+="<td><input type=\"text\" value="+jo.costprice+" onchange=\"extendspace.changedata(this,'costprice','float');\" class=\"spacenum\" /></td>";
				spacehtml+="<td><input type=\"text\" value="+jo.wheight+" onchange=\"extendspace.changedata(this,'wheight','float');\" class=\"spacenum\" /></td>";
				spacehtml+="<td><input type=\"checkbox\""+("Y"==jo.putaway?" checked='checked'":"")+" onchange=\"extendspace.changedata(this,'putaway','boolean');\" /></td>";
				spacehtml+="<td><a href=\"javascript:void()\" onclick=\"extendspace.deletespaceitem(this);\" class=\"deletesku\">删除</a></td></tr>";
			}
		}
		spacehtml+="</tbody></table>";
		jQuery("#custom_spaceitems").html(spacehtml);
		//$("#custom_spaceitems").innerHTML=spacehtml;
		w.jQuery("#div_"+this.eid+" input[type=button][ac="+this.eid+"]").removeAttr("disabled");
	},
	
	changedata:function(ele,key,cost){
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		var index=jQuery(ele).parent().closest("tr").index();
		if(index<0){
			var trs=jQuery("#table_spaceitem tr");
			var tr=jQuery(ele).parent().closest("tr");
			index=trs.index(jQuery(ele).parent().closest("tr"));
		}
		if(!this.spaces||index<0){return;}
		var data;
		if(cost=='boolean'){data=ele.checked?"Y":"N";}
		else{data=jQuery(ele).val();}
		
		if(data){data=data.trim();}
		if(!data){
			alert("不能输入空值！");
			return;
		}
		if(key=="sku"){
			//判断条码只能由数字与字母组成
			if(!/^[0-9a-zA-Z]+$/.test(data)){
				alert("条码只能由数字与字母组成");
				return;
			}
			var orival=jQuery(ele).attr("orival");
			jQuery(ele).attr("value",data);
			var skus=jQuery("#table_spaceitem td[id=\"spacesku\"] input[type=text][value=\""+data+"\"]");
			if(skus.length>1){
				alert("货号不能相同！");
				jQuery(ele).attr("value",orival);
				jQuery(ele).val(orival);
				jQuery(ele).focus();
				return;
			}
			jQuery(ele).attr("orival",data);
		}
		if(cost=='int'){data=parseInt(data);}
		else if(cost=='float'){data=parseFloat(data);}
		
		this.spaces.child[index][key]=data;
		var temjson;
		try{
			temjson="{\"keys\":"+JSON.stringify(extendspace.spaces.keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(extendspace.spaces.child).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
			//temjson=JSON.stringify(extendspace.spaces).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
		}catch(e){
			temjson=extendspace.spaces;
		}
		if(this.spaces.child[index].id!=0){this.spaces.child[index].operate="modify";}
		w.jQuery("#div_"+this.eid+" input[type=text][name="+this.eid+"]").val(temjson);
	},
	
	deletespaceitem:function(ele){
		this.ele=ele;
		art.dialog.confirm('你确定要删除吗？',function(){	
			var node=jQuery(ele).parent().closest("tr");
			var index=node.index();
			if(index<0){
				var trs=jQuery("#table_spaceitem tr");
				var tr=jQuery(ele).parent().closest("tr");
				index=trs.index(jQuery(ele).parent().closest("tr"));
			}
			if(!extendspace.spaces||index<0){return;}
			
			if(this.spaces.child[trindex].id==0){
				extendspace.spaces.child.splice(index,1);
				extendspace.dk.splice(index,1);
				var temjson;
				try{
					temjson="{\"keys\":"+JSON.stringify(extendspace.spaces.keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(extendspace.spaces.child).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
					//temjson=JSON.stringify(extendspace.spaces).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
				}catch(e){
					temjson=extendspace.spaces;
				}
				w.jQuery("#div_"+extendspace.eid+" input[type=text][name="+extendspace.eid+"]").val(temjson);
				alert("保存成功！");
				return;
			}
			var evt={};
			evt.command="DBJSON";
			evt.callbackEvent="DELETE_ALIAS";
			var param={"id":extendspace.objid,"code":extendspace.spaces.child[index].aliascode};
			evt.param=Object.toJSON(param);
			evt.table="WX_ALIAS";
			evt.action = "DELETE";
			evt.permission="D";
			extendspace._executeCommandEvent(evt);
			
		}, function () {
			art.dialog.tips('取消删除。');
		});
	},
	
	_onDeleteAlias:function(result){
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		
		var resultjo;
		try{resultjo=eval('(' + result.getUserData().jsonResult + ')');}
		catch(e){resultjo=null;}
		if(!resultjo){
			alert("保存失败！");
			return;
		}else if(resultjo.code!=0){
			if(resultjo.message){alert(resultjo.message);}
			else{alert("保存失败！");}
			return;
		}
	
		var node=jQuery(extendspace.ele).parent().closest("tr");
		var index=node.index();
		if(index<0){
			var trs=jQuery("#table_spaceitem tr");
			var tr=jQuery(ele).parent().closest("tr");
			index=trs.index(jQuery(ele).parent().closest("tr"));
		}
		if(!extendspace.spaces||index<0){return;}
		jQuery(node).remove();
		//delete spaces.child[index];
		extendspace.spaces.child.splice(index,1);
		extendspace.dk.splice(index,1);
		var temjson;
		try{
			temjson="{\"keys\":"+JSON.stringify(extendspace.spaces.keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(extendspace.spaces.child).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
			//temjson=JSON.stringify(extendspace.spaces).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
		}catch(e){
			temjson=extendspace.spaces;
		}
		w.jQuery("#div_"+extendspace.eid+" input[type=text][name="+extendspace.eid+"]").val(temjson);
		alert("保存成功！");
	},
	
	addsku:function(){
		if(!this.spaces||this.spaces.keys.length<=0){
			art.dialog.tips('请先选择规格！');
			return;
		}
		var sk=[];
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		var tr="<tr><td id=\"spacesku\"><input type=\"text\" name=\"sku\" orival=\""+this.skuss+"\" value=\""+this.skuss+"\" class=\"spacestr\" onchange=\"extendspace.changedata(this,'sku','str');\" /></td>";
		if(this.spaces&&this.spaces.keys){
			for(var k=0;k<this.spaces.keys.length;k++){
				jo=this.spaces.keys[k];
				sk.push({pid:jo.id});
				tr+="<td id=\"th_"+jo.id+"\" ><span class=\"customsku\" onclick=\"extendspace.selectsku(this,"+jo.id+","+k+")\" id=\"item_"+jo.id+"\" value=\"\">请选择</span></td>";
			}
		}
		tr+="<td><input type=\"text\" value="+this.inventory+" onchange=\"extendspace.changedata(this,'inventory','int');\" class=\"spacenum\" /></td>";
		tr+="<td><input type=\"text\" value=0 onchange=\"extendspace.changedata(this,'lockinventory','int');\" class=\"spacenum\" /></td>";
		tr+="<td><input type=\"text\" value="+this.price+" onchange=\"extendspace.changedata(this,'sellprice','float');\" class=\"spacenum\" /></td>";
		tr+="<td><input type=\"text\" value="+this.costprice+" onchange=\"extendspace.changedata(this,'costprice','float');\" class=\"spacenum\" /></td>";
		tr+="<td><input type=\"text\" value=0 onchange=\"extendspace.changedata(this,'wheight','float');\" class=\"spacenum\" /></td>";
		tr+="<td><input type=\"checkbox\" onchange=\"extendspace.changedata(this,'putaway','boolean');\" checked=\"checked\" /></td>";
		tr+="<td><a href=\"javascript:void()\" onclick=\"extendspace.deletespaceitem(this);\" class=\"deletesku\">删除</a></td></tr>";
		jQuery("#table_spaceitem").append(tr);
		
		this.spaces.child.push({id:0,operate:"create",sku:this.skuss,space:sk,aliascode:"",aliasname:"",inventory:this.inventory,lockinventory:0,sellprice:this.price,costprice:this.costprice,wheight:0,putaway:"Y",isdefault:"N"});
		this.dk.push(sk);
		var temjson;
		try{
			temjson="{\"keys\":"+JSON.stringify(this.spaces.keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(this.spaces.child).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
			//temjson=JSON.stringify(extendspace.spaces).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
		}catch(e){
			temjson=this.spaces;
		}
		w.jQuery("#div_"+this.eid+" input[type=text][name="+this.eid+"]").val(temjson);
	},
	
	deleteallsku:function(){
		art.dialog.confirm('你确定要删除吗？',function(){	
			var evt={};
			evt.command="DBJSON";
			evt.callbackEvent="DELETE_ALL_ALIAS";
			var param={"id":extendspace.objid,"code":null};
			evt.param=Object.toJSON(param);
			evt.table="WX_ALIAS";
			evt.action = "DELETE";
			evt.permission="D";
			extendspace._executeCommandEvent(evt);
		}, function () {
			art.dialog.tips('取消删除。');
		});
		
	},
	
	_onDeleteAllAlias:function(result){
		var resultjo;
		try{resultjo=eval('(' + result.getUserData().jsonResult + ')');}
		catch(e){resultjo=null;}
		if(!resultjo){
			alert("保存失败！");
			return;
		}else if(resultjo.code!=0){
			if(resultjo.message){alert(resultjo.message);}
			else{alert("保存失败！");}
			return;
		}
		
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		this.spaces=null;
		this.selectspace={};
		this.dk=[];
		jQuery("#custom_spaceitems tbody tr").remove();
		w.jQuery("#div_"+this.eid+" input[type=text][name="+this.eid+"]").val("");
		alert("保存成功！");
	},
	
	selectsku:function(ele,tid,cindex){
		this.ele=ele;
		var node=jQuery(ele).parent().closest("tr");
		var index=node.index();
		if(index<0){
			var trs=jQuery("#table_spaceitem tr");
			var tr=jQuery(ele).parent().closest("tr");
			index=trs.index(jQuery(ele).parent().closest("tr"));
		}
		if(index<0){return;}
			
		var sss={};
		var regstr;
		var selectcount=0;
		var regstring="\\\s*\\\[";
		var skus=this.dk[index];
		for(var i=0;i<skus.length;i++){
			if(skus[i].id){
				selectcount++;
				sss[skus[i].pid]=skus[i].id;
			}
			if(i>0){regstring+="\s*,";}
			regstring+="\\\s*\\\{\\\s*\\\\\\\"pid\\\\\\\"\\\s*:\\\s*"+skus[i].pid;	
			if(tid==skus[i].pid){regstring+="\\\s*,\\\s*\\\\\\\"id\\\\\\\"\\\s*:\\\s*@id@";}
			else if(skus[i].id){regstring+="\\\s*,\\\s*\\\\\\\"id\\\\\\\"\\\s*:\\\s*"+skus[i].id;}
			regstring+="[^\\\}]+\\\}";
		}
		regstring+="\\\s*[^\\\]]*\\\]";
		var size=1;
		var sele;
		for(key in this.selectspace){
			sele=this.selectspace[key];
			if(!sss.hasOwnProperty(sele.tid)&&parseInt(tid)!=parseInt(key)){size*=Object.getOwnPropertyNames(sele).length;}
		}
		var cid;
		var reg;
		var html="<div id=\"changespace\"><div id=\"spaces\">";
		var count=0;
		var isCheck=true;
		var currentspaces=this.selectspace[tid];
		var currentspace;
		cid=jQuery(ele).attr("cid");
		if(cid){cid=parseInt(cid);}
		for(key in currentspaces){
			isCheck=true;
			currentspace=currentspaces[key];
			regstr=regstring.replace("@id@",currentspace.id);
			reg=new RegExp(regstr,"igm");
			if(reg.test(JSON.stringify(this.dk))){
				count=JSON.stringify(this.dk).split(reg).length;
				if(selectcount>=skus.length-1 && count>=2){isCheck=false;}
				else if(count-1>=size){isCheck=false;}
			}
			html+="<div"+((isCheck||cid==currentspace.id)?" onclick=\"cf.changesku('"+this.eid+"',"+cindex+","+index+","+currentspace.id+","+tid+");\"":"");
			html+=" class=\""+(cid==currentspace.id?"currentselectspace":(isCheck?"canselectspace":"cancleselectspace"))+"\">";
			html+=currentspace.name+"</div>";
		}
		html+="</div></div>";
		/*var ele = Alerts.fireMessageBox({
			width: 595,
			modal: true,
			title: "规格选择"
		});*/
		
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		//jQuery("#spaces").html(html);
		var options=$H({id:"selectspace",title:"规格选择",width:500,height:300,padding:0,resize:true,drag:true,lock:true,esc:true,skin:'chrome'});
		options.content=html;
		w.art.dialog(options);
	},

	_onModifyAlias:function(e){
		
	},
	
	changesku:function(index,trindex,cid,pid){
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		
		var currentspace=this.selectspace[pid][cid];
		if(this.dk[trindex][index].id==cid){
			w.art.dialog.get("selectspace").close();
			return;
		}
		
		var aliascode="";
		var aliasname="";
		this.dk[trindex][index]=jQuery.extend({pid:pid},currentspace);
		this.spaces.child[trindex].space[index]=jQuery.extend({pid:pid},currentspace);
		var sku=this.skuss||"";
		for(var i=0;i<this.dk[trindex].length;i++){
			if(this.dk[trindex][i].id){
				sku+=this.dk[trindex][i].value;
				if(i){
					aliascode+="_";
					aliasname+="/";
				}
				aliascode+=this.dk[trindex][i].id;
				aliasname+=this.dk[trindex][i].name;
			}
		}
		if(this.spaces.child[trindex].id!=0){this.spaces.child[trindex].operate="modify";}
		this.spaces.child[trindex].sku=sku;
		this.spaces.child[trindex].aliascode=aliascode;
		this.spaces.child[trindex].aliasname=aliasname;
		
		var temjson;
		try{
			temjson="{\"keys\":"+JSON.stringify(this.spaces.keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(this.spaces.child).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
			//temjson=JSON.stringify(extendspace.spaces).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
		}catch(e){
			temjson=this.spaces;
		}
		w.jQuery("#div_"+this.eid+" input[type=text][name="+this.eid+"]").val(temjson);
		//jQuery(ele).html(currentspace.name);
		var tr=jQuery("#table_spaceitem>tbody>tr").eq(trindex);
		if(tr){
			jQuery("td[id=spacesku]>input[type=text]",tr).val(sku);
			jQuery("td[id=th_"+pid+"]>span",tr).html(currentspace.name);
			jQuery("td[id=th_"+pid+"]>span",tr).attr({"cid":currentspace.id,"orival":sku});
		}
		w.art.dialog.get("selectspace").close();
	},
	
		//初始化规格
	saveAlias:function(){
		if(!this.spaces||this.spaces.keys.length<=0){
			alert("请选择规格后再保存！");
			return;
		}
		
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="SAVE_ALIAS";
		evt.param=Object.toJSON(this.spaces);
		evt.table="wx_alias";
		evt.action="modifyorcreate";
		evt.permission="w";
		//evt.isclob=true;
		this._executeCommandEvent(evt);
	},
	
	_onSaveAlias:function(result){
		var resultjo;
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		
		try{
			resultjo=eval('(' + result.getUserData().jsonResult + ')');
			resultjo=eval('('+resultjo.data+')');
		}
		catch(e){}
		if(!resultjo){
			alert("保存失败！");
			if(w){
				window.location.reload(true);
				//w.document.getElementById("iframe_"+this.eid).location.reload();
			}
			return;
		}else if(resultjo.code!=0){
			if(resultjo.message){alert(resultjo.message);}
			else{alert("保存失败！");}
			
			if(w){
				window.location.reload(true);
				//w.document.getElementById("iframe_"+this.eid).reload();
			}
			return;
		}else{
			alert("保存成功！");
			window.location.reload(true);
			// try{this.spaces=eval('('+resultjo.data+')');}
			// catch(e){}
			return;
		}
	},
	
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				art.dialog.tips(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	}
}
customspaces.main=function(){
	extendspace=new customspaces();
}
//jQuery(document).ready(customspaces.main);