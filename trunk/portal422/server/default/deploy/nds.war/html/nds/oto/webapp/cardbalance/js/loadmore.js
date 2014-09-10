 $(document).ready(function(){
		var range = 50;             //距下边界长度/单位px  
		var pageNum = 1;  
		var totalheight = 0;		
		//var main = $("#list_article");                //主体元素
		var state = 0;  
		var _srollPos = 0;
		$(window).scroll(function(){
			var _tr = $(".table_record").find("tbody").find("tr");
			var lastCh = _tr[_tr.length - 1];
			var lastid = jQuery(lastCh).attr("data-id");
            var pageSize = 15;
            var total = 916;
            // if( Math.ceil(total/pageSize)<pageNum ){
                  // return false;
            // }
            var srollPos = $(window).scrollTop();    //滚动条距顶部距离(页面超出窗口的高度)  
            if(srollPos<_srollPos){
                return;
            }else{
            	_srollPos = srollPos;
            }
            totalheight = parseFloat($(window).height()) + parseFloat(srollPos);  
            if(!state && (($(document).height()-range) <= totalheight) ) {
          	    loading(true);
            	state = 1;				
				jQuery.ajax({
					url: '/html/nds/oto/webapp/cardbalance/loadIndex.vml?lastid='+lastid,
					type: 'post',
					success: function (data) {
					loading(false);
					if(data.trim().length>0 && (data.trim()!="")){
						$(lastCh).after(data);
						pageNum ++;
						state = 0;
					}else{
						loading(false);
						state = 0;
						// alert("没有更多了...",true,1500);
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
		//setTimeout(function(){
			window.loader&&window.loader.die();
			delete window.loader;
		//}, 1000);
	}
	
}