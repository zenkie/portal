/*----------------------------------------------------------------------------\
|                       Cross Browser Tree Widget 1.17                        |
|-----------------------------------------------------------------------------|
|                          Created by Emil A Eklund                           |
|                  (http://webfx.eae.net/contact.html#emil)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An object based tree widget,  emulating the one found in microsoft windows, |
| with persistence using cookies. Works in IE 5+, Mozilla and konqueror 3.    |
|-----------------------------------------------------------------------------|
|                   Copyright (c) 1999 - 2002 Emil A Eklund                   |
|-----------------------------------------------------------------------------|
| This software is provided "as is", without warranty of any kind, express or |
| implied, including  but not limited  to the warranties of  merchantability, |
| fitness for a particular purpose and noninfringement. In no event shall the |
| authors or  copyright  holders be  liable for any claim,  damages or  other |
| liability, whether  in an  action of  contract, tort  or otherwise, arising |
| from,  out of  or in  connection with  the software or  the  use  or  other |
| dealings in the software.                                                   |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| This  software is  available under the  three different licenses  mentioned |
| below.  To use this software you must chose, and qualify, for one of those. |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Non-Commercial License          http://webfx.eae.net/license.html |
| Permits  anyone the right to use the  software in a  non-commercial context |
| free of charge.                                                             |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Commercial license           http://webfx.eae.net/commercial.html |
| Permits the  license holder the right to use  the software in a  commercial |
| context. Such license must be specifically obtained, however it's valid for |
| any number of  implementations of the licensed software.                    |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| GPL - The GNU General Public License    http://www.gnu.org/licenses/gpl.txt |
| Permits anyone the right to use and modify the software without limitations |
| as long as proper  credits are given  and the original  and modified source |
| code are included. Requires  that the final product, software derivate from |
| the original  source or any  software  utilizing a GPL  component, such  as |
| this, is also licensed under the GPL license.                               |
|-----------------------------------------------------------------------------|
| Dependencies: xtree.css (To set up the CSS of the tree classes)             |
|-----------------------------------------------------------------------------|
| 2001-01-10 | Original Version Posted.                                       |
| 2001-03-18 | Added getSelected and get/setBehavior  that can make it behave |
|            | more like windows explorer, check usage for more information.  |
| 2001-09-23 | Version 1.1 - New features included  keyboard  navigation (ie) |
|            | and the ability  to add and  remove nodes dynamically and some |
|            | other small tweaks and fixes.                                  |
| 2002-01-27 | Version 1.11 - Bug fixes and improved mozilla support.         |
| 2002-06-11 | Version 1.12 - Fixed a bug that prevented the indentation line |
|            | from  updating correctly  under some  circumstances.  This bug |
|            | happened when removing the last item in a subtree and items in |
|            | siblings to the remove subtree where not correctly updated.    |
| 2002-06-13 | Fixed a few minor bugs cased by the 1.12 bug-fix.              |
| 2002-08-20 | Added usePersistence flag to allow disable of cookies.         |
| 2002-10-23 | (1.14) Fixed a plus icon issue                                 |
| 2002-10-29 | (1.15) Last changes broke more than they fixed. This version   |
|            | is based on 1.13 and fixes the bugs 1.14 fixed withou breaking |
|            | lots of other things.                                          |
| 2003-02-15 | The  selected node can now be made visible even when  the tree |
|            | control  loses focus.  It uses a new class  declaration in the |
|            | css file '.webfx-tree-item a.selected-inactive', by default it |
|            | puts a light-gray rectangle around the selected node.          |
| 2003-03-16 | Adding target support after lots of lobbying...                |
|-----------------------------------------------------------------------------|
| Created 2000-12-11 | All changes are in the log above. | Updated 2003-03-16 |
\----------------------------------------------------------------------------*/

