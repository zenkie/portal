(function (env) {
    if (env.PortalLogin) {
        return;
    }
    var timer = null;
    var PortalLoginClass = function () { }
    
	env.PortalLogin = new PortalLoginClass();

    //按键登录
    PortalLoginClass.prototype.onKeyupLogin = function (event) {
        if (!event) event = window.event;
        if (event && event.keyCode && event.keyCode == 13) PortalLogin.submit();
    }

    //提交登录
    PortalLoginClass.prototype.submit = function () {
        if (document.getElementById("login").value == "") {
            this.showMessage("请输入会员用户名");
            return;
        } else if (document.getElementById("password1").value == "") {
            this.showMessage("请输入密码");
            return;
        } else if (document.getElementById("verifyCode").value == "") {
            this.showMessage("请输入验证码");
            return;
        } else if (document.getElementById("verifyCode").value.length != 4) {
            this.showMessage("您的输入验证码的长度不对!");
            return;
        }
        this.showMessage('');
        document.fm1.submit();
        document.body.innerHTML = document.getElementById("progress").innerHTML;
    }
    //提示消息
	
    PortalLoginClass.prototype.showMessage = function (message) {
       PortalTheme.Tip.Error(message);
    }
}(window))
