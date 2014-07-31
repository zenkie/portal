var AllSelect = function(opt){

	this.container = jQuery(opt.container).eq(0);

	this.checkBoxs = this.container.find('input[type="checkbox"]');

	if(!opt.allSelectBtn){
		this.allSelectBtn = this.checkBoxs.eq(0);
	}
	else{
		this.allSelectBtn = this.container.find(opt.allSelectBtn).eq(0);
	};
};
AllSelect.prototype.init = function(){

	if(this.allSelectBtn[0])this.allSelect();

};
AllSelect.prototype.noAllselect = function(){

	this.allSelectBtn = false;

	

};
AllSelect.prototype.allSelect = function(){

	var _this = this;
	var checked = false;

	this.allSelectBtn.click(function(){

		if(!checked){
			_this.checkBoxs.attr('checked', true);
		}
		else{
			_this.checkBoxs.attr('checked', false);
		}
		
		checked = !checked;
	});

};
AllSelect.prototype.alertBox = function(){

	if(document.deleteTip)return;

	var style = 
	"\
	    #delete_tip{\
	      position: absolute; left:50%; margin: -57px 0px 0 -188px; top:50%;\
	      width:366px; height:114px;\
	      border:1px solid #c7c8c3;\
	      overflow: hidden; display:none;\
	    }\
	    #delete_tip h1{\
	      height:32px; line-height:32px;\
	      text-indent:20px; color: #fff; font-weight:normal; font-size:12px;\
	      background-color: #606060;\
	      border-bottom:1px solid #afafaf;\
	    }\
	    #delete_tip p{\
	      line-height:40px; text-indent:20px;\
	      border-bottom:1px solid #c3c3c3;\
	      background-color: #f3f3f1;\
	    }\
	    #delete_tip ul li{\
	      width:50%; height:42px; text-align:center;\
	      float: left;\
	      background-color: #eeecef;\
	    }\
	    #delete_tip ul li a{\
	        display: inline-block;\
	        width:53px; height:23px; line-height:23px;\
	        background-color: #196ea4; color:#fff;\
	        text-align:center;\
	        margin-top:10px;\
	    }\
	    #delete_tip ul li:first-child{\
	        border-right:1px solid #c7c8c3; margin-left:-1px;\
	    }\
	";

	var html = 
	"\
		  <h1>提醒</h1>\
		  <p>确定删除已选选项吗？</p>\
		  <ul class=cl>\
		      <li><a href=javascript:;>取消</a></li>\
		      <li><a href=javascript:;>删除</a></li>\
		  </ul>\
	";

	document.deleteTip = jQuery('<div id=delete_tip>'+ html +'</div>');
	document.deleteTipStyle = jQuery('<style>'+ style +'</style>');

	document.deleteTipStyle.appendTo(document.deleteTip);

	document.deleteTip.appendTo('body');

	var _this = this;

	document.deleteTip.find('a').click(function(ev){

		if(this.innerHTML.search('删除') != -1){

			jQuery.each(_this.arrCheckedBoxs, function(){

				this.parents(_this.parentTagName).eq(0).remove();
			});

		};
		if(_this.allSelectBtn[0])_this.allSelectBtn.attr('checked', false);
		document.deleteTip.hide();

		ev.stopPropagation();
		return false;
	});

};
AllSelect.prototype.delete = function(btn,parentTagName){

	this.deleteBtn = this.container.find(btn).eq(0);

	if(!this.deleteBtn[0]){
		return false;
	};

	this.alertBox();
	this.parentTagName = parentTagName || 'tr';

	var _this = this;

	this.deleteBtn.click(function(){

		_this.arrCheckedBoxs = [];

		_this.container.find('input[type="checkbox"]').each(function(){

			if( this == _this.allSelectBtn[0] ){
				return;
			};
			var me = jQuery(this);

			if(me.attr('checked') == 'checked'){
				document.deleteTip.show();
				_this.arrCheckedBoxs.push(me);

			};

		});
		
	});
};