var webFXTreeConfig = {
	rootIcon        : 'images/foldericon.png',
	openRootIcon    : 'images/openfoldericon.png',
	folderIcon      : 'images/foldericon.png',
	openFolderIcon  : 'images/openfoldericon.png',
	fileIcon        : 'images/file.png',
	iIcon           : 'images/I.png',
	lIcon           : 'images/L.png',
	lMinusIcon      : 'images/Lminus.png',
	lPlusIcon       : 'images/Lplus.png',
	tIcon           : 'images/T.png',
	tMinusIcon      : 'images/Tminus.png',
	tPlusIcon       : 'images/Tplus.png',
	blankIcon       : 'images/blank.png',
	defaultText     : 'Tree Item',
	defaultAction   : 'javascript:void(0);',
	defaultBehavior : 'classic',
	usePersistence	: true
};

var webFXTreeHandler = {
	nodeJson  :{},
	maxChild  :[],
	idCounter : 0,
	idPrefix  : "webfx-tree-object-",
	all       : {},
	behavior  : null,
	selected  : null,
	onSelect  : null,//function(){wem.editMenu(item);}, /* should be part of tree, not handler */
	getId     : function() { return this.idPrefix + this.idCounter++; },
	toggle    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggle(); },
	changeName: function (oItem) { 
				var obj = this;
				var node=obj.all[oItem.id.replace('-changeName','')];
				var parent=node.parentNode;
				var menuName = node.text;
				art.dialog({
					lock:true,
					content: '菜单标题<font color=\"red\">*</font>：<input id=\"add_input\" value=\"'+menuName+'\" /><br/><font color=\"red\"></font>',
					ok:function(){
						var add_in=jQuery("#add_input").val().trim();
						//未修改 或 为空
						if(add_in==""){
							this.DOM.content.find('font')[1].innerHTML="您未输入任何内容！";
							return false;
						}
						if(menuName==add_in){return true;}
						//查询是否有同名菜单
						for(var i=0;i<parent.childNodes.length;i++){
							if(parent.childNodes[i]===node){continue;}
							if(parent.childNodes[i].text==add_in){
								this.DOM.content.find('font')[1].innerHTML="此菜单已存在！";
								return false;
							}
						}
						//修改
						wem.isChangeMenu=true;
						obj.all[node.id].text=add_in;
						jQuery("#"+node.id+"-anchor").text(add_in);
						if(parent.index<0){webFXTreeHandler.nodeJson["button"][node.index].name=add_in;}
						else{webFXTreeHandler.nodeJson["button"][parent.index]["sub_button"][node.index].name=add_in;}
					},
					cancel:true
				});
				//this.all[node.id.replace('-changeName','')].text="22"
				},
	addFir    : function (oItem) {
					//添加一级菜单
					var obj = this;
					art.dialog({
						content: '菜单标题<font color=\"red\">*</font>：<input id=\"add_input\" /><br/><font color=\"red\"></font>',
						lock:true,
						ok:function(){
							var add_in=jQuery("#add_input").val().trim();
							//未输入任何内容
							if(add_in==""){
								this.DOM.content.find('font')[1].innerHTML="您未输入任何内容！";
								return false;
							}
							
							var node=obj.all[oItem.id.replace('-Fir','')];
							//输入内容字数不符
							for(var i=0;i<node.childNodes.length;i++){
								if(node.childNodes[i].text==add_in){
									this.DOM.content.find('font')[1].innerHTML="此菜单已存在,请重新输入！";
									return false;
								}
							}	
							//执行添加
							wem.isChangeMenu=true;
							var item=new WebFXTreeItem(add_in,"javascript:wem.editMenu(this);return false;",node.childNodes.length,node.maxGrandChild);
							obj.all[node.id].add(item);
				
							if(!webFXTreeHandler.nodeJson["button"]){webFXTreeHandler.nodeJson["button"]=[];}
							if(node.index<0){webFXTreeHandler.nodeJson["button"].push({name:add_in,menuType:"Link",key:wem.initKey()});}
							else{
								if(!webFXTreeHandler.nodeJson["button"][node.index]["sub_button"]){webFXTreeHandler.nodeJson["button"][node.index]["sub_button"]=[];}
								webFXTreeHandler.nodeJson["button"][node.index]["sub_button"].push({name:add_in,menuType:"Link",key:wem.initKey()});
							}
							if(node.index>=0&&webFXTreeHandler.nodeJson["button"][node.index]){
								delete webFXTreeHandler.nodeJson["button"][node.index].menuType;
								delete webFXTreeHandler.nodeJson["button"][node.index].type;
								delete webFXTreeHandler.nodeJson["button"][node.index].fromid;
								delete webFXTreeHandler.nodeJson["button"][node.index].objid;
								delete webFXTreeHandler.nodeJson["button"][node.index].key;
							}
							
							var level=isNaN(node._level)?0:node._level+1;
							var maxChild=webFXTreeHandler.maxChild[level]||1000;
							//如果已经满足3个菜单，去掉按钮
							if(node.childNodes.length>=maxChild){
								jQuery(oItem).remove();
								//jQuery("#"+oItem.id).remove();
								//jQuery("#"+oItem.id.replace('-Fir','')+" :last-child").remove();
							}
							node.expand();
							wem.editMenu(item);
						},
						cancel:true
					});
				},
	delNode: function (oItem,message) {
		var obj = this;
		art.dialog({
			content: '确定要删除此菜单吗?',
			lock:true,
			ok:function(){
				var node=obj.all[oItem.id.replace('-delNode','')];
				var parentNode=node.parentNode;
				var level=isNaN(parentNode._level)?0:parentNode._level+1;
				var maxChild=webFXTreeHandler.maxChild[level]||1000;
				var addi;
				
				wem.isChangeMenu=true;
				if(parentNode.childNodes.length-1<maxChild&&!$(parentNode.id+"-Fir")){
					addi="<i class=\"add add-level2\" id=\""+parentNode.id+"-Fir\" title=\"添加"+(level>0?"二":"一")+"级菜单\" onclick=\"webFXTreeHandler.addFir(this);\"></i>";
					jQuery("#"+parentNode.id+" >div[class=right]").append(addi);
				}
				for(var i=node.index+1;i<parentNode.childNodes.length;i++){parentNode.childNodes[i].index-=1;}
				if(maxChild>3){
					webFXTreeHandler.nodeJson["button"][parentNode.index]["sub_button"].splice(node.index,1);
					if(webFXTreeHandler.nodeJson["button"][parentNode.index]["sub_button"].length<=0){delete webFXTreeHandler.nodeJson["button"][parentNode.index]["sub_button"];}
				}else{
					webFXTreeHandler.nodeJson["button"].splice(node.index,1);
				}
				node.remove();
			},
			cancel:true
		});
	},
	select    : function (oItem) { this.all[oItem.id.replace('-icon','')].select(); },
	focus     : function (oItem) { this.all[oItem.id.replace('-anchor','')].focus(); },
	blur      : function (oItem) { this.all[oItem.id.replace('-anchor','')].blur(); },
	keydown   : function (oItem, e) { return this.all[oItem.id].keydown(e.keyCode); },
	cookies   : new WebFXCookie(),
	insertHTMLBeforeEnd	:	function (oElement, sHTML) {
		if (oElement.insertAdjacentHTML != null) {
			oElement.insertAdjacentHTML("BeforeEnd", sHTML)
			return;
		}
		var df;	// DocumentFragment
		var r = oElement.ownerDocument.createRange();
		r.selectNodeContents(oElement);
		r.collapse(false);
		df = r.createContextualFragment(sHTML);
		oElement.appendChild(df);
	}
};

