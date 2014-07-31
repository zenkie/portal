function sidebar(){
	var cid;
	var pid;
	var url;
    var oContainer = jQuery("#container");
    var oTopAlertBox = jQuery('#top_alert_box');
    var aAlertBoxDD = oTopAlertBox.find('dd');
    var oDt = oTopAlertBox.find('dt');
    var oTitle = oDt.find('span');
    /*var oDeleteBtn = oDt.find('a');*/
    var arrTopIcon = [ jQuery('#mail_xiao_xi'), jQuery('#news')];

    //aAlertBoxDD.height(jQuery(window).height() - oDt.outerHeight());

    jQuery.each(
		arrTopIcon,
		function(i) {
			this.unbind("click");
			this.click(function() {
				oTitle.html(jQuery(this).attr('title'));
				cid=jQuery(this).attr('cid');
				pid=jQuery(this).attr('pid');
				url=jQuery(this).attr('url');
				
				
				var cObject=this;
				jQuery(this).attr("disabled", "disabled");
				//jQuery(this).removeClass("top-button-hover");
				//jQuery(this).addClass("top-button-wait");
				jQuery(this).css({"cursor":"wait"});

				aAlertBoxDD.hide();
				this.show();
				jQuery("#top_alert_box").slideDown("fast");
				//oTopAlertBox.stop.slideDown("fast");
				/*oTopAlertBox.stop().animate({
					marginLeft: -300
				},
				'slow');*/
				/*oContainer.stop().animate({
					left: -300
				},
				'slow');*/
				//url="/html/nds/portal/ssv/tablecategoryout.jsp?id="+pid+"&&onlyfa='Y'";
				
				if(cid && url){
					jQuery.ajax({
						type: "get",  
						url: url,  
						cache: false,  
						error: function (data) { 
							jQuery(cObject).removeAttr("disabled");	
							jQuery(cObject).css({"cursor":"pointer"});
						},  
						success: function (data) {
							var result=data.xml;
							if(!result){result=data;}
							jQuery("#"+cid).show();
							jQuery("#"+cid).html(result);
							jQuery(cObject).removeAttr("disabled");	
							jQuery(cObject).css({"cursor":"pointer"});
						} 
					});
				}else{
					jQuery(cObject).removeAttr("disabled");	
					jQuery(cObject).css({"cursor":"pointer"});
				}
				jQuery("#div_shou_cang").hide();
				return false;
			});
		}
	);

    oTopAlertBox.click(function(ev) {
        ev.stopPropagation()
    });

    jQuery(document).click(function() {
        /*oContainer.animate({
            left: 0
        },
        'slow');*/
        /*oTopAlertBox.stop().animate({
            marginLeft: 0
        },
        'slow');*/
		jQuery("#top_alert_box").slideUp("fast");
		jQuery("#div_shou_cang").hide();
		//return false;
    });
	jQuery("#div_shou_cang").click(function(event){
		if(event.srcElement.tagName != "A" || jQuery(event.srcElement).text() == "我的收藏夹" || jQuery(event.srcElement).attr("class") == "select_all")
			event.stopPropagation();
	});
	

	jQuery('#close_window').unbind("click").click(function(){

		if (!confirm('你真的要注销此账号吗？')) return false;

		window.opener = null;
		window.open('login.html', '_self');

	});	
	jQuery('#shou_cang').unbind("click").click(function(){
		var cObject=this;
		var url="/html/nds/portal/collect.jsp?id=1&&onlyfa='Y'";
		jQuery.ajax({
			type: "get",  
			url: url,  
			cache: false,  
			error: function (data){ 
				jQuery(cObject).removeAttr("disabled");	
				jQuery(cObject).css({"cursor":"pointer"});
			},  
			//jsonp: "callback",  
			//dataType: "jsonp",  
			success: function (data){
				var result=data.xml;
				if(!result){result=data;}
				jQuery("#content_show_cang").html(result);
				jQuery("#div_shou_cang").show();
				jQuery(cObject).removeAttr("disabled");	
				jQuery(cObject).css({"cursor":"pointer"});
			} 
		});
	});
};
