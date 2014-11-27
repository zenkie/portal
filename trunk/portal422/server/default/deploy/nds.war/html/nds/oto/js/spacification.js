//保存
var specs;
var savedata;
// json  specValueList[tabidValueList]= _data arr
var specValueList={}; 

var detailsValueList={}; 
/*jQuery(document).ready(
	function a(){
		var key;
		if(Object.keys){key=Object.keys(specs);}
		else{key=Object.getOwnPropertyNames(specs);}
		if(key&&key.length>0){tabChange(key[0]);}
	}
);*/
//根据规格的id查询数据库中已有的规格选项
//tabidValueList tabid
function querySpecValueList(tabidValueList){
	var _params="{table:16014,columns:['id','NAME','VALUE'],params:{column:\"WX_SPEC_ID\",condition:\"="+tabidValueList+"\"}}";
	jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
            type: 'post',
			async: false,
            data:{command:"Query",params:_params},
			success: function (data){
				var _data = eval("("+data+")")[0].rows;
				//specValueList[tabidValueList]=_data;
				tabidValueList=parseInt(tabidValueList);
				if(!specValueList[tabidValueList]){specValueList[tabidValueList]={};}
				for(var i=0;i<_data.length;i++){
					specValueList[tabidValueList][_data[i][2]]={pid:tabidValueList,id:_data[i][0],value:_data[i][2],name:_data[i][1]};
				}
			}
	});
	//return true;
}

//切换tab键
function tabChange(tabid){
	var specobj=jQuery("#WX_SPEC_"+tabid);
	//无此选项，不执行以下代码
	if(specobj.length<=0) {return;}
	//选中的选项卡调整
	jQuery("#divSpecSelTab span[tag='seltab']").removeClass("speTabSel").addClass("speTab");
	specobj.removeClass("speTab").addClass("speTabSel");
	//规格隐藏
	jQuery("#divSpecSelValue div[tag='valuelist']").hide();
	//显示规格
	
	//从数据库中查询数据
	
	var saveEditJson=null;
	//如果数据库存在数据

	var divs=$("specValueList_"+tabid);
	if(!divs){
		querySpecValueList(tabid);
		//显示数据 首次显示
		var valueList = "<div id=\"specValueList_"+tabid+"\" tag=\"valuelist\" style=\"display: none;\">";
		valueList+="<ul class=\"specbox\" tag=\"ulValueList\">";

		var ids=[];
		for(key in specValueList[tabid]){
			//0'id',1'NAME',2'VALUE'
			if(!specs[tabid]["childs"]){specs[tabid]["childs"]={};}
			specs[tabid]["childs"][specValueList[tabid][key].id]={id:specValueList[tabid][key].id,name:specValueList[tabid][key].name,value:specValueList[tabid][key].value};
			if(detailsValueList&&detailsValueList.hasOwnProperty(tabid)&&detailsValueList[tabid].hasOwnProperty(specValueList[tabid][key].id)){
				ids.push(specValueList[tabid][key].id);
			}
			valueList+="<li id=\"details_"+tabid+"_"+specValueList[tabid][key].id+"\" onclick=\"addDetails("+tabid+","+specValueList[tabid][key].id+")\"><span><span id=\"span_"+tabid+"_"+specValueList[tabid][key].id+"\">"+specValueList[tabid][key].name+"</span><label onclick=\"si.delValueId("+tabid+","+specValueList[tabid][key].id+");event.cancelBubble=true\" class=\"tabdel\" title=\"删除\"></label></span></li>";
			
		}
		valueList+="<input type=\"button\" onclick=\"addSpecList("+tabid+")\" value=\"+\" class=\"BtnAdd\">";
		valueList+="</ul>";
		valueList+="<table id=\"tbSpecValueList_"+tabid+"\" tag=\"SpecValueTable\" class=\"tblist\" specid=\"\" specname=\"\" showtype=\"0\" showway=\"0\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"95%\">";
		valueList+="<thead><tr class=\"tblist_th\"><th width=\"15%\">系统规格</th><th width=\"35%\">自定义规格值</th><th>操作</th></tr></thead>";
		valueList+="<tbody></tbody>";
		valueList+="</table>";
		valueList+="</div>";
		jQuery(valueList).appendTo("#divSpecSelValue");
		jQuery.each(ids,function(index,val){
			addDetails(tabid,val);
		});
	}
	

	
	//还没有获取的值得列表
	/*if(specValueList[tabid]==null && jQuery("#divSpecSelValue").find("#specValueList_"+tabid).length==0){
		//没有详细规格
		var valueList = "<div id=\"specValueList_"+tabid+"\" tag=\"valuelist\" style=\"display: none;\">";
		valueList+="<ul class=\"specbox\" tag=\"ulValueList\">";
		valueList+="<input type=\"button\" onclick=\"addSpecList("+tabid+",1)\" value=\"+\" class=\"BtnAdd\">";
		valueList+="</ul>";
		valueList+="<table id=\"tbSpecValueList_"+tabid+"\" tag=\"SpecValueTable\" class=\"tblist\" specid=\"\" specname=\"\" showtype=\"0\" showway=\"0\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"95%\">";
		valueList+="<thead><tr class=\"tblist_th\"><th width=\"15%\">系统规格</th><th width=\"35%\">自定义规格值</th><th width=\"35%\">操作</th></tr></thead>";
		valueList+="<tbody></tbody>";
		valueList+="</table>";
		valueList+="</div>";
		jQuery(valueList).appendTo("#divSpecSelValue");
		
	}*/
	//当前规格显示
	jQuery("#specValueList_"+tabid).show();
	
}


