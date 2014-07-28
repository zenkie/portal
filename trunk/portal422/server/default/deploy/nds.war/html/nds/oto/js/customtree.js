function createtree(trees){
	var node;
	for(var i=0;i<trees.length;i++){
		node=new treenode(trees[i]);
		ctree.nodes[node.id]=node;
		//ctree.arraynodes[ctree.arraynodes.length]=node;
	}
};
function toCTreeString(trees,spaceing){
	var node;
	var nodestring="";
	var space=spaceing?spaceing:"";
	for(var i=0;i<trees.length;i++){
		node=trees[i];
		nodestring+="<div"+((node.parentid==""||node.parentid==undefined)?"":" style=\"display:none;\"")+" id='";
		if(node.isparent){
			nodestring+="pfold_"+node.nodeid+"' ondblclick=\"ctree.imgClick('"+node.id+"');\">"+space+
						"<image id='img_"+node.id+"' style=\"cursor: pointer;margin: 0 0px 2px 5px;\""+
						"src='/html/nds/oto/themes/01/images/fold-hidden.png' onclick=\"ctree.imgClick('"+node.id+"');\" />"+
						"<input id='check_"+node.id+"' type='checkbox'"+(node.ischeck?" checked=true":"")+" onclick=\"ctree.checkClick(this,'"+node.id+"');\" />"+
						"<span style=\"cursor: pointer;vertical-align: top;\">"+node.text+"</span></div>";
			
			if(node.childs.length>0){
				nodestring+="<div id='cfold_"+node.nodeid+"'>";
				nodestring+=toCTreeString(node.childs,space+"<span style=\"width:32px;display: inline-block;\"></span>");
				nodestring+="</div>";
			}
		}else{
			nodestring+="nfold_"+node.nodeid+"' ondblclick=\"ctree.imgClick('"+node.id+"');\">"+space+
						"<image id='img_"+node.id+"' src='' />"+
						"<input id='check_"+node.id+"' type='checkbox'"+(node.ischeck?" checked=true":"")+" onclick=\"ctree.checkClick(this,'"+node.id+"');\" />"+
						"<span style=\"cursor: pointer;vertical-align: top;\">"+node.text+"</span></div>";
		}
	}
	return nodestring;
};

var ctree={
	nodes:{},
	//arraynodes:[],
	imgClick:function(id){this.nodes[id].imgClick();},
	checkClick:function(ele,id){this.nodes[id].checkClick(ele);},
	getChilds:function(id){
		var node;
		var childs=[];
		for(attr in this.nodes){
			node=this.nodes[attr];
			if(node.parentid==id){childs[childs.length]=node;};
		}
		return childs;
	},
	getChildsByChecked:function(id,checked){
		var node;
		var childs=[];
		for(attr in this.nodes){
			node=this.nodes[attr];
			if(node.parentid==id&&node.currentcheck==checked){childs[childs.length]=node;};
		}
		return childs;
	},
	/*toString:function(){
		var nodestring=[];
		for(attribute in this.nodes){
			nodestring[nodestring.length]=this.nodes[attribute].toString();
		}
		return nodestring.join("");
	},*/
	init:function(){this.nodes={};/*arraynodes=[];*/}
};

function inarrays(elem,array){
	var index=-1;
	var sameCount=0;
	var allCount=Object.getOwnPropertyNames(elem).length;
	for (var i=0 ; i < array.length; i++ ) {
		sameCount=0;
		for(k in array[i]){
			if(elem[k]!=array[i][k]){break;}
			sameCount++;
			if(sameCount==allCount){return i;}
		}
	}
	return index;
}

