function calculate() {
    var buyNumTemp = 1;//存储当前商品数量
    var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量
    if (stockNum <= 0 && Wmp.Detail.isLimitStock) {
        $("#buyNum").val(0);
        buyNumTemp = 0;
    } else {
        $("#stock-num").html(parseNum(--stockNum + ""));
        buyNumTemp = 1;
    }

    bindingEvent($('.minus'), 'click touchstart', function () {//减少商品数量
        var buyNum = parseInt($("#buyNum").val());
        var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量	
        if (buyNum <= 0) return;
        $("#stock-num").html(parseNum(++stockNum + ""));
        $("#buyNum").val(--buyNum);
        buyNumTemp = buyNum;
    });

    bindingEvent($('.plus'), 'click touchstart', function () {//增加商品数量
        var buyNum = parseInt($("#buyNum").val());
        var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));
        if (stockNum <= 0 && Wmp.Detail.isLimitStock) return;
        $("#stock-num").html(parseNum(--stockNum + ""));
        $("#buyNum").val(++buyNum);
        buyNumTemp = buyNum;
    });

    bindingEvent($("#buyNum"), 'click touchstart', function () {
        buyNumTemp = parseInt($("#buyNum").val());
        $("#buyNum").select();
    });

    $("#buyNum").blur(function () {
        var buys = parseInt($("#buyNum").val());
        if (!buys || !/^\d+$/.test(buys)) {
            showBubble("购买数量只能为大于0的整数", 1500);
            $("#buyNum").val(buyNumTemp);
            return;
        }
        var buyNum = buyNumTemp - buys;
        var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, '')) + buyNum;
        if (stockNum < 0 && Wmp.Detail.isLimitStock) {
            $("#buyNum").val(buyNumTemp);
            return;
        }
        $("#stock-num").html(parseNum(stockNum + ""));
    });

    function parseNum(num) {//数字超过3位添加逗号
        var number = num.replace(/(?=(?:\d{3})+(?!\d))/g, ',');
        if (num.length % 3 == 0 && (number.search("-") == -1)) {
            number = number.substring(1);
        } else if (num.length % 4 == 0 && number.search("-") == 0) {
            number = number.substring(2);
        }
        return number;
    }
}

//绑定事件
function bindingEvent(obj, evname, callback) {
    var names = evname.split(' ');
    var eventName;
    $.each(names, function () {
        var name = 'on' + this;
        eventName = (name in document) ? 'touchstart' : 'click';
        if (name === 'ontap') eventName = 'tap';
    });

    obj.on(eventName, function (ev) {
        callback(ev);
        ev.preventDefault();
        ev.stopPropagation();
    });
}

function toPay(select, num) {
    var pdtid = $("#pdtid").val();
    var vipid = $("#vipid").val();
    var spaces = $("#spacesInner").text();
    var _params = "{\"table\":16033,\"WX_VIP_ID\":" + vipid + ",\"WX_APPENDGOODS_ID\":" + pdtid + ",\"QTY\":" + num + ",\"SPEC\":\"" + spaces + "\"}";
    $.ajax({
        url: '/html/nds/schema/restajax.jsp',
        type: 'post',
        data: { command: "ObjectCreate", params: _params },
        success: function (data) {
            var _data = eval("(" + data + ")");
            var objID = _data[0].objectid;
            if (_data[0].code == 0) {
                location.href = '/html/nds/oto/webapp/order/index.vml?objectid=' + objID;
            } else {
                showBubble("订单提交失败！");
                setTimeout(function () {
                    location.reload();
                }, 1000)
            }
        }
    });
}

function addCart(select, num) {
    var pdtid = $("#pdtid").val();
    var vipid = $("#vipid").val();
    var spaces = $("#spacesInner").text();
    var _params = "{\"table\":16004,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":" + vipid + ",\"WX_APPENDGOODS_ID__ITEMNAME\":" + pdtid + ",\"QTY\":" + num + ",\"SPEC\":\"" + spaces + "\"}";
    $.ajax({
        url: '/html/nds/schema/restajax.jsp',
        type: 'post',
        data: { command: "ObjectCreate", params: _params },
        success: function (data) {
            var _data = eval("(" + data + ")");
            if (_data[0].code == 0) {
                showConfirm({
                    describeText: "添加成功！",
                    sureText: "去购物车结算",
                    cancelText: "再逛逛",
                    sureFn: function () {
                        location.href = '/html/nds/oto/webapp/cart/index.vml'
                    }
                });
            } else {
                showConfirm({
                    describeText: "加入购物车失败，请稍候再试",
                    sureText: "重试",
                    cancelText: "取消",
                    sureFn: function () {
                        addCart()
                    }
                });
            }
        },
    });
}

function initspaces() {
    var objid = $("input[type=hidden][id=pdtid]").val();
    $.ajax({
        url: '/html/nds/oto/webapp/product/getAliasJson.jsp?id=' + objid,
        type: 'post',
        async: false,
        success: function (data) {
            initAlias(data);
        },
        error: function (data) {

        }
    });
}