//添加规格
function addSPEC(){
	var con = art.dialog({
		lock:true,
		title:'请输入需要添加的规格',
		content:"系统规格：<input id=\"addSpec\" value=\"\"><br/><span style=\"color:red;font-size:12px;\">&nbsp;</span>",
		button:[{
			name:"确定",
			callback:function(){
				var val=this.DOM.content.find('input')[0].value;
				if(jQuery.trim(val)==""){
					this.DOM.content.find('span')[0].innerHTML="对不起，您未输入规格参数，或输入的数据不合法！";
					this.DOM.content.find('input')[0].value="";
					this.DOM.content.find('input')[0].focus();
					return false;
				}
				var params = "NAME:\""+val+"\"";
				var objid = insertIntoTable(16013,params);
				if(objid==-1){
					this.DOM.content.find('span')[0].innerHTML="对不起，您输入规格参数已存在！";
					this.DOM.content.find('input')[0].value="";
					this.DOM.content.find('input')[0].focus();
					return false;
				}
				if(objid!=-1){
					addSPECHtml(objid,val);
					tabChange(objid);
				}
				
			}
		}]
	});
}
//向网页上添加内容规格
function addSPECHtml(objid,val){
	//还没有选择规格时选择第一个
	var tabClass="speTab";
	if(jQuery("#divSpecSelTab span[tag='seltab']").length==0){
		tabClass="speTabSel";
	}
	jQuery("#divSpecSelTab input").before("<span id=\"WX_SPEC_"+objid+"\" tag=\"seltab\" specname=\""+val+"\" showtype=\"0\" specid=\"\" showway=\"0\" class=\""+tabClass+"\" onclick=\"tabChange('"+objid+"');\">"+val+"<label onclick=\"si.deleteItem('"+objid+"');event.cancelBubble=true\" class=\"tabdel\" title=\"删除\"></label></span>");
	jQuery("#divSpecSelTab input").attr('onclick','addSPEC()');
	//向specList中添加数据
	var objAdd=new Object();
	objAdd.id=objid;
	objAdd.description="";
	objAdd.name=val;
	objAdd.childs={};
	if(!specs){spaecs={};}
	specs[objid]=objAdd;
}
//向表格中插入数据
function insertIntoTable(tableid,params){
	//返回-1代表插入失败
	var _data;
	var _params = "{table:"+tableid+","+params+"}";
	jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectCreate",params:_params},
			async: false,
			success: function (data) {
				var mess =eval("("+data+")")[0];
				if(mess.code==-1){
					_data = -1;
				}else{
					_data = mess.objectid;
				}
            }
			
        });
	return _data;
}
jQuery.ajaxSetup({  
    async : false  
}); 
//删除规格
function deleteItem(tabid){
	art.dialog.confirm('你确定要删除这掉消息吗？', function () {
		var successOrError = delFromTable(16013,tabid);
		if(successOrError!=0){
			art.dialog.tips('删除失败');
			return;
		}
		//顶部规格从对象specList中删除
		delete specs[tabid];
		//删除数据库中属于这个这个规格的具体详细内容
		if(specValueList.hasOwnProperty(tabid)){delete specValueList[tabid];}


		//若当前显示的是删除内容，则切换到第一个规格，并具体内容显示删除
		if(jQuery("#specValueList_"+tabid).css("display")=="block"){
			var key=Object.getOwnPropertyNames(specs)[0];
			if(key){tabChange(key);}
		}
		//顶部规格html删除内容
		jQuery("#WX_SPEC_"+tabid).remove();
		//删除具体规格Html
		jQuery("#specValueList_"+tabid).remove();
	}, function () {
		art.dialog.tips('执行取消操作');
	});
}
//把表的数据删除掉
function delFromTable(tableid,rowid){
	
	var successOrError;
	var _params = "{table:"+tableid+",id:"+rowid+"}";
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ObjectDelete",params:_params},
		async: false,
		success:function(data){
			var mess =eval("("+data+")")[0];
			successOrError=mess.code;
		}
	});
	return successOrError;
}
function togetherWith(value){
	jQuery("#specName").val(value);
}
//向网页上添加规格的具体内容
//tid 给个的id num 添加具体内容的id
function addSpecList(tid){
	var flag = false;
	var con = art.dialog({
		lock:true,
		title:'输入需要添加的规格参数',
		content:"系统规格：<input id=\"addSpecValue\" value=\"\" focus onblur=\"togetherWith(this.value);\"><span style=\"color:red;font-size:12px;\">由字母或数组组成!</span><br/>自定义规格值：<input id=\"specName\" onfocus=\"this.select();event.cancelBubble=true;\"><br/><span  style=\"color:red\"></span><br/>",
		button:[{
			name:"确定",
			callback:function(){
				var addValue = this.DOM.content.find('input')[0].value;
				var addName = this.DOM.content.find('input')[1].value;
				var reg = new RegExp("^[A-Za-z0-9]+$");
				if(jQuery.trim(addValue)==""){
					this.DOM.content.find('span')[0].innerHTML="对不起，您未输入规格参数!";
					return false;
				}
				if(!reg.test(addValue)){
					this.DOM.content.find('span')[0].innerHTML="系统规格值由字母或数组组成!";
					return false;
				}
				var flag=false;
				flag=specValueList[tid].hasOwnProperty(addValue);
				if(flag){
					this.DOM.content.find('span')[0].innerHTML="您输入的规格已存在!";
					this.DOM.content.find('input')[0].value="";
					this.DOM.content.find('input')[1].value="";
					this.DOM.content.find('input')[0].focus();
					return false;
				}
				if(jQuery.trim(addName)==""){
					
					addName=addValue;
				}
				var params = "NAME:\""+addName+"\",VALUE:\""+addValue+"\",WX_SPEC_ID__ID:"+tid;
				
				var objid = insertIntoTable(16014,params);
				if(objid!=-1)
					addSPECListHtml(tid,objid,addValue,addName);
			}
		},{
			name:"取消",
			disable:true
		}]
	});
	/*art.dialog.prompt('请输入需要添加的规格参数', function (val){
		//??过滤空格符等等特殊字符？？
		if(jQuery.trim(val)==""){
			art.dialog.alert('对不起，您未输入规格参数，或输入的数据不合法！');
			return;
		}
		var flag=false;
		//如果添加的value已经存在
		jQuery.each(specValueList[tid],function(key,value){
			if(value[2]==val){
				flag=true;
			}
		});
		if(flag) {
			art.dialog.alert('您输入的内容已存在');
		}else{
				var params = "NAME:\""+val+"\",VALUE:\""+val+"\",WX_SPEC_ID__ID:"+tid;
				var objid = insertIntoTable(16014,params);
				if(objid!=-1)
					addSPECListHtml(tid,objid,val);
		}
	},'');*/
}
function addSPECListHtml(tid,objid,val,addName){
	jQuery("#specValueList_"+tid+" ul input").before("<li id=\"details_"+tid+"_"+objid+"\" onclick=\"addDetails("+tid+","+objid+")\" valueid=\"41\" valtext=\""+objid+"\" specimg=\"\"><span id=\"span_"+tid+"_"+objid+"\">"+addName+"<label onclick=\"si.delValueId("+tid+","+objid+");event.cancelBubble=true\" class=\"tabdel\" title=\"删除\">X</label></span></li>");
	jQuery("#specValueList_"+tid+" ul input").attr('onclick','addSpecList('+tid+')');
	//把添加的具体内容添加到specValueList中
	if(!specs[tid].hasOwnProperty("childs")){specs[tid]["childs"]={};}
	if(!specs[tid]["childs"].hasOwnProperty(objid)){specs[tid]["childs"][objid]={id:objid,name:addName,value:val};}
}