function treenode(tree){
	/*this.childs=[];*/
	this.id=tree.id;
	this.text=tree.text;
	this.nodeid=tree.nodeid;
	this.currentcheck=tree.ischeck;
	this.ischeck=tree.ischeck;
	this.parentid=tree.parentid;
	this.isparent=tree.isparent;
	this.parentnodeid=tree.parentnodeid;
	
	/*var nodes=tree.childs;
	for(var i=0;i<nodes.length;i++){
		this.childs[this.childs.length]=new treenode(nodes[i]);
	}*/
	var node;
	var nodes=tree.childs;
	for(var i=0;i<nodes.length;i++){
		node=new treenode(nodes[i]);
		ctree.nodes[nodes[i].id]=node;
		//ctree.arraynodes[ctree.arraynodes.length]=node;
	}
}
treenode.prototype.getParent=function(){
	return ctree.nodes[this.parentid];
};
treenode.prototype.getChilds=function(){
	return ctree.getChilds(this.id);

	/*var parentid=this.id;
	var tnodes=jQuery.grep(ctree.arraynodes,function(n,i){
		return n.parentid==parentid;
	});
	if(this.isparent){
		tnodes=tnodes.cancat();
	}
	return tnodes;*/
};
/*treenode.prototype.toString=function(){
	var space="";
	var nodestring="<div id='";
	if(this.isparent){
		nodestring+="pfold_"+this.nodeid+"' ondblclick=\"ctree.imgClick('"+this.id+"');\">"+space+
					"<image id='img_"+this.nodeid+"' style=\"cursor: pointer;margin: 0 8px 2px 5px;\""+
					"src='/html/nds/oto/themes/01/images/fold-hidden.png' onclick=\"ctree.imgClick('"+this.id+"');\" />"+
					"<input type='checkbox'"+(this.ischeck?" checked=true":"")+" onclick=\"ctree.checkClick('"+this.id+"');\" />"+
					"<span style=\"cursor: pointer;vertical-align: top;\">"+this.text+"</span></div>";
		
		if(this.childs.length>0){
			nodestring+="<div id='cfold_"+this.nodeid+"'>";
			for(var i=0;i<this.childs.length;i++){
				node=this.childs[i];
				nodestring+=node.toString();
			}
			nodestring+="</div>";
		}
	}else{
		nodestring+="nfold_"+this.nodeid+"' ondblclick=\"ctree.imgClick('"+this.id+"');\">"+space+
					"<image id='img_"+this.nodeid+"' style=\"cursor: pointer;margin: 0 8px 2px 5px;\""+
					"src='' />"+
					"<input type='checkbox'"+(this.ischeck?" checked=true":"")+" onclick=\"ctree.checkClick('"+this.id+"');\" />"+
					"<span style=\"cursor: pointer;vertical-align: top;\">"+this.text+"</span></div>";
	}
	return nodestring;
};*/
treenode.prototype.imgClick=function(){
	var divid="#cfold_"+this.nodeid;
	var rowstate=jQuery(divid).attr("currentrowstate");
	if(!$("cfold_"+this.nodeid)){return;}
	if(!rowstate||rowstate=="hide"){
		jQuery(divid+" >div").show();
		jQuery(divid).attr({"currentrowstate":"show"});
		jQuery("#img_"+this.id).attr("src","/html/nds/oto/themes/01/images/fold-show.png");
	}else{
		jQuery(divid+" >div").hide();
		jQuery(divid).attr({"currentrowstate":"hide"});
		jQuery("#img_"+this.id).attr("src","/html/nds/oto/themes/01/images/fold-hidden.png");
	}
	
	/*var parentid=this.id;
	var tnodes=jQuery.grep(ctree.arraynodes,function(n,i){
		return n.parentid==parentid;
	});*/
};
treenode.prototype.checkClick=function(ele){
	var reg;
	var node;
	var check;
	var parentnode;
	var parenttexts=[];
	var firstparent;
	var parentString;
	if(!pjson){pjson=[];}
	var isdisposecheld=false;
	var result=jQuery("#result").html();
	var allcount=0;//jQuery("#cfold_"+this.nodeid+" >div").find('input[type="checkbox"]').size();
	
	check=$("check_"+this.id);
	isdisposecheld=!(check.checked^ele.checked);
	
	
	
	if(this.isparent){
		var nodeChilds=[];
		if(ele.checked){
			/*if(this.isparent){*/
			parentnode=this.getParent();
			if(parentnode){check=$("check_"+parentnode.id);}
			while(parentnode&&(check.checked^ele.checked)){
				parentnode.checkClick(ele);
				parentnode=parentnode.getParent();
				result=jQuery("#result").html();
				if(parentnode){check=$("check_"+parentnode.id);}
			}
			
			//查找所有父节点
			parentnode=this.getParent();
			while(parentnode){
				parenttexts[parenttexts.length]=parentnode.text;
				parentnode=parentnode.getParent();
			}
			/*if(ele.checked){*/
			parenttexts=parenttexts.reverse();
			parentString=parenttexts.join(".");
			if(parentString){parentString+="."+this.text;}
			else{parentString=this.text;}
			currentString=parentString+"<br>";
			reg=new RegExp("("+parentString+".[^(<br>)]*<br>)+");
			reg.compile(reg);
			if(reg.test(result)&&parentString){
				var lastreg=reg.exec(result)[0];
				if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
				else{result+=currentString;}
			}else{
				result+=currentString;
			}

			this.currentcheck=ele.checked;
			if(!isdisposecheld){jQuery("#check_"+this.id).attr("checked",ele.checked);}
			jQuery("#result").html(result);
			pjson.push({id:this.id,name:parentString});
			
			if(isdisposecheld){				//若此节点为点击节点，或为点击节点的子节点，且为父节点时，选中所有子节点。
				nodeChilds=this.getChilds();
				for(var i=0;i<nodeChilds.length;i++){
					node=nodeChilds[i];
					node.currentcheck=ele.checked;
					if(node.isparent){
						jQuery("#check_"+node.id).attr("checked",ele.checked);
						node.checkClick(ele);
						result=jQuery("#result").html();
						continue;
					}
					currentString=parentString+"."+node.text+"<br>";
					if(reg.test(result)){
						var lastreg=reg.exec(result)[0];
						if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
						else{result+=currentString;}
					}else{
						result+=currentString;
					}
					pjson.push({id:node.id,name:parentString+"."+node.text});
					jQuery("#check_"+node.id).attr("checked",ele.checked);
					jQuery("#result").html(result);
				}
			}
		}else{
			/*if(this.isparent){*/
			var index=-1;
			nodeChilds=[];
			
			//查找所有父节点
			parentnode=this.getParent();
			while(parentnode){
				parenttexts[parenttexts.length]=parentnode.text;
				parentnode=parentnode.getParent();
			}
			/*if(ele.checked){*/
			parenttexts=parenttexts.reverse();
			parentString=parenttexts.join(".");
			if(parentString){parentString+="."+this.text;}
			else{parentString=this.text;}
			
			this.currentcheck=ele.checked;
			result=result.replace(parentString+"<br>","");
			index=inarrays({id:this.id},pjson);
			if(index>-1){pjson.splice(index,1);}
			
			parentnode=this.getParent();
			jQuery("#result").html(result);
			if(!isdisposecheld){jQuery("#check_"+this.id).attr("checked",ele.checked);}
			if(parentnode){check=$("check_"+parentnode.id);}
			
			
			while(parentnode&&(check.checked^ele.checked)){
				nodeChilds=ctree.getChildsByChecked(parentnode.id,!ele.checked);
				if(nodeChilds.length<=0){parentnode.checkClick(ele);}
				parentnode=parentnode.getParent();
				result=jQuery("#result").html();
				if(parentnode){check=$("check_"+parentnode.id);}
			}
			
			
		
		
		

			if(isdisposecheld){					//若此节点为点击节点，或为点击节点的子节点，且为父节点时，去掉所有子节点选中状态。
				var nodeChilds=this.getChilds();
				for(var i=0;i<nodeChilds.length;i++){
					node=nodeChilds[i];
					node.currentcheck=ele.checked;
					if(node.isparent){
						jQuery("#check_"+node.id).attr("checked",ele.checked);
						node.checkClick(ele);
						result=jQuery("#result").html();
						continue;
					}
					currentString=parentString+"."+node.text+"<br>";
					result=result.replace(currentString,"");
					index=inarrays({id:node.id},pjson);
					if(index>-1){pjson.splice(index,1);}
					check=$("check_"+node.id);
					jQuery("#check_"+node.id).attr("checked",ele.checked);
					jQuery("#result").html(result);
				}
			}
		}
		
		/*
		if(!disposeChilds){	//非点击节点，且选中状态与点击节点不同
			
		
		}else if(!(check.checked^ele.checked)&&!disposeChilds){	//非点击节点，且选中状态与点击节点相同
			
		}else if(disposeChilds){
			parentnode.checkClick(ele,false);
		}
		
		
		if(ele.checked){
			check=$("check_"+this.id);
			if(!check.checked&&!disposeChilds){
				result=jQuery("#result").html();
			}else(disposeChilds){
				
			}
		}
	
	
	
	
		reg=new RegExp("("+parentString+".[^(<br>)]*<br>)+");
		jQuery("#pfold_"+this.nodeid).find(input[type="checkbox"]).prop("checked", ele.checked);
		reg.compile(reg);
		//jQuery("#cfold_"+this.nodeid+" >div").find('input[type="checkbox"]').prop("checked", ele.checked);
		if(ele.checked){
			var node=this.getParent();
			var currentNode=this;
			result+=parentString+"<br>";
			pjson.push({id:this.id,name:parentString});
			while(node){
				jQuery("#pfold_"+node.nodeid).find(input[type="checkbox"]).prop("checked", ele.checked);
				node.checkClick(ele,false);
				parents[parents.length]=node.text;
				node=node.getParent();
			}
			parents=parents.reverse();
			parentString=parents.join(".");
			
			var nodeChilds=[];
			if(disposeChilds){this.getChilds()};
			for(index in nodeChilds){
				node=nodeChilds[index];
				if(!node){continue;}
				
				if(node.isparent){
					node.checkClick();
					continue;
				}
				currentString=parentString+"."+node.text+"<br>";
				if(!new RegExp(currentString,"i").test(result)){
					if(reg.test(result)){
						var lastreg=reg.exec(result)[0];
						if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
						else{result+=currentString;}
					}else{
						result+=currentString;
					}
					pjson.push({id:node.id,name:parentString+"."+node.text});
				}
			}
		}else{
			if(allcount==0){currentString=jQuery(current).attr("text")+"<br>";}
			else{currentString=parentString+"."+jQuery(current).attr("text")+"<br>";}
			
			var checkedcount=jQuery("#cfold_"+this.nodeid+" >div").find('input[type="checkbox"]:checked').size();
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
		}*/
	}else{
		if(ele.checked){
			parentnode=this.getParent();
			if(parentnode){check=$("check_"+parentnode.id);}
			while(parentnode&&(check.checked^ele.checked)){
				parentnode.checkClick(ele);
				parentnode=parentnode.getParent();
				result=jQuery("#result").html();
				if(parentnode){check=$("check_"+parentnode.id);}
			}
			
			//查找所有父节点
			parentnode=this.getParent();
			while(parentnode){
				parenttexts[parenttexts.length]=parentnode.text;
				parentnode=parentnode.getParent();
			}
			
			parenttexts=parenttexts.reverse();
			parentString=parenttexts.join(".");

			currentString=parentString+"."+this.text+"<br>";
			reg=new RegExp("("+parentString+".[^(<br>)]*<br>)+");
			reg.compile(reg);
			if(reg.test(result)&&parentString){
				var lastreg=reg.exec(result)[0];
				if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
				else{result+=currentString;}
			}else{
				result+=currentString;
			}
			this.currentcheck=ele.checked;
			jQuery("#result").html(result);
			pjson.push({id:this.id,name:parentString+"."+this.text});
		}else{
			var index=-1;
			nodeChilds=[];
			
			//查找所有父节点
			parentnode=this.getParent();
			while(parentnode){
				parenttexts[parenttexts.length]=parentnode.text;
				parentnode=parentnode.getParent();
			}
			/*if(ele.checked){*/
			parenttexts=parenttexts.reverse();
			parentString=parenttexts.join(".");
			if(parentString){parentString+="."+this.text;}
			else{parentString=this.text;}
			
			this.currentcheck=ele.checked;
			result=result.replace(parentString+"<br>","");
			index=inarrays({id:this.id},pjson);
			if(index>-1){pjson.splice(index,1);}
			
			parentnode=this.getParent();
			jQuery("#result").html(result);
			if(parentnode){check=$("check_"+parentnode.id);}
			while(parentnode&&(check.checked^ele.checked)){
				nodeChilds=ctree.getChildsByChecked(parentnode.id,!ele.checked);
				if(nodeChilds.length<=0){parentnode.checkClick(ele);}
				parentnode=parentnode.getParent();
				result=jQuery("#result").html();
				if(parentnode){check=$("check_"+parentnode.id);}
			}
		}
	}
};
