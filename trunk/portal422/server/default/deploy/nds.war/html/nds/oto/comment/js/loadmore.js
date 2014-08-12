 jQuery(document).ready(function(){
		var range = 50;//距下边界长度/单位px  
		var pageNum = 1;//当前第几页	
		var pageSize = 10;//一页大小
		var total = jQuery("#total").val();//记录总数
		var totalheight = 0;
		var state = 0;  //dialog状态 0没有 1有
		var _srollPos = 0;//记录临时scrollTop
		jQuery(window).scroll(function(){
            if( Math.ceil(total/pageSize)<=pageNum ){//总页数小于或等于当前页数 不需要加载
                return false;
            }
            var srollPos = jQuery(window).scrollTop();    //滚动条距顶部距离(页面超出窗口的高度)  
            if(srollPos<_srollPos){
                return;
            }else{
            	_srollPos = srollPos;
            }
			var comment = jQuery(".rate-grid").find("tr");//获取记录的表
			var lastCh = comment[comment.length - 1];//获取记录最后一个元素
			var lastid = jQuery(lastCh).attr("data-id");//最后一条记录
			var commentID = jQuery("#commentID").val();//
            totalheight = parseFloat(jQuery(window).height()) + parseFloat(srollPos);  
            if(!state && ((jQuery(document).height()-range) <= totalheight) ) {//当滚动到最低端加载
          	    loading(true);//显示loading  dialog
            	state = 1;				
				jQuery.ajax({
					url: '/html/nds/oto/comment/load.jsp?id='+commentID+'&lastId='+lastid,
					type: 'post',
					success: function (data) {
					loading(false);
					if(data.trim() != "nodata"){//没有数据是 返回nodata
						loading(false);
						jQuery(lastCh).after(data);//装载返回的数据
						pageNum++;//当前页数增加
						state=0;
					}else{
						loading(false);
						state = 0;						
					}					
					}					
				});
            }  
        }); 
});

function loading(type){
	if(type){
		window.loader = new iDialog();//创建dialog
		window.loader.open({
			classList: "loading",
			title:"",
			close:"",
			content:''
		});
	}else{	
		window.loader&&window.loader.die();//销毁dialog
		delete window.loader;
	}
}

function deleteComment(_this){
	art.dialog({
		content: '是否删除？',
		ok: function () {
			var id = jQuery(_this).closest("tr").attr("data-id");
			var _params = "{\"table\":22201,\"id\":"+id+"}";//22201 WX_COMMENT;
			jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:"ObjectDelete",params:_params},
				success: function (data) {			
					var _data = eval("("+data+")");
					if (_data[0].code == 0) {				
						//删除成功
						location.reload();
					} else {
						//删除失败
						//alert(_data[0].message); 返回的数据
					}
				}					
			});
		},
		cancelVal: '关闭',
		cancel: true,
	});	
}