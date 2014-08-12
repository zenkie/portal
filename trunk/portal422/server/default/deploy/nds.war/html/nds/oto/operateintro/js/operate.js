jQuery(document).ready(init);		
function init() {
	jQuery(".aL").click(function(){//绑定点击事件 上一步
		prev();
	});
	jQuery(".aR").click(function(){//绑定点击事件 下一步
		next();
	}); 
	jQuery(".stepDetail").find("a").first().addClass("active");//初始化第一步 样式
	var url = jQuery(".stepDetail").find("a").first().attr("data-src");//获取第一步跳转链接
	var ifr = jQuery(".stepDetail").find("a").first().attr("data-ifr");
	var precent = jQuery(".stepDetail").find("a").first().attr("data-precent");//获取完成进度	
	jQuery("#processbar").css("width", precent + "%");//进度条
	jQuery("#cprecent").html(precent + "%");//完成度
	pc.navigate(url,ifr,"");//显示第一步操作界面
}

function complete() {//全部
	RemoveAllClass();
	jQuery("#complete").addClass("active");
	jQuery("#processbar").css("width", "100%");
	jQuery("#cprecent").html("100%");
	if (confirm("配置完成，是否继续浏览其他教程？")) {
		var oItem = jQuery(".page-tab-selected");
		oItem.id = oItem.attr("id");
		categoryTabHandler.select(oItem);//显示主页面
	} else {
		return false;
	}
}

function RemoveAllClass() {
	jQuery(".stepDetail").find("a").removeClass("active");
}

function changestep(a) {
	var jQuerythis = jQuery(a);
	change(jQuerythis);	
}

function change(current) {
	var url = current.attr("data-src");	//跳转链接
	var precent = current.attr("data-precent");//完成进度
	var ifr = current.attr("data-ifr");//显示跳转链接控件
	jQuery("#processbar").css("width", precent + "%");//设置进度
	jQuery("#cprecent").html(precent + "%");//设置进度条值
	RemoveAllClass();
	current.addClass("active");
	//右侧界面切换start
	pc.navigate(url,ifr,current);
	//右侧界面切换end
}

function prev() {//上一步
	var current = jQuery(".active");
	var step = current.attr("data-step");
	step = parseInt(step);
	if (step != 1) {
		step -= 1;
		var prev = jQuery("#step" + step);
		change(prev);
	}
}

function next() {//下一步
	var current = jQuery(".active");
	var step = current.attr("data-step");
	step = parseInt(step);
	var precent = current.attr("data-precent")
	if (precent != 100) {
		step += 1;
		var next = jQuery("#step" + step);
		change(next);
	} else {
		complete();
	}
}