/*
 * WebFXCookie class
 */

function WebFXCookie() {
	if (document.cookie.length) { this.cookies = ' ' + document.cookie; }
}

WebFXCookie.prototype.setCookie = function (key, value) {
	document.cookie = key + "=" + escape(value);
}

WebFXCookie.prototype.getCookie = function (key) {
	if (this.cookies) {
		var start = this.cookies.indexOf(' ' + key + '=');
		if (start == -1) { return null; }
		var end = this.cookies.indexOf(";", start);
		if (end == -1) { end = this.cookies.length; }
		end -= start;
		var cookie = this.cookies.substr(start,end);
		return unescape(cookie.substr(cookie.indexOf('=') + 1, cookie.length - cookie.indexOf('=') + 1));
	}
	else { return null; }
}

/*
 * WebFXTreeAbstractNode class
 */

function WebFXTreeAbstractNode(sText, sAction,index) {
	this.index=parseInt(index)>=0?parseInt(index):-1;
	this.childNodes  = [];
	this.id     = webFXTreeHandler.getId();
	this.text   = sText || webFXTreeConfig.defaultText;
	this.action = sAction || webFXTreeConfig.defaultAction;
	this._last  = false;
	webFXTreeHandler.all[this.id] = this;
}

/*
 * To speed thing up if you're adding multiple nodes at once (after load)
 * use the bNoIdent parameter to prevent automatic re-indentation and call
 * the obj.ident() method manually once all nodes has been added.
 */

