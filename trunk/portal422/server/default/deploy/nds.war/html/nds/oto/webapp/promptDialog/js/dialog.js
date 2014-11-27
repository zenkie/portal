function showConfirm(b) {
    var a = {
        sureNode: $("#notice-sure"),
        cancelNode: $("#notice-cancel"),
        contentNode: $("#notice-content"),
        dialogNode: $("#message-notice")
    };

    function c() {
        f.sureFn.call(this, arguments), e()
    }
    function d() {
        f.cancelFn.call(this, arguments), e()
    }
    function e() {
        a.contentNode.empty(), a.sureNode.html("确定").off("click", c), a.cancelNode.html("取消").off("click", d), a.dialogNode.addClass("display_none")
    }
    var f = {
        describeText: "",
        sureText: "确定",
        cancelText: "取消",
        showNum: 2,
        sureFn: function () {
            return !0
        },
        cancelFn: function () {
            return !0
        }
    };
    $.extend(f, b), a.dialogNode.hasClass("display_none") && (a.dialogNode.removeClass("display_none"), a.sureNode.on("click", c), a.cancelNode.on("click", d), 1 == f.showNum && a.cancelNode.addClass("display_none"), a.sureNode.html(f.sureText), a.cancelNode.html(f.cancelText), a.contentNode.html(f.describeText))

}

function showBubble(message, speed) {
    if (message) {
        speed = speed || 1000;
        var bubble = $("#bubble");
        bubble.stop().css("opacity", 1), bubble.hasClass("display_none") || bubble.html(message), bubble.html(message).removeClass("display_none"), setTimeout(function () {
            bubble.animate({
                opacity: 0
            }, 1000, "swing", function () {
                $(this).addClass("display_none").removeAttr("style");
            })
        }, speed)
    }
}