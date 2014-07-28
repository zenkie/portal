var cus;
var customMenu = Class.create();

customMenu.prototype={
	initialize:function(){
		
		
	},	
	addSecMenu:function(fir){
		//添加二级菜单
		var firMenu = fir;
		var secName;
		art.dialog({
			title:"添加二级菜单",
			content:'添加二级菜单：<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;<input id="seName" type="text" />',
			ok:function(){
				secName=jQuery("#seName").val();
				//添加html以及修改样式
				jQuery(firMenu).parent().next().append("<li class=\"line\">&nbsp;</li><li class=\"doc\"><span class=\"text\">"
					+secName
					+"</span><div class=\"right\"><i class=\"editmenu\"></i><i class=\"del\"></i></div></li>");
				//firMenu.append('<li id="140409110044007937" class="doc"><span class="text">购物车</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li>');
				//判断是否可以继续添加
				if(jQuery(firMenu).parent().next().children().length==11){
					alert("不能继续添加");
				}
			},
			cancel:true
		});
	},
	delSecMenu:function(){
	//删除二级菜单
	},
	testBun:function(){
		jQuery.each(jsondata,function(key,val){
				//判断是否是首个文件夹
				if(jQuery.type(val)!="string"){
					var sa = val;
					//循环value 生成子菜单
					jQuery.each(val,function(keySec,valSec){
						var se = valSec;
					})
				}	
			});
	}
};
customMenu.main = function () {
	cus=new customMenu();
};
jQuery(document).ready(customMenu.main);