WebFXTreeAbstractNode.prototype.add = function (node, bNoIdent) {
	node.parentNode = this;
	this.childNodes[this.childNodes.length] = node;
	var root = this;
	if (this.childNodes.length >= 2) {
		this.childNodes[this.childNodes.length - 2]._last = false;
	}
	while (root.parentNode) { root = root.parentNode; }
	if (root.rendered) {
		if (this.childNodes.length >= 2) {
			document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-plus').src = ((this.childNodes[this.childNodes.length -2].folder)?((this.childNodes[this.childNodes.length -2].open)?webFXTreeConfig.tMinusIcon:webFXTreeConfig.tPlusIcon):webFXTreeConfig.tIcon);
			this.childNodes[this.childNodes.length - 2].plusIcon = webFXTreeConfig.tPlusIcon;
			this.childNodes[this.childNodes.length - 2].minusIcon = webFXTreeConfig.tMinusIcon;
			this.childNodes[this.childNodes.length - 2]._last = false;
		}
		this._last = true;
		var foo = this;
		while (foo.parentNode) {
			for (var i = 0; i < foo.parentNode.childNodes.length; i++) {
				if (foo.id == foo.parentNode.childNodes[i].id) { break; }
			}
			if (i == foo.parentNode.childNodes.length - 1) { foo.parentNode._last = true; }
			else { foo.parentNode._last = false; }
			foo = foo.parentNode;
		}
		webFXTreeHandler.insertHTMLBeforeEnd(document.getElementById(this.id + '-cont'), node.toString());
		if ((!this.folder) && (!this.openIcon)) {
			this.icon = webFXTreeConfig.folderIcon;
			this.openIcon = webFXTreeConfig.openFolderIcon;
		}
		if (!this.folder) { this.folder = true; this.collapse(true); }
		if (!bNoIdent) { this.indent(); }
	}
	return node;
}

WebFXTreeAbstractNode.prototype.toggle = function() {
	if (this.folder) {
		if (this.open) { this.collapse(); }
		else { this.expand(); }
}	}

WebFXTreeAbstractNode.prototype.select = function() {
	try{document.getElementById(this.id + '-anchor').focus();
	}catch(ex){}
}

WebFXTreeAbstractNode.prototype.deSelect = function() {
	try{
	document.getElementById(this.id + '-anchor').className = '';
	}catch(ex){}
	webFXTreeHandler.selected = null;
}

WebFXTreeAbstractNode.prototype.focus = function() {
	var isFinsh=true;
	if (webFXTreeHandler.onSelect) { isFinsh=webFXTreeHandler.onSelect(this); }
	if(!isFinsh){return false;}
	if ((webFXTreeHandler.selected) && (webFXTreeHandler.selected != this)) { 
		//if(webFXTreeHandler.selected.folder) webFXTreeHandler.selected.collapse();
		webFXTreeHandler.selected.deSelect(); 
	}
	webFXTreeHandler.selected = this;
	if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.openIcon; }
	document.getElementById(this.id + '-anchor').className = 'selected';
	document.getElementById(this.id + '-anchor').focus();
	
//added by yfzhu to expand node (2008-05-16)
	if(this.folder)this.expand();
}

WebFXTreeAbstractNode.prototype.blur = function() {
	if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected-inactive';
}

