/**
    Portal IM Client
*/
var im;
var IMClient = Class.create();
IMClient.prototype = {
    initialize: function () {
        this._msgs = [];
        this._lastId = 0;
    },
    dlgok: function (idx) {

        //$("mi"+ idx).removeClassName("unread");		

        jQuery(document.getElementById("cmdmsg")).css("display", "none");

        var obj = this._msgs[idx];
        if (obj.noteid != null && !isNaN(obj.noteid)) {
            var evt = {};
            evt.command = "U_Note_Read";
            evt["nds.control.ejb.UserTransaction"] = "Y";
            evt.callbackEvent = "U_Note_Read";
            evt.noteid = obj.noteid;
            pc.executeCommandEvent(evt);
        }
    },
    show: function (idx) {
        //obj.msg, obj.user,obj.css, obj.block,obj.url,obj.timestamp
        var obj = this._msgs[idx];
        if (!obj || obj == null) return;

        var msg = "<div id='imbox'>" + "<div class='imu'>" + obj.user.escapeHTML() + ":</div>" + (obj.timestamp ? "<div class='imt'>(" + obj.timestamp + ")</div>" : "") + "<div class='imm " + (obj.css == null ? "" : obj.css) + "'>" + obj.msg.escapeHTML() + "</div>";
        if (obj.url != null) msg += "<div class='imf'><a href='" + obj.url.escapeHTML() + "'>" + gMessageHolder.VIEW_ATTACH + "</a><img class='ima' src='/html/nds/images/cleardot.gif'/></div>";
        if (obj.noteid != null && !isNaN(obj.noteid)) {
            msg += "<div class='imf'><a href='javascript:im.dlgo2(10083," + obj.noteid + ")'>" + gMessageHolder.VIEW_NOTE + "</a></div>";
        }
        msg += "</div>";
        var html = msg + "<div id='cmdbtns'><input type='button' value='&nbsp;&nbsp;" + gMessageHolder.CONFIRM_READ + "&nbsp;&nbsp;' onclick='im.dlgok(" + idx + ")'></div>";

        pc.cmdmsgbox(html);
    },
    /**
    Connect to im server
    */
    dlgo2: function (tableId, objId) {
        showObject2("/html/nds/object/object.jsp?table=" + tableId + "&id=" + objId, pc._dialogOption);
    },
    isIE: function () {
        return window.ActiveXObject ? 1 : 0;
    },
    build: function (id) {
        var container = $(id);
        if (container == null) { return; }
        var length_msg = this.isIE() == 1 ? 37 : 39;
        var sysMessages = this._msgs;
        var idx, obj, len = 0, pcharIndex, start = 0;
        var blockerIdx = -1;
        var htmls = [];
        start = im._start || 0;
        for (idx = start; idx < sysMessages.length; idx++) {
            obj = sysMessages[idx];
            pcharIndex = obj.msg.indexOf("<p");
            if (pcharIndex > length_msg || obj.msg.indexOf("<h") > length_msg) {
                len = length_msg;
            } else if (pcharIndex != -1) {
                len = pcharInd,ex;
            } else {
                len = obj.msg.length;
            }
            htmls.push("<li class='syslist-item'><a class='imm " + (obj.css == null ? "" : obj.css) + " syslist-summary' id='mi" + (idx) + "' href='javascript:im.show(" + (idx) + ")'>" + obj.msg.substring(0, obj.msg.length) + "</a></li>");
        }
        if (htmls.length % 2 != 0) {
            htmls.push("<li class='syslist-item'><a class='imm'>&nbsp;</a></li>");
        }
        im._start = sysMessages.length;
        container.innerHTML = htmls.join('\n');
    },
    check: function () {
        new Ajax.Request("/servlets/binserv/Messages?lastid=" + im._lastId, {
            method: 'get',
            onSuccess: function (transport) {
                var sysMessages = transport.responseText.evalJSON();
                if (sysMessages == null || sysMessages.length == 0) return;
                var oldIdx = im._msgs.length;
                var oldLastId = im._lastId;
                im._msgs = im._msgs.concat(sysMessages);
                if (im._msgs.length > 0 && im._msgs[im._msgs.length - 1].id > im._lastId) im._lastId = im._msgs[im._msgs.length - 1].id;
                else if (im._lastId == 0) im._lastId = 1;//0 will force db reload
                if (obj.block) blockerIdx = oldIdx + sysMessages.length;
                im.build('sysMessageList');
                if (oldLastId != 0 && blockerIdx != -1) im.show(blockerIdx);
            },
            onFailure: function (transport) {

            }
        });
    }
};
jQuery(document).ready(function () {
    im = new IMClient();
    im.check();
    //setInterval('im.check()',60000);
});