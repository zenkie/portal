 jQuery(document).ready(function(){
		var range = 50;             //距下边界长度/单位px  
		var pageNum = 1;
		var pageSize = 10;
		var total = jQuery("#total").val();
		var totalheight = 0;
		var state = 0;  
		var _srollPos = 0;
		jQuery(window).scroll(function(){
            if( Math.ceil(total/pageSize)<=pageNum ){
                return false;
            }
            var srollPos = jQuery(window).scrollTop();    //滚动条距顶部距离(页面超出窗口的高度)  
            if(srollPos<_srollPos){
                return;
            }else{
            	_srollPos = srollPos;
            }
			var comment = jQuery(".rate-grid").find("tr");
			var lastCh = comment[comment.length - 1];
			var lastid = jQuery(lastCh).attr("data-id");//最后一条记录
			var goodsId = jQuery("#goodsId").val();//
            totalheight = parseFloat(jQuery(window).height()) + parseFloat(srollPos);  
            if(!state && ((jQuery(document).height()-range) <= totalheight) ) {
          	    loading(true);
            	state = 1;				
				jQuery.ajax({
					url: '/html/nds/oto/comment/load.jsp?id='+goodsId+'&lastId='+lastid,
					type: 'post',
					success: function (data) {
					loading(false);
					if(data.trim() != "nodata"){
						loading(false);
						jQuery(lastCh).after(data);
						pageNum++;
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
		window.loader = new iDialog();
		window.loader.open({
			classList: "loading",
			title:"",
			close:"",
			content:''
		});
	}else{	
		window.loader&&window.loader.die();
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
					}
				}					
			});
		},
		cancelVal: '关闭',
		cancel: true,
	});	
}