WebFXTreeAbstractNode.prototype.doExpand = function() {
	if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.openIcon; }
	//if (this.childNodes.length) {  document.getElementById(this.id + '-cont').style.display = 'block'; }
	if (this.childNodes.length) {  jQuery("#"+this.id + "-cont").removeClass("hidden-child").addClass("show-child"); }
	this.open = true;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '1');
}	}

WebFXTreeAbstractNode.prototype.doCollapse = function() {
	if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.icon; }
	//if (this.childNodes.length) { document.getElementById(this.id + '-cont').style.display = 'none'; }
	if (this.childNodes.length) { jQuery("#"+this.id + "-cont").removeClass("show-child").addClass("hidden-child"); }
	this.open = false;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '0');
}	}

WebFXTreeAbstractNode.prototype.expandAll = function() {
	this.expandChildren();
	if ((this.folder) && (!this.open)) { this.expand(); }
}

WebFXTreeAbstractNode.prototype.expandChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].expandAll();
} }

WebFXTreeAbstractNode.prototype.collapseAll = function() {
	this.collapseChildren();
	if ((this.folder) && (this.open)) { this.collapse(true); }
}

WebFXTreeAbstractNode.prototype.collapseChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].collapseAll();
} }

WebFXTreeAbstractNode.prototype.indent = function(lvl, del, last, level, nodesLeft) {
	/*
	 * Since we only want to modify items one level below ourself,
	 * and since the rightmost indentation position is occupied by
	 * the plus icon we set this to -2
	 */
	if (lvl == null) { lvl = -2; }
	var state = 0;
	for (var i = this.childNodes.length - 1; i >= 0 ; i--) {
		state = this.childNodes[i].indent(lvl + 1, del, last, level);
		if (state) { return; }
	}
	if (del) {
		if ((level >= this._level) && (document.getElementById(this.id + '-plus'))) {
			if (this.folder) {
				document.getElementById(this.id + '-plus').src = (this.open)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.lPlusIcon;
				this.plusIcon = webFXTreeConfig.lPlusIcon;
				this.minusIcon = webFXTreeConfig.lMinusIcon;
			}
			else if (nodesLeft) { document.getElementById(this.id + '-plus').src = webFXTreeConfig.lIcon; }
			return 1;
		}	
	}
	var foo = document.getElementById(this.id + '-indent-' + lvl);
	if (foo) {
		if ((foo._last) || ((del) && (last))) { foo.src =  webFXTreeConfig.blankIcon; }
		else { foo.src =  webFXTreeConfig.iIcon; }
	}
	return 0;
}

WebFXTreeAbstractNode.prototype.move=function(e){
	
}
/*
 * WebFXTree class
 */

function WebFXTree(sText, sAction, index, sBehavior, sIcon, sOpenIcon) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction, index);
	this.icon      = sIcon || webFXTreeConfig.rootIcon;
	this.openIcon  = sOpenIcon || webFXTreeConfig.openRootIcon;
	/* Defaults to open */
	if (webFXTreeConfig.usePersistence) {
		this.open  = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '0')?false:true;
	} else { this.open  = true; }
	this.folder    = true;
	this.rendered  = false;
	this.onSelect  = null;
	if (!webFXTreeHandler.behavior) {  webFXTreeHandler.behavior = sBehavior || webFXTreeConfig.defaultBehavior; }
}

WebFXTree.prototype = new WebFXTreeAbstractNode;

WebFXTree.prototype.setBehavior = function (sBehavior) {
	webFXTreeHandler.behavior =  sBehavior;
};

WebFXTree.prototype.getBehavior = function (sBehavior) {
	return webFXTreeHandler.behavior;
};

WebFXTree.prototype.getSelected = function() {
	if (webFXTreeHandler.selected) { return webFXTreeHandler.selected; }
	else { return null; }
}

WebFXTree.prototype.remove = function() { }

WebFXTree.prototype.expand = function() {
	this.doExpand();
}

WebFXTree.prototype.collapse = function(b) {
	//yfzhu markedup
	//if (!b) { this.focus(); }
	this.doCollapse();
}

WebFXTree.prototype.getFirst = function() {
	return null;
}

WebFXTree.prototype.getLast = function() {
	return null;
}