//添加具体规格 tid 规格的id oid arr中的位置
function addDetails(tid,oid){
	if(savedata&&savedata.keys.length>0&&!detailsValueList.hasOwnProperty(tid)){
		art.dialog.tips("请删除商品的原有规格再添加新的规格。");
		return;
	}
	var selectnode=jQuery.extend({},specs[tid]["childs"][oid]);
	if(!detailsValueList.hasOwnProperty(tid)||!detailsValueList[tid].hasOwnProperty(oid)){
		if(!detailsValueList[tid]){detailsValueList[tid]={};}
		detailsValueList[tid][oid]=selectnode;
	}
	var tr=jQuery("#tbSpecValueList_"+tid+" tbody tr[id=\"tr_"+selectnode.id+"\"]");
	if(!tr||tr.size()<=0){
		//添加页面显示 0'id',1'NAME',2'VALUE'
		jQuery("#tbSpecValueList_"+tid+" tbody").append("<tr id='tr_"+selectnode.id+"' name=\"vData\" oid=\""+oid+"\" class=\"list_"+tid+"\"><td width=\"15%\">"+selectnode.value+"</td><td width=\"35%\"><input type=\"text\" class=\"txt80\" tag=\"ctmValue\" orivalue=\""+selectnode.name+"\" onchange=\"changeDetailsName(this,"+tid+","+selectnode.id+")\" value=\""+selectnode.name+"\"></td><td width=\"35%\"><a href=\"javascript:void(0);\" onclick=\"deldetails("+tid+","+selectnode.id+")\">删除</a></td></tr>");
	}
}


