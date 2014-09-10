(function(window){
	function Tab(container, opt){
		this.container = $(container);	//包裹对象
		this.btnBox= false;	//按钮包裹对象
		this.btns = false;	//所有按钮
		this.now = 0;	//当前索引
		this.config = $.extend({}, Tab.config, opt);//配置
		this.init();
	}
	window.Tab = Tab;

	Tab.prototype = {
		init: function(){
			this.getDom();		//获取元素
			this.addEvents();	//add事件监听
			var _cateid = $($(".subcatetitle")[0]).attr("data_id").split("id=")[1];
			$($(".subcatetitle")[0]).addClass("textcolor");
			$.ajax({
            //url: '/html/nds/oto/website/399/content.vml?ptype=text&id='+this.config.cateid,
			url: '/html/nds/oto/website/399/content.vml?ptype=text&id='+_cateid,
            type: 'post',
            data:{},
			success: function (data) {
				$("#page_icenter").html(data);
            }
			});
		},
		getDom: function(){
			this.btnBox = this.container.find(this.config.btnBox);
			this.btns = this.btnBox.find(this.config.btn);
		},
		addEvents: function(){
			var _this = this,
				_index = 0;
				
			this.btns.bind('touchstart click', function(ev){
				ev.preventDefault();
				_index = $(ev.target).closest(_this.config.btn).index();
				if(_index<0)return;
				_this.tab(_index);
			});
		},
		//切换当前选中的列表和按钮
		tab: function(num){
			changeTabContent(num);
		}
	};
	Tab.config = {
		btnBox: '.subcate',	//按钮包裹
		btn: '.subcatelink',//按钮
		cateid:"-1",
		listfold:""
	};
})(window);
function changeTabContent(num){
	this.now = num;
	//var _cateid = this.btns.eq(this.now).attr("id").replace("pay_","");
	var _cateid = $($(".subcatetitle")[this.now]).attr("data_id").split("id=")[1];
	//$(this.btns.removeClass("textcolor").eq(this.now).addClass("textcolor"));
	//$($(".subcatetitle")[this.now]).addClass("textcolor").eq(this.now-1).removeClass("textcolor");
	Tab.config;
	$.ajax({
		url: '/html/nds/oto/website/399/content.vml?ptype=text&id='+_cateid,
		type: 'post',
		data:{},
		success: function (data) {
			$(".subcatetitle").removeClass("textcolor").eq(num).addClass("textcolor");
			$("#page_icenter").html(data);
		}
	});
}
function sliderCategory(){
	$(".pton").hover(function(){
		$("#btn_prev,#btn_next").fadeIn()
	},function(){
		$("#btn_prev,#btn_next").fadeOut()
	});
	$dragBln = false;
	$(".pton").touchSlider({
		flexible : true,
		btn_prev : $("#btn_prev"),
		btn_next : $("#btn_next"),

		counter : function (e){
			changeTabContent(e.current-1);
		//	$(".subcatetitle").removeClass("textcolor").eq(e.current-1).addClass("textcolor");
		}
	});
	
	$(".pton").bind("mousedown", function() {
		$dragBln = false;
	});
	
	$(".pton").bind("dragstart", function() {
		$dragBln = true;
	});
	
	$(".pton a").click(function(){
		if($dragBln) {
			return false;
		}
	});
}