WebFXTree.prototype.getNextSibling = function() {
	return null;
}

WebFXTree.prototype.getPreviousSibling = function() {
	return null;
}

WebFXTree.prototype.keydown = function(key) {
	if (key == 39) {
		if (!this.open) { this.expand(); }
		else if (this.childNodes.length) { this.childNodes[0].select(); }
		return false;
	}
	if (key == 37) { this.collapse(); return false; }
	if ((key == 40) && (this.open) && (this.childNodes.length)) { this.childNodes[0].select(); return false; }
	return true;
}

WebFXTree.prototype.toString = function() {
	var str = "<div id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<a href=\"javascript:;\" onclick=\"" + this.action + "\" id=\"" + this.id + "-anchor\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + this.text + "</a><div class=\"right\">";
	
	//一级菜单不能0~3个
	var level=isNaN(this._level)?0:this._level+1;
	var maxChild=webFXTreeHandler.maxChild[level]||1000;
	if(this.childNodes.length<maxChild){	
		str+="<i class=\"add add-level2\" id=\"" + this.id + "-Fir\" title=\"添加一级菜单\" onclick=\"webFXTreeHandler.addFir(this);\"></i>";
	}
	str+="</div>";
	
	str+="</div>" +
		//"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container "+((this.open)?"show-child":"hidden-child")+"\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	return str + sb.join("") + "</div>";
};

/*
 * WebFXTreeItem class
 */

function WebFXTreeItem(sText, sAction,index, eParent, sIcon, sOpenIcon) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction,index);
	/* Defaults to close */
	if (webFXTreeConfig.usePersistence) {
		this.open = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '1')?true:false;
	} else { this.open = false; }
	if (sIcon) { this.icon = sIcon; }
	if (sOpenIcon) { this.openIcon = sOpenIcon; }
	if (eParent) { eParent.add(this); }
}

WebFXTreeItem.prototype = new WebFXTreeAbstractNode;

WebFXTreeItem.prototype.remove = function() {
	var iconSrc = document.getElementById(this.id + '-plus').src;
	var parentNode = this.parentNode;
	var prevSibling = this.getPreviousSibling(true);
	var nextSibling = this.getNextSibling(true);
	var folder = this.parentNode.folder;
	var last = ((nextSibling) && (nextSibling.parentNode) && (nextSibling.parentNode.id == parentNode.id))?false:true;
	this.getPreviousSibling().focus();
	this._remove();
	if (parentNode.childNodes.length == 0) {
		//document.getElementById(parentNode.id + '-cont').style.display = 'none';
		jQuery("#"+parentNode.id + "-cont").removeClass("show-child").addClass("hidden-child");
		parentNode.doCollapse();
		parentNode.folder = false;
		parentNode.open = false;
	}
	if (!nextSibling || last) { parentNode.indent(null, true, last, this._level, parentNode.childNodes.length); }
	if ((prevSibling == parentNode) && !(parentNode.childNodes.length)) {
		prevSibling.folder = false;
		prevSibling.open = false;
		var pl=document.getElementById(prevSibling.id + '-plus');
		if(pl){
			iconSrc = pl.src;
			iconSrc = iconSrc.replace('minus', '').replace('plus', '');
			document.getElementById(prevSibling.id + '-plus').src = iconSrc;
		}
		document.getElementById(prevSibling.id + '-icon').src = webFXTreeConfig.fileIcon;
	}
	if (document.getElementById(prevSibling.id + '-plus')) {
		if (parentNode == prevSibling.parentNode) {
			iconSrc = iconSrc.replace('minus', '').replace('plus', '');
			document.getElementById(prevSibling.id + '-plus').src = iconSrc;
		}	
	}	
}

WebFXTreeItem.prototype._remove = function() {
	for (var i = this.childNodes.length - 1; i >= 0; i--) {
		this.childNodes[i]._remove();
 	}
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) {
			for (var j = i; j < this.parentNode.childNodes.length; j++) {
				this.parentNode.childNodes[j] = this.parentNode.childNodes[j+1];
			}
			this.parentNode.childNodes.length -= 1;
			if (i + 1 == this.parentNode.childNodes.length) { this.parentNode._last = true; }
			break;
		}
	}
	webFXTreeHandler.all[this.id] = null;
	var tmp = document.getElementById(this.id);
	if (tmp) { tmp.parentNode.removeChild(tmp); }
	tmp = document.getElementById(this.id + '-cont');
	if (tmp) { tmp.parentNode.removeChild(tmp); }
}