//删除具体规格内容
function delValueId(tid,valueId){
	var flag = false;
	var paramStr = "\"id\":\""+tid+"\",\"value\":\""+specs[tid]["childs"][valueId].value+"\"";
	//判断本页面是否引用
	if(detailsValueList.hasOwnProperty(tid)&&detailsValueList[tid].hasOwnProperty(valueId)){
		art.dialog.tips('您要删除的内容本页面已被引用，无法删除！');
		return;
	}

	//判断能否删除
	jQuery.post("/html/nds/oto/object/spacificationCheckData.jsp",
		{"paramStr":paramStr},
		function(data){flag = data;}
	);
	
	if(flag==1){ 
		art.dialog.tips('您要删除的内容已被引用，无法删除！');
		return;
	}
	art.dialog.confirm('你确定要删除这掉消息吗？', function () {
		jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
			type: 'post',
			async: false,
			data:{command:"ObjectDelete",params:"{\"table\":16014,\"id\":"+valueId+"}"},
			success:function(data){
				var _data = eval("("+data+")");
					if (_data[0].code == 0) {
						art.dialog({
							time: 2,
							lock:true,
							cancel: false,
							content: '数据删除成功',
						});
						//移除掉删除的内容
						jQuery("#details_"+tid+"_"+valueId).remove();
						//将数据从数组中删除
						delete specs[tid]["childs"][valueId];
					} else {
						art.dialog.tips('删除失败！');
					}
			},
			error:function (XMLHttpRequest, textStatus, errorThrown) {}
		});
	}, 
	function () {}
	);
}
//删除已经选过的具体内容
function deldetails(tid,oid){
	jQuery("#tr_"+oid).remove();
	//ob.parentNode.parentElement.remove();
	delete detailsValueList[tid][oid];
}
//文本框内容改变
function changeDetailsName(details,tid,oid){
	//判断能否修改
	details.select();
	details.focus();
	event.stopPropagation();
	//dwr.util.selectRange(details,0,100);
	var flag = false;
	var paramStr = "\"id\":"+tid+",\"value\":\""+specs[tid]["childs"][oid].value+"\"";
	//判断能否删除
	jQuery.post("/html/nds/oto/object/spacificationCheckData.jsp",
		{"paramStr":paramStr},
		function(data){flag = data;}
	);
		
	if(flag==1){ 
		art.dialog.tips('您要删除的内容已被引用，无法修改！');
		jQuery(details).attr("value",jQuery(details).attr("orivalue"));
		jQuery(details).attr("readonly","true");
		//details.blur();
		//details.onfocus=function(){this.blur();};
	}
	
	var detailsName = details.value;
	var _params="{\"table\":16014,";
	_params+="id:"+oid+",";
	_params+="partial_update:true,";
	_params+="name:\""+detailsName+"\"";
	_params+="}";
	//修改数据库的name
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		async: false,
		data:{command:"ObjectModify",params:_params},
		success: function (data) {
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				art.dialog({
					time: 2,
					lock:true,
					cancel: false,
					content: '数据操作成功'
				});
				art.dialog.close();
			} else {
				art.dialog.tips('操作失败！');
			}
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {}
    });
	jQuery("#span_"+tid+"_"+oid).html(detailsName);
	jQuery(details).attr("orivalue",detailsName);
	//修改头表中的数据
	specs[tid]["childs"][oid]["name"]=detailsName;
	//修改detailsValueList中的数据
	detailsValueList[tid][oid]["name"]=detailsName;
}