function initAlias(spaces) {
    if (spaces.trim() == "") return;
    try { obj = JSON.parse(spaces); }
    catch (e) { obj = null; }
    product = [];
    properties = [];
    regexskus = [];
    spaceprice = {};
    var sps = "";
    if (obj && obj.child) {
        var tempspace;
        var tempspaces;
        var spacehtml = [];
        var selectspace = {};
        var dk = [];
        var isInit = false;
        for (var i = 0; i < obj.child.length; i++) {
            jo = obj.child[i];
            if (jo.isdefault == "Y") {
                $("#spacesInner").html(jo.aliascode);
                continue;
            }
            if (jo.putaway == 'N' || jo.putaway == 'n') { continue; }
            tempspaces = jo.space;
            if (tempspaces) {
                dk.push(tempspaces);
                var productStr = "";
                var spanid;
                if (obj.child.length == 1) { $("#spacesInner").html(jo.aliascode); }
                for (var j = 0; j < tempspaces.length; j++) {
                    tempspace = tempspaces[j];
                    if (productStr) { productStr += "_"; }
                    productStr += tempspace.id;
                    if (!isInit) {
                        regexskus.push("\\d+");
                        properties.push({ pid: tempspace.pid, ids: [] });
                        spacehtml[j] = "<dt value=\"" + tempspace.pid + "\">" + obj.keys[j].name + ":</dt><dd index=\"" + j + "\" value=\"" + tempspace.pid + "\">";
                    }
                    if (!selectspace.hasOwnProperty(tempspace.pid)) { selectspace[tempspace.pid] = {}; }
                    if (!selectspace[tempspace.pid].hasOwnProperty(tempspace.id)) {
                        selectspace[tempspace.pid][tempspace.id] = { pid: tempspace.pid, id: tempspace.id, name: tempspace.name, value: tempspace.value };

                        spanid = tempspace.pid + "-" + tempspace.id;

                        if (obj.child.length == 1) {
                            spacehtml[j] += "<span index=\"" + j + "\" skuname=\"" + jo.sku + "\" spanid=\"" + spanid + "\" tpid=\"" + tempspace.pid + "\" tid=\"" + tempspace.id + "\"  data-value=\"item_" + tempspace.pid + "_" + tempspace.id + "\" value=\"" + tempspace.value + "\" class=\"options selected\">" + tempspace.name + "</span>";
                        } else {
                            spacehtml[j] += "<span index=\"" + j + "\" skuname=\"" + jo.sku + "\" spanid=\"" + spanid + "\" tpid=\"" + tempspace.pid + "\" tid=\"" + tempspace.id + "\"  data-value=\"item_" + tempspace.pid + "_" + tempspace.id + "\" value=\"" + tempspace.value + "\" class=\"options\">" + tempspace.name + "</span>";
                        }
                        properties[j].ids.push(tempspace.id);
                    }
                }
                isInit = true;
                product.push(productStr);
                try { spaceprice[productStr] = parseFloat(jo.sellprice).toFixed(2); }
                catch (e) { spaceprice[productStr] = jo.sellprice; }
            }
        }
        var spacehtmls = spacehtml.join("</dd>") + "</dd>";
        $("#spacesdisplay").html(spacehtmls);
		//没有上架的商品 总库存 不计算在内
		if(product.length!=0){
			var priceSum =0;
			for(var i = 0;i<product.length;i++){
				var key = product[i];priceSum = priceSum + spacepqy[key];
			};
			$("#stock-num").html(priceSum);
			productqty = priceSum;	
		}		
		//没有上架的商品 总库存 不计算在内 结束
    }
}

