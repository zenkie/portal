(function(window){
	function Tab(container, opt){
		this.container = jQuery(container);	//包裹对象
		this.btnBox= false;	//按钮包裹对象
		this.listBox = false;	//切换列表包裹对象
		this.btns = false;	//所有按钮
		this.lists = false;	//所有列表
		this.now = 0;	//当前索引
		this.config = jQuery.extend({}, Tab.config, opt);//配置
		this.init();
	}
	window.Tab = Tab;

	Tab.prototype = {
		init: function(){
			this.getDom();		//获取元素
			this.addEvents();	//add事件监听
		},
		getDom: function(){
			this.btnBox = this.container.find(this.config.btnBox);
			this.listBox = this.container.find(this.config.listBox);

			this.btns = this.btnBox.find(this.config.btn);
			this.lists = this.listBox.find(this.config.list);
		},
		addEvents: function(){
			var _this = this,
				_index = 0;

			this.btnBox.bind('touchstart click', function(ev){
				ev.preventDefault();
				_index = jQuery(ev.target).closest(_this.config.btn).index();
				if(_index<0)return;
				_this.tab(_index);
			});
		},
		//切换当前选中的列表和按钮
		tab: function(num){
			this.now = num;
			this.btns.removeClass(this.config.btnActiveClass);
			this.btns.eq(this.now).addClass(this.config.btnActiveClass);

			this.lists.removeClass(this.config.listActiveClass);
			this.lists.eq(this.now).addClass(this.config.listActiveClass);

		}
	
	};
	Tab.config = {
		btnBox: '#divTempHeader',	//按钮包裹
		listBox: '.tag-panel-contnt1',	//切换列表包裹
		btn: 'a',					//按钮
		list: '>div',					//列表
		btnActiveClass: 'tag-panel-iscurrent',	//按钮切换的class
		listActiveClass: 'show'	//列表切换的class
	};
})(window);