//确定生成笛卡尔积
//声明数组
var keys;
var saveListData={};
var result=[];
var process=[];
var cartesians;
function submitDetails(){
	var node;
	var cartesians;
	var elenode=document.getElementById("iframe_"+eleid).contentWindow;
	var div=jQuery("#div_"+eleid);
	var skunode=jQuery("#div_"+eleid).attr("sku");
	var pricenode=jQuery("#div_"+eleid).attr("price");
	var costpricenode=jQuery("#div_"+eleid).attr("costprice");
	var inventorynode=jQuery("#div_"+eleid).attr("inventory");
	var skuss=jQuery("input[type=text][name=\""+skunode+"\"]").val();
	var price=jQuery("input[type=text][name=\""+pricenode+"\"]").val();
	var costprice=jQuery("input[type=text][name=\""+costpricenode+"\"]").val();
	var inventory=jQuery("input[type=text][name=\""+inventorynode+"\"]").val();
	skuss=skuss||"";
	price=price?parseFloat(price):0;
	costprice=costprice?parseFloat(costprice):0;
	inventory=inventory?parseFloat(inventory):0;
	
	var countalias=1;
	if(!elenode){return;}
	if(savedata&&savedata.keys.length>0){
		elenode.extendspace.selectspace=detailsValueList;
		//计算条码可能的组合数
		for(var space in detailsValueList){
			countalias*=parseInt(Object.getOwnPropertyNames(detailsValueList[space]).length);
		}
		elenode.extendspace.canalias=countalias;
		if(cf.dis){cf.dis.close();}
		return;
	}
	
	keys=[];
	cartesians=null;
	var spacehtml="<table id=\"table_spaceitem\"><thead id=\"spacehead\"><tr><th width='150'>货号</th>";
	for(key in detailsValueList){
		elenode.extendspace.canalias*=parseInt(Object.getOwnPropertyNames(detailsValueList[key]).length);
		keys.push({id:parseInt(key),name:specs[key].name});
		spacehtml+="<th id=\"th_"+key+"\">"+specs[key].name+"</th>";
		if(!cartesians){
			cartesians=[];
			node=jQuery.extend({},detailsValueList[key]);
			for(nkey in node){
				cartesians.push([jQuery.extend({pid:parseInt(key)},node[nkey])]);
			}
		}else{
			node=jQuery.extend({},detailsValueList[key]);
			cartesians=createCartesian(cartesians,node,parseInt(key));
		}
	}
	
	var sku;
	var skus=[]; 
	var spaceCode;
	var spaceName;
	var tcartesians;
	spacehtml+="<th>库存</th><th>锁定库存</th><th>销售价</th><th>标准价</th><th>重量</th><th>是否上架</th><th>操作</th></tr></thead><tbody id=\"specitem\">";
	for(var i=0;i<cartesians.length;i++){
		sku="";
		spaceCode="";
		spaceName="";
		tcartesians=cartesians[i];
		spacehtml+="<tr><td id=\"spacesku\"><input type=\"text\" name=\"sku\" orival=\"@sku@\" value=\"@sku@\" class=\"spacestr\" onchange=\"extendspace.changedata(this,'sku','str');\" /></td>";
		for(var j=0;j<tcartesians.length;j++){
			if(j){
				spaceCode+="_";
				spaceName+="/";
			}
			spaceCode+=tcartesians[j].id;
			spaceName+=tcartesians[j].name;
			sku+=tcartesians[j].value;
			spacehtml+="<td id=\"th_"+tcartesians[j].pid+"\"><span class=\"customsku\" onclick=\"extendspace.selectsku(this,"+tcartesians[j].pid+","+j+")\" id=\"item_"+tcartesians[j].pid+"_"+tcartesians[j].id+"\" cid="+tcartesians[j].id+" value=\""+tcartesians[j].value+"\">"+tcartesians[j].name+"</span></td>";
		}
		sku=skuss+sku
		spacehtml=spacehtml.replace(new RegExp("@sku@","g"),sku);
		//spacehtml.replace(new RegExp("@spaceCode@","g"),spaceCode);
		
		spacehtml+="<td><input type=\"text\" value="+inventory+" onchange=\"extendspace.changedata(this,'inventory','int');\" class=\"spacenum\" /></td>";
		spacehtml+="<td><input type=\"text\" value=0 onchange=\"extendspace.changedata(this,'lockinventory','int');\" class=\"spacenum\" /></td>";
		spacehtml+="<td><input type=\"text\" value="+price+" onchange=\"extendspace.changedata(this,'sellprice','float');\" class=\"spacenum\" /></td>";
		spacehtml+="<td><input type=\"text\" value="+costprice+" onchange=\"extendspace.changedata(this,'costprice','float');\" class=\"spacenum\" /></td>";
		spacehtml+="<td><input type=\"text\" value=0 onchange=\"extendspace.changedata(this,'wheight','float');\" class=\"spacenum\" /></td>";
		spacehtml+="<td><input type=\"checkbox\" onchange=\"extendspace.changedata(this,'putaway','boolean');\" checked=\"checked\" /></td>";
		spacehtml+="<td><a href=\"javascript:void()\" onclick=\"extendspace.deletespaceitem(this);\" class=\"deletesku\">删除</a></td></tr>";
		skus.push({id:0,operate:"create",sku:sku,space:tcartesians.slice(),aliascode:spaceCode,aliasname:spaceName,inventory:inventory,lockinventory:0,sellprice:price,costprice:costprice,wheight:0,putaway:"Y",isdefault:"Y"});
	}
	spacehtml+="</tbody></table>";
	if(elenode){
		var temjson;
		try{
			//keys=JSON.stringify(keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
			//skus=JSON.stringify(skus).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
			
			savedata={productid:si.objid,keys:keys,child:skus};
			temjson="{\"productid\":"+si.objid+",\"keys\":"+JSON.stringify(keys).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"child\":"+JSON.stringify(skus).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+"}";
			//temjson=JSON.stringify(savedata).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"");
		}catch(e){
			temjson=null;
		}
		elenode.extendspace.dk=cartesians;
		elenode.extendspace.spaces=savedata;
		elenode.extendspace.selectspace=detailsValueList;
		jQuery("#div_"+si.eleid+" input[type=text][name="+si.eleid+"]").val(temjson);
		jQuery("#iframe_"+si.eleid).contents().find("#custom_spaceitems").html(spacehtml);
		if(cf.dis){cf.dis.close();}
		
		//si.createAlias(elenode,temjson,spacehtml);
	}
}