function sliderimg() {
    $(".main_visual").hover(function () {
        $("#btn_prev,#btn_next").fadeIn()
    }, function () {
        $("#btn_prev,#btn_next").fadeOut()
    });
    $dragBln = false;
    $(".main_image").touchSlider({
        flexible: true,
        speed: 200,
        btn_prev: $("#btn_prev"),
        btn_next: $("#btn_next"),
        paging: $(".flicking_con a"),
        counter: function (e) {
            $(".flicking_con a").removeClass("on").eq(e.current - 1).addClass("on");
        }
    });

    $(".main_image").bind("mousedown", function () {
        $dragBln = false;
    });

    $(".main_image").bind("dragstart", function () {
        $dragBln = true;
    });

    $(".main_image a").click(function () {
        if ($dragBln) {
            return false;
        }
    });

    timer = setInterval(function () {
        $("#btn_next").click();
    }, 5000);

    $(".main_visual").hover(function () {
        clearInterval(timer);
    }, function () {
        timer = setInterval(function () {
            $("#btn_next").click();
        }, 5000);
    });

    $(".main_image").bind("touchstart", function () {
        clearInterval(timer);
    }).bind("touchend", function () {
        timer = setInterval(function () {
            $("#btn_next").click();
        }, 5000);
    });
}
function goTopEx() {
    var obj = document.getElementById("top_btn");
    function getScrollTop() {
        return document.documentElement.scrollTop + document.body.scrollTop;
    }
    function setScrollTop(value) {
        if (document.documentElement.scrollTop) {
            document.documentElement.scrollTop = value;
        } else {
            document.body.scrollTop = value;
        }
    }
    window.onscroll = function () {
        getScrollTop() > 300 ? obj.style.display = "block" : obj.style.display = "";
    }
    obj.onclick = function () {
        var goTop = setInterval(scrollMove, 10);
        function scrollMove() {
            setScrollTop(getScrollTop() / 1.1);
            if (getScrollTop() < 1) clearInterval(goTop);
        }
    }
}
(function (ev) {
    if (ev.TouchUtil) { return; }

    var util = ev.TouchUtil = {};

    function touch() { }
    touch.prototype.Call = function (handle) {
        var paras = [];
        paras.push.apply(paras, arguments);
        paras.shift();
        if (typeof handle == 'function') {
            return handle.apply(this, paras);
        }
    }
    touch.prototype.Directions = { none: 0, left: 1, right: 2, top: 3, bottom: 4 };
    touch.prototype.TouchParams = { OriX: 0, OriY: 0, EndX: 0, EndY: 0, Direction: '', osY: 0, osX: 0, esY: 0, esX: 0 };
    touch.prototype.TouchStart = function (ev) {
        var _params = this.TouchParams;
        ev = this.GetTouchEvent(ev);
        _params.OriX = ev._X;
        _params.OriY = ev._Y;
        _params.osY = document.body.scrollTop || document.documentElement.scrollTop;
        _params.osX = document.body.scrollLeft || document.documentElement.scrollLeft
        this.Call(this.OnTouchStart, _params, ev);
    }
    touch.prototype.TouchEnd = function (ev) {
        var _params = this.TouchParams;
        ev = this.GetTouchEvent(ev);
        _params.EndX = ev._X;
        _params.EndY = ev._Y;
        _params.esY = document.body.scrollTop || document.documentElement.scrollTop;
        _params.esX = document.body.scrollLeft || document.documentElement.scrollLeft
        var direction = this.GetTouchDirection();
        var directions = this.Directions;
        switch (direction) {
            case directions.left:
            case directions.right:
                this.Call(this.OnHorizontalTouchEnd, _params);
                break;
            default:
                break;
        }
        this.Call(this.OnTouchEnd, _params, ev);
    }
    touch.prototype.GetTouchDirection = function () {
        var _params = this.TouchParams;
        var diffX = _params.EndX - _params.OriX;
        var diffY = _params.EndY - _params.OriY;
        var diffsX = _params.osX - _params.esX;
        var diffsY = _params.osY - _params.esY;
        var directions = this.Directions;
        if (Math.abs(diffX) < 2 && Math.abs(diffY) < 2) {
            _params.Direction = directions.none;
        } else {
            var maybeHorize = Math.abs(diffsY) < 1;
            var angle = Math.atan2(diffY, diffX) * 180 / Math.PI;
            var absAngel = Math.abs(angle);
            if (absAngel < 10 && maybeHorize) {
                _params.Direction = directions.right;
            } else if (angle >= 10 && angle <= 170) {
                _params.Direction = directions.top;
            } else if ((absAngel > 170 && absAngel <= 180) && maybeHorize) {
                _params.Direction = directions.left;
            } else {
                _params.Direction = directions.bottom;
            }
        }
        return _params.Direction;
    }
    touch.prototype.GetTouchEvent = function (e) {
        if (e.type == "dragestart" || (e.type == "touchstart" && e.originalEvent.touches.length <= 1)) {
            e._X = e.pageX || e.originalEvent.touches[0].pageX;
            e._Y = e.pageY || e.originalEvent.touches[0].pageY;
        } else if (e.type == "dragend" || (e.type == "touchend" && e.originalEvent.changedTouches.length <= 1)) {
            e._X = e.pageX || e.originalEvent.changedTouches[0].pageX;
            e._Y = e.pageY || e.originalEvent.changedTouches[0].pageY;
        }
        return e;
    }
    touch.prototype.OnTouchStart = function (ev) { }
    touch.prototype.OnTouchEnd = function (ev) { }
    touch.prototype.OnHorizontalTouchEnd = function () { }

    util.touch = function (selector) {
        var container = $(selector);
        var toucher = new touch();
        container.bind('touchstart', function (ev) { toucher.Call(toucher.TouchStart, ev); });
        container.bind('touchend', function (ev) { toucher.Call(toucher.TouchEnd, ev) });
        return toucher;
    }

}(window));

function showcontent() {
    var tag = document.getElementById("details_tag").childNodes;
	var content=document.getElementById("details_content").childNodes;
	var len= tag.length;
	for(var i=0; i<len; i++)
	{
		tag[i].index=i;
		tag[i].onclick = function(){
			for(var n=0; n<len; n++){
				  tag[n].className="";
				  content[n].className="this_none"; 
			}
			tag[this.index].className = "on";
			content[this.index].className = "this_show";
		}
	}
}
$(function () { showcontent(); });