WebFXTreeItem.prototype.expand = function() {
	this.doExpand();
	document.getElementById(this.id + '-plus').src = this.minusIcon;
}

WebFXTreeItem.prototype.collapse = function(b) {
	//yfzhu marked up
	//if (!b) { this.focus(); }
	this.doCollapse();
	document.getElementById(this.id + '-plus').src = this.plusIcon;
}

WebFXTreeItem.prototype.getFirst = function() {
	return this.childNodes[0];
}

WebFXTreeItem.prototype.getLast = function() {
	if (this.childNodes[this.childNodes.length - 1].open) { return this.childNodes[this.childNodes.length - 1].getLast(); }
	else { return this.childNodes[this.childNodes.length - 1]; }
}

WebFXTreeItem.prototype.getNextSibling = function() {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (++i == this.parentNode.childNodes.length) { return this.parentNode.getNextSibling(); }
	else { return this.parentNode.childNodes[i]; }
}

WebFXTreeItem.prototype.getPreviousSibling = function(b) {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (i == 0) { return this.parentNode; }
	else {
		if ((this.parentNode.childNodes[--i].open) || (b && this.parentNode.childNodes[i].folder)) { return this.parentNode.childNodes[i].getLast(); }
		else { return this.parentNode.childNodes[i]; }
} }

WebFXTreeItem.prototype.keydown = function(key) {
	if ((key == 39) && (this.folder)) {
		if (!this.open) { this.expand(); }
		else { this.getFirst().select(); }
		return false;
	}
	else if (key == 37) {
		if (this.open) { this.collapse(); }
		else { this.parentNode.select(); }
		return false;
	}
	else if (key == 40) {
		if (this.open) { this.getFirst().select(); }
		else {
			var sib = this.getNextSibling();
			if (sib) { sib.select(); }
		}
		return false;
	}
	else if (key == 38) { this.getPreviousSibling().select(); return false; }
	return true;
}

WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = "<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + ((foo._last)?webFXTreeConfig.blankIcon:webFXTreeConfig.iIcon) + "\">" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else { this.open = false; }
	if ((this.folder) || (webFXTreeHandler.behavior != 'classic')) {
		if (!this.icon) { this.icon = webFXTreeConfig.folderIcon; }
		if (!this.openIcon) { this.openIcon = webFXTreeConfig.openFolderIcon; }
	}
	else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	var str = "<div id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
		indent +
		"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<a href=\"javascript:;\" onclick=\"" + this.action + "\" id=\"" + this.id + "-anchor\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + label + "</a><div class=\"right\">";
	var level=isNaN(this._level)?0:this._level+1;
	var maxChild=webFXTreeHandler.maxChild[level]||1000;
	//判断floder是否要添加 +
	if((!this.parentNode.parentNode)&&this.childNodes.length<maxChild){
		str+="<i class=\"add add-level2\" id=\"" + this.id + "-Fir\" title=\"添加二级菜单\" onclick=\"webFXTreeHandler.addFir(this);\"></i>";
	}
	//添加修改选项
	str+="<i class=\"editmenu\" id=\"" + this.id + "-changeName\" title=\"修改显示名称\" onclick=\"webFXTreeHandler.changeName(this);\"></i>";
	//添加删除选项
	str+="<i class=\"del\" id=\"" + this.id + "-delNode\" title=\"删除菜单\" onclick=\"webFXTreeHandler.delNode(this,'";
	str+=(this.folder)?"此菜单及其包含子菜单":"此菜单";
	str+="');\"></i>";
	
	str+="</div></div>" +
		//"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container " + ((this.open)?"show-child":"hidden-child") + "\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
	}
	this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
	this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
	return str + sb.join("") + "</div>";
}