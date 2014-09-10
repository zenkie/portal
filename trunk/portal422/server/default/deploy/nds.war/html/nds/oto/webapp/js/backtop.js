 $(function () {
        $(window).scroll(function () {
            if ($(window).scrollTop() > 100) {
                $("#backtop").fadeIn(1500);
            }
            else {
                $("#backtop").fadeOut(1500);
            }
        });

        $("#backtop").click(function () {
            $('body,html').animate({scrollTop:0},1000);
            return false;
        });
		
		//点击图文 显示详情
		$(".blocktitle").click(function () {           
			var menu = $("#content");
			if (menu.css("display") == "none") {
				menu.show("normal");              
			} else {
				menu.hide("normal");             
			}
		});
		
    });