var temp=[];
var tempcartesians=[];
function createCartesian(cartesian,node,pid){
	tempcartesians=[];
	for(var i=0;i<cartesian.length;i++){
		for(key in node){
			temp=cartesian[i].slice();
			temp.push(jQuery.extend({pid:pid},node[key]));
			tempcartesians.push(temp.slice());
		}
	}
	return tempcartesians;
}

//判断是否可以修改内容
function checkOk(inputObj,tid,valueId){
	inputObj.select();
	inputObj.focus();
	event.stopPropagation();
	//dwr.util.selectRange(inputObj,0,100);
	var flag = false;
	var paramStr = "\"id\":"+tid+",\"value\":\""+specs[tid]["childs"][valueId].value+"\"";
	//判断能否删除
	jQuery.post("/html/nds/oto/object/spacificationCheckData.jsp",
		{"paramStr":paramStr},
		function(data){flag = data;}
	);
		
	if(flag==1){ 
		art.dialog.tips('您要删除的内容已被引用，无法修改！');
		inputObj.blur();
		inputObj.onfocus=function(){this.blur();};
	}
}

var si=null;
var spe=Class.create();

spe.prototype={
	initialize: function() {
		this.objid=0;
		this.eleid=null;
		this.temjson={};
		this.elenode=null;
		this.spacehtml=null;
		
		application.addEventListener("CREATE_ALIAS", this._onCreateAlias, this);
		application.addEventListener("DELETE_SPACE", this._onDeleteSpace, this);
		application.addEventListener("DELETE_SPACEITEM", this._onDeleteSpaceItem, this);
	},
	
	//初始化规格
	createAlias:function(elenode,temjson,spacehtml){
		this.temjson=temjson;
		this.elenode=elenode;
		this.spacehtml=spacehtml;
		
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="CREATE_ALIAS";
		var param=eval('('+temjson+')');
		evt.param=Object.toJSON(param);
		evt.table="wx_alias";
		evt.action="modifyorcreate";
		evt.permission="w";
		si._executeCommandEvent(evt);
	},
	
	_onCreateAlias:function(result){
		var resultjo;
		try{
			resultjo=eval('(' + result.getUserData().jsonResult + ')');
			resultjo=eval('(' +resultjo.data+')');
		}
		catch(e){resultjo=null;}
		if(!resultjo){
			alert("保存失败！");
			return;
		}else if(resultjo.code!=0){
			if(resultjo.message){alert(resultjo.message);}
			else{alert("保存失败！");}
			return;
		}
		
		jQuery("#div_"+si.eleid+" input[type=text][name="+si.eleid+"]").val(si.temjson);
		jQuery("#iframe_"+si.eleid).contents().find("#custom_spaceitems").html(si.spacehtml);
		if(cf.dis){cf.dis.close();}
		
	},
	
	//删除规格
	deleteItem:function(tabid){
		art.dialog.confirm('你确定要删除吗？', function () {
			var evt={};
			evt.command="DBJSON";
			evt.callbackEvent="DELETE_SPACE";

			var param={"p_id":parseInt(tabid)};
			evt.param=Object.toJSON(param);
			evt.table="WX_SPEC";
			evt.action = "DELETE";
			evt.permission="r";
			si._executeCommandEvent(evt);
			/*var successOrError = delFromTable(16013,tabid);
			if(successOrError!=0){
				art.dialog.tips('删除失败');
				return;
			}*/
			
		}, 
		function () {
			art.dialog.tips('执行取消操作');
		});
	},
	
	_onDeleteSpace:function(e){
		var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
		var tabid=ret.sid;
		if(ret.code<0){
			art.dialog.tips(ret.message);
			return;
		}
		//顶部规格从对象specList中删除
		delete specs[tabid];
		//删除数据库中属于这个这个规格的具体详细内容
		if(specValueList.hasOwnProperty(tabid)){delete specValueList[tabid];}


		//若当前显示的是删除内容，则切换到第一个规格，并具体内容显示删除
		if(jQuery("#specValueList_"+tabid).css("display")=="block"){
			var key;
			if(Object.keys){key=Object.keys(specs);}
			else{key=Object.getOwnPropertyNames(specs);}
			if(key&&key.length>0){tabChange(key[0]);}
		}
		//顶部规格html删除内容
		jQuery("#WX_SPEC_"+tabid).remove();
		//删除具体规格Html
		jQuery("#specValueList_"+tabid).remove();
	},
	
	delValueId:function(tid,valueId){
		art.dialog.confirm('你确定要删除吗？', 
			function () {
				var paramStr = "\"id\":\""+parseInt(tid)+"\",\"value\":\""+specs[tid]["childs"][valueId].value+"\"";
				//判断本页面是否引用
				if(detailsValueList.hasOwnProperty(tid)&&detailsValueList[tid].hasOwnProperty(valueId)){
					art.dialog.tips('您要删除的内容本页面已被引用，无法删除！');
					return;
				}

				//判断能否删除
				var evt={};
				evt.command="DBJSON";
				evt.callbackEvent="DELETE_SPACEITEM";

				var param={"p_id":parseInt(tid),"c_id":parseInt(valueId),"value":specs[tid]["childs"][valueId].value};
				evt.param=Object.toJSON(param);
				evt.table="WX_SPEC";
				evt.action = "DELETEITEM";
				evt.permission="r";
				si._executeCommandEvent(evt);
			},
			function () {
				art.dialog.tips('执行取消操作');
			}
		);
		
	},
	
	_onDeleteSpaceItem:function(e){
		var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
		var valueId=ret.cid;
		var tid=ret.pid;
		var value=ret.value;
		if(ret.code<0){
			art.dialog.tips(ret.message);
			return;
		}
		//移除掉删除的内容
		jQuery("#details_"+tid+"_"+valueId).remove();
		//将数据从数组中删除
		delete specValueList[tid][specs[tid]["childs"][valueId].value];
		delete specs[tid]["childs"][valueId];
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

spe.main = function(){
    si=new spe();
};
//jQuery(document).ready(spe.main);