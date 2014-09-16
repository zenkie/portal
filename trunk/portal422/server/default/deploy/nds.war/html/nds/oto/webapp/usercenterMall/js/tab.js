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
			$("#pay_"+this.config.tabstatus).addClass(this.config.btnActiveClass);
			$.ajax({
            url: '/html/nds/oto/webapp/orderdetail/index.vml?vipid='+this.config.vipid+'&tabstatus='+this.config.tabstatus,
            type: 'post',
            data:{},
			success: function (data) {
				$("#payList").html(data);
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
				
			this.btnBox.bind('touchstart click', function(ev){
				ev.preventDefault();
				_index = $(ev.target).closest(_this.config.btn).index();
				if(_index<0)return;
				_this.tab(_index);
			});
		},
		//切换当前选中的列表和按钮
		tab: function(num){
			this.now = num;
			this.btns.removeClass(this.config.btnActiveClass);
			this.btns.eq(this.now).addClass(this.config.btnActiveClass);
			var _tabstatus = this.btns.eq(this.now).attr("id").replace("pay_","");
			$.ajax({
            url: '/html/nds/oto/webapp/orderdetail/index.vml?vipid='+this.config.vipid+'&tabstatus='+_tabstatus,
            type: 'post',
            data:{},
			success: function (data) {
				$("#payList").html(data);
            }			
			
        });
			
		}
	
	};
	Tab.config = {
		btnBox: '#tab-list',	//按钮包裹
		btn: 'div',					//按钮
		btnActiveClass: 'current',	//按钮切换的class
		tabstatus:"tab1"
	};
})(window);