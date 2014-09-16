//初始化右侧菜单 绑定Menu 点击弹出右侧菜单
    $(function () {
        var $shadow = $(".slideshadow");
        $shadow.width = innerWidth;
        $shadow.css("height", $(document).height() + "px");
        $(".dpd-posT").css("height", window.innerHeight + "px");
        $(".menuBtn").click(function () {
            $shadow.css("height", $(document).height() + "px");
            var menu = $(".dpd-posT");
            if (menu.css("right") == "-200px") {
                menu.show();
                setTimeout(function () { menu.css("right", "60px"); }, 50);
                $shadow.show();
            } else {
                menu.css("right", "-200px");
                setTimeout(function () { menu.hide(); }, 300);
                $shadow.hide();

            }
        });

        $(".dpd-posT").click(function () {
            $shadow.css("height", $(document).height() + "px");
            $(".dpd-posT").css("right", "-200px");
            setTimeout(function () { $(".dpd-posT").hide(); }, 300);
            $shadow.hide();
        });

        $shadow.click(function () {
            $shadow.css("height", $(document).height() + "px");
            $(".dpd-posT").css("right", "-200px");
            setTimeout(function () { $(".dpd-posT").hide(); }, 300);
            $shadow.hide();

        });
    });