var box=null;
var BOX=Class.create();
BOX.prototype={
    initialize:function(){
        this.boxItem="";
        this.returnData=null;
        this.addr=null;
        //dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        dwr.util.setEscapeHtml(false);
        /** A function to call if something fails. */
        dwr.engine._errorHandler =  function(message, ex) {
            while(ex!=null && ex.cause!=null) ex=ex.cause;
            if(ex!=null)message=ex.message;// dwr.engine._debug("Error: " + ex.name + "," + ex.message+","+ ex.cause.message, true);
            if (message == null || message == "") alert("A server error has occured. More information may be available in the console.");
            else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
            else alert(message);
        };
        application.addEventListener("DO_LOAD",this._onLoadBox,this);
        application.addEventListener("DO_SAVE",this._onSave,this);
        application.addEventListener( "PrintJasper", this._onPrintJasper, this);
        application.addEventListener( "SavePrintSetting", this._onSavePrintSetting, this);
        application.addEventListener( "SavePrintSettingForSingleBox", this._onSavePrintSettingForSingleBox, this);
    },
    loadBox:function(){
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="DO_LOAD";
        var m_box_id=$("m_box_id").value;
        var param={"m_box_id":m_box_id};
        evt.param=Object.toJSON(param);
        evt.table="m_box";
        evt.action="pick";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    doSaveSettings:function(tem){
        var evt={};
        evt.command="SavePrintSetting";
        evt.callbackEvent="SavePrintSetting";
        evt.tableid= "14928";
        evt.template=tem;
        evt.format="pdf";
        this._executeCommandEvent(evt);
    },
    savePrintSettingForSingleBox:function(tem){
        var evt={};
        evt.command="SavePrintSetting";
        evt.callbackEvent="SavePrintSettingForSingleBox";
        evt.tableid= "14935";
        evt.template=tem;
        evt.format="pdf";
        this._executeCommandEvent(evt);
    },
    _onSavePrintSetting:function(e){
        this.doPrint();
    },
    _onSavePrintSettingForSingleBox:function(e){
        this.getBoxNoId();
    },
    doPrint:function(){
        var evt={};
        evt.tag="Print";
        evt.command="PrintJasper";
        var m_box_id=$("m_box_id").value;
        evt.callbackEvent="PrintJasper";
        evt.params={"table":14928,"id":m_box_id};
        this._executeCommandEvent(evt);
    },
    del:function(){
        if($("status").value.strip()=="2"){
            alert("单据已提交，不可操作！");
            return;
        }
        var es= jQuery("#showContent>div:visible table:visible tr:visible :checkbox:checked");
        var len=es.length;
        if(len>0){
            $("isSaved").value="unSave";
            for(var i=0;i<len;i++){
                jQuery(jQuery(es[i]).parent("td").siblings(":last")).children("div").html("");
                jQuery(jQuery(es[i]).parents("tr")[0]).css("display","none");
            }
        }else{
            alert("请选择明细！");
        }
        this.countBox();
        this.countTot();
    },
    _onLoadBox:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        this.returnData=ret;                                 
        if(ret.data=="null"){
            alert("没有数据！");
            return;
        }
        $("docon").value=ret.M_BOX_HD.DOCON;
        $("tableType").value=ret.M_BOX_HD.TABLETYPE;
        $("status").value=ret.M_BOX_HD.STATUS;
        $("desc").value=ret.M_BOX_HD.desc||"";
        if(ret.M_BOX_HD.STATUS==2){
            $("submitImge").style.display="";
        }
        if(!$("customer")||$("customer").value!="jz"){
            var ops=$("boxRule").options;
            for(var i=0;i<ops.length;i++){
                if(ops[i].value==ret.M_BOX_HD.BOXRULE){
                    ops[i].selected = true;
                }
            }
            var adds=ret.ADDRESS;
            this.addr=adds;
            if(this.checkIsArray(adds)){
                $("address").value=adds[0];
            }else{
                $("address").value=adds;
            }
        }
        var manuS="<input type=\"hidden\" id=\"selCategory\" value=\"\"/>";
        var manuBox="<input type =\"hidden\" id=\"selBox\" value=\"1\"/>";
        var itemS="";
        var destination=ret.DESTINATION;
        if(this.checkIsArray(destination)){
            for(var j=0;j<destination.length;j++){
                manuS+="<li id=\""+destination[j]+"M\" style=\"cursor:pointer;width:110px;\" onclick=\"box.selCategorySty(event,'"+destination[j]+"',"+j+")\" ><span id=\""+destination[j]+"eq\"><img name='uneq' src=\"images/inco-uneq.gif\"  width=\"16\" height=\"16\"/></span>"+destination[j]+"</li>";
                manuBox+="<ul id=\""+destination[j]+"Num\">"
                if(!ret.M_BOX_LOAD){
                    manuBox+="<li id=\""+destination[j]+"_1\" style=\"cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination[j]+"');this.style.backgroundColor='#ddd';\">1</li>";
                }else{
                    var boxNoes=new Array();
                    if(this.checkIsArray(ret.M_BOX_LOAD.m_product_no)){
                        var pdtNo=ret.M_BOX_LOAD.m_product_no;
                        for(var u=0;u<pdtNo.length;u++){
                            if(ret.M_BOX_LOAD.categorymark[u]==destination[j]){
                                boxNoes.push(ret.M_BOX_LOAD.BOXNO[u]);
                            }
                        }
                    }else{
                        if(ret.M_BOX_LOAD.categorymark==destination[j]){
                            boxNoes.push(ret.M_BOX_LOAD.BOXNO);
                        }
                    }
                    boxNoes=ztools.mergeArr(boxNoes);
                    for(var nk=0;nk<boxNoes.length;nk++){
                        manuBox+="<li id=\""+destination[j]+"_"+boxNoes[nk]+"\" style=\"cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination[j]+"');this.style.backgroundColor='#ddd';\">"+boxNoes[nk]+"</li>";
                    }
                }
                manuBox+="<li id=\""+destination[j]+"\" style=\"display:none;cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination[j]+"');this.style.backgroundColor='#ddd';\"></li>"+
                         "</ul>";
                itemS+="<div class=\"zh-from-left02\" id=\""+destination[j]+"TableDiv\" style=\"overflow-y:auto;overflow-x:hidden;height:282px;\"><input type=\"hidden\"/>"+
                       "<table id=\""+destination[j]+"Table\" width=\"99%\" style=\"table-layout:fixed;display:none;\" border=\"1\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#8db6d9\" bordercolorlight=\"#FFFFFF\" bordercolordark=\"#FFFFFF\" bgcolor=\"#8db6d9\" class=\"modify_table\">"+
                       "<col width=\"40\">"+
                       "<col width=\"142\">"+
                       "<col width=\"142\">"+
                       "<col width=\"130\">"+
                       "<col width=\"130\">"+
                       "<col width=\"auto\">";
                var count=0;
                for(var s=0;s<ret.data.length;s++){
                    if(ret.data[s].m_box_item.DESTINATION==destination[j]){
                        count++;
                        itemS+="<tr height=\"29\" style=\"display:none;\">"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><input type='checkbox'></td>"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[s].m_box_item.NAME+"</div></td>"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[s].m_box_item.VALUE+"</div></td>"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[s].m_box_item.VALUE1_CODE+"</div></td>"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[s].m_box_item.VALUE2_CODE+"</div></td>"+
                               "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\" id=\""+destination[j]+ret.data[s].m_box_item.NO+"\" title=\""+ret.data[s].m_box_item.QTY+"\" name='scan'></div></td></tr>";
                    }
                }
                itemS+="</tbody></table></div>";
            }
        }else{
            manuS+="<li id=\""+destination+"M\" style=\"cursor:pointer;width:110px;\" onclick=\"box.selCategorySty(event,'"+destination+"')\" ><span id=\""+destination+"eq\"><img name='uneq' src=\"images/inco-uneq.gif\"  width=\"16\" height=\"16\"/></span>"+destination+"</li>";
            manuBox+="<ul id=\""+destination+"Num\">"
            if(!ret.M_BOX_LOAD){
                manuBox+="<li id=\""+destination+"_1\" style=\"cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination+"');this.style.backgroundColor='#ddd';\">1</li>";
            }else{
                var boxNoes=new Array();
                if(this.checkIsArray(ret.M_BOX_LOAD.m_product_no)){
                    var pdtNo=ret.M_BOX_LOAD.m_product_no;
                    for(var u=0;u<pdtNo.length;u++){
                        if(ret.M_BOX_LOAD.categorymark[u]==destination){
                            boxNoes.push(ret.M_BOX_LOAD.BOXNO[u]);
                        }
                    }
                }else{
                    if(ret.M_BOX_LOAD.categorymark==destination){
                        boxNoes.push(ret.M_BOX_LOAD.BOXNO);
                    }
                }
                boxNoes=ztools.mergeArr(boxNoes);
                for(var nk=0;nk<boxNoes.length;nk++){
                    manuBox+="<li id=\""+destination+"_"+boxNoes[nk]+"\" style=\"cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination+"');this.style.backgroundColor='#ddd';\">"+boxNoes[nk]+"</li>";
                }
            }
            manuBox+="<li id=\""+destination+"\" style=\"display:none;cursor:pointer;width:75px;\" onclick=\"box.selSty(event,'"+destination+"');this.style.backgroundColor='#ddd';\"></li>"+
                     "</ul>";
            itemS+="<div class=\"zh-from-left02\" id=\""+destination+"TableDiv\" style=\"overflow-y:auto;overflow-x:hidden;height:282px;\"><input type=\"hidden\"/>"+
                   "<table id=\""+destination+"Table\" width=\"99%\" style=\"table-layout:fixed;display:none;\" border=\"1\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#8db6d9\" bordercolorlight=\"#FFFFFF\" bordercolordark=\"#FFFFFF\" bgcolor=\"#8db6d9\" class=\"modify_table\">"+
                   "<col width=\"40\">"+
                   "<col width=\"142\">"+
                   "<col width=\"142\">"+
                   "<col width=\"130\">"+
                   "<col width=\"130\">"+
                   "<col width=\"auto\">";

            if(this.checkIsArray(ret.data)){
                for(var h=0;h<ret.data.length;h++){
                    itemS+="<tr height=\"29\" style=\"display:none;\">"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><input type='checkbox'></td>"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[h].m_box_item.NAME+"</div></td>"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[h].m_box_item.VALUE+"</div></td>"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[h].m_box_item.VALUE1_CODE+"</div></td>"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data[h].m_box_item.VALUE2_CODE+"</div></td>"+
                           "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\" id=\""+destination+ret.data[h].m_box_item.NO+"\" title=\""+ret.data[h].m_box_item.QTY+"\" name='scan'></div></td></tr>";
                }
            }else{
                itemS+="<tr height=\"29\" style=\"display:none;\">"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><input type='checkbox'></td>"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data.m_box_item.NAME+"</div></td>"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data.m_box_item.VALUE+"</div></td>"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data.m_box_item.VALUE1_CODE+"</div></td>"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+ret.data.m_box_item.VALUE2_CODE+"</div></td>"+
                       "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\" id=\""+destination+ret.data.m_box_item.NO+"\" title=\""+ret.data.m_box_item.QTY+"\" name='scan'></div></td></tr>";
            }
            itemS+="</table></div>";
        }
        $("destination").innerHTML=manuS;
        $("zh-xh").innerHTML=manuBox;
        $("showContent").innerHTML=itemS;
        if(this.checkIsArray(destination)){
            $("selCategory").value=destination[0];
            for(var o=0;o<destination.length;o++){
                if(!ret.M_BOX_LOAD){
                    this.cloneT(destination[o]+"Table",1);
                }else{
                    var tableState=false;
                    if(this.checkIsArray(ret.M_BOX_LOAD.m_product_no)){
                        var pdtNo=ret.M_BOX_LOAD.m_product_no;
                        for(var g=0;g<pdtNo.length;g++){
                            if(ret.M_BOX_LOAD.categorymark[g]==destination[o]){
                                this.cloneT(destination[o]+"Table",ret.M_BOX_LOAD.BOXNO[g]);
                                $(destination[o]+ret.M_BOX_LOAD.m_product_no[g]+"_"+ret.M_BOX_LOAD.BOXNO[g]).innerHTML=ret.M_BOX_LOAD.QTYOUT[g];
                                $(destination[o]+ret.M_BOX_LOAD.m_product_no[g]+"_"+ret.M_BOX_LOAD.BOXNO[g]).parentNode.parentNode.style.display="";
                                tableState=true;
                            }
                        }
                    }else{
                        if(ret.M_BOX_LOAD.categorymark==destination[o]){
                            this.cloneT(destination[o]+"Table",ret.M_BOX_LOAD.BOXNO);
                            $(destination[o]+ret.M_BOX_LOAD.m_product_no+"_"+ret.M_BOX_LOAD.BOXNO).innerHTML=ret.M_BOX_LOAD.QTYOUT;
                            $(destination[o]+ret.M_BOX_LOAD.m_product_no+"_"+ret.M_BOX_LOAD.BOXNO).parentNode.parentNode.style.display="";
                            tableState=true;
                        }
                    }
                    if(!tableState)this.cloneT(destination[o]+"Table",1);
                }
                jQuery("#"+destination[o]+"Num > li")[0].style.backgroundColor="#ddd";
                if(o>0){
                    $(destination[o]+"TableDiv").style.display="none";
                    $(destination[o]+"Num").style.display="none";
                }
                jQuery("#"+destination[o]+"TableDiv > table")[0].style.display="";
            }
        }else{
            $("selCategory").value=destination;
            if(!ret.M_BOX_LOAD){
                this.cloneT(destination+"Table",1);
            }else{
                var tableState=false;
                if(this.checkIsArray(ret.M_BOX_LOAD.m_product_no)){
                    var pdtNo=ret.M_BOX_LOAD.m_product_no;
                    for(var r=0;r<pdtNo.length;r++){
                        if(ret.M_BOX_LOAD.categorymark[r]==destination){
                            this.cloneT(destination+"Table",ret.M_BOX_LOAD.BOXNO[r]);
                            $(destination+ret.M_BOX_LOAD.m_product_no[r]+"_"+ret.M_BOX_LOAD.BOXNO[r]).innerHTML=ret.M_BOX_LOAD.QTYOUT[r];
                            $(destination+ret.M_BOX_LOAD.m_product_no[r]+"_"+ret.M_BOX_LOAD.BOXNO[r]).parentNode.parentNode.style.display="";
                            tableState=true;
                        }
                    }
                }else{
                    if(ret.M_BOX_LOAD.categorymark==destination){
                        this.cloneT(destination+"Table",ret.M_BOX_LOAD.BOXNO);
                        $(destination+ret.M_BOX_LOAD.m_product_no+"_"+ret.M_BOX_LOAD.BOXNO).innerHTML=ret.M_BOX_LOAD.QTYOUT;
                        $(destination+ret.M_BOX_LOAD.m_product_no+"_"+ret.M_BOX_LOAD.BOXNO).parentNode.parentNode.style.display="";
                        tableState=true;
                    }
                }
                if(!tableState)this.cloneT(destination+"Table",1);
            }
            jQuery("#"+destination+"Num > li")[0].style.backgroundColor="#ddd";
            jQuery("#"+destination+"TableDiv > table")[0].style.display="";
        }
        jQuery("#destination > li")[0].style.backgroundColor="#ddd";
        this.showFirst($("selCategory").value);
        if(ret.M_BOX_HD.STATUS==2){
            jQuery("#barcode").attr("disabled","true");
        }
        $("isSaved").value="save";
        this.codeModel();
        jQuery("#barcode").focus();
        this.countBox();
        this.countTot();
        if(!window.document.addEventListener){
            window.document.attachEvent("onkeydown",hand11);
            function hand11()
            {
                if(window.event.keyCode==13){
                    return false;
                }
            }
        }
    },
    load:function(){
        var w = window.opener;
        if(w==undefined)w= window.parent;
        var e=jQuery(w.document).find("div[class='pop-up-inner']")[0];
        var e1=jQuery(e).find("table[class='pop-up-header']")[0];
        jQuery(e1).find("td").html("");
        jQuery(e1).find("td").html("");
    },
    closePop:function(){
        var isSave=$("isSaved").value.strip();
        var w = window.opener;
        if(w==undefined)w= window.parent;
        if(isSave!="save"){
            if(confirm("数据已变动，您还没有保存！确定结束装箱？")){
                if (w){
                    var iframe=w.document.getElementById("popup-iframe-0");
                    if(iframe){
                        w.setTimeout("Alerts.killAlert(document.getElementById('popup-iframe-0'));",1);
                        return true;
                    }
                }
                return false;
            }
        }else{
            if (w){
                var iframe=w.document.getElementById("popup-iframe-0");
                if(iframe){
                    w.setTimeout("Alerts.killAlert(document.getElementById('popup-iframe-0'));",1);
                    return true;
                }
            }
            return false;
        }
    },
    printBox:function(boxNoId){
        var evt={};
        evt.tag="Print";
        evt.command="PrintJasper";
        evt.callbackEvent="PrintJasper";
        evt.params={"table":14935,"id":boxNoId};
        this._executeCommandEvent(evt);
    },
    getBoxNoId:function(){
        jQuery.get("getBoxNoId.jsp",{"boxno":$("selBox").value,"boxid":$("m_box_id").value},function(data){
            box.printBox(data.strip());
        });
    },
    waitOneMomentToPrint:function(){
        if($('disabledZone'))$('disabledZone').style.visibility = 'hidden';
        window.print_iframe.focus();
        window.print_iframe.print();
        if(oc._closeWindow) {
            alert(gMessageHolder.CLOSE_AFTER_PRINT);
            oc._closeWindowOrShowMessage(null);
        }
    },
    _onPrintJasper:function(e){
        var pf;
        if(typeof(e)=="string") pf=e;
        else
            pf=e.getUserData().printfile;
        var f="/servlets/binserv/GetFile?filename="+encodeURIComponent(pf)+"&del=Y";
        var ifm=window.print_iframe;
        var disabledZone=$('disabledZone');
        if(disabledZone)disabledZone.style.visibility = 'visible';
        if(Prototype.Browser.IE){
            if(disabledZone)disabledZone.style.visibility = 'hidden';
            if(oc._closeWindow){
                window.location.href=f;
            }else{
                popup_window(f);
            }
        }else{
            $("print_iframe").onload=function () {
                setTimeout('box.waitOneMomentToPrint()', 1000);
            };
            ifm.location.href= f;
        }
    },
    cloneT:function(categoryTable,index){
        dwr.util.cloneNode(categoryTable,{idSuffix:"_"+index});
        $(categoryTable+"_"+index).style.display="none";
        $("selBox").value=index;
    },
    selCategorySty:function(event,category,count){
        $("selCategory").value=category;
        var uls=jQuery("#zh-xh > ul");
        var divs=jQuery("#showContent > div");
        for(var i=0;i<uls.length;i++){
            uls[i].style.display="none";
        }
        for(var j=0;j<divs.length;j++){
            divs[j].style.display="none";
        }
        var lies=jQuery("#destination > li");
        var lies1=jQuery("#"+category+"Num > li");
        for(var ss=0;ss<lies.length;ss++){
            if(lies[ss].style.backgroundColor!=""){
                lies[ss].style.backgroundColor="";
                lies[ss].firstChild.firstChild.style.backgroundColor="";
                for(var ui=0;ui<lies1.length;ui++){
                    if(lies1[ui].style.backgroundColor!=""){
                        $("selBox").value=lies1[ui].innerHTML.strip();
                    }
                }
            }
        }
        Event.element(event).style.backgroundColor="#ddd";
        $(category+"TableDiv").style.display="";
        $(category+"Num").style.display="";
        if(count>=0){
            $("address").value=this.addr[count];
        }
    },
    addBox:function(category){
        if($("status").value.strip()=="2"){
            alert("单据已提交，不可操作！");
            return;
        }
        this.add(category);
    },
    add:function(category){
        var lies=jQuery("#"+category+"Num > li");
        var addBoxCount=parseInt(lies[lies.length-2].innerHTML)+1;
        dwr.util.cloneNode(category,{idSuffix:"_"+addBoxCount});
        $(category+"_"+addBoxCount).style.display="";
        $(category+"_"+addBoxCount).innerHTML=addBoxCount;
        dwr.util.cloneNode(category+"Table",{idSuffix:"_"+addBoxCount});
        $("isSaved").value="unSave";
    },
    delBox:function(category){
        this.dele(category);
        this.countBox();
        this.countTot();
    },
    dele:function(category){
        if(!$(category+"_"+$("selBox").value)){
            alert("请选择箱号！");
            return;
        }
        if(confirm("确认删除"+$("selBox").value+"号箱?")){
            if(jQuery("#"+category+"Num > li").length>2){
                $(category+"_"+$("selBox").value).remove();
                $(category+"Table"+"_"+$("selBox").value).remove();
            }else{
                alert("最后一箱不可删除！");
            }
            this.showFirst(category);
        }
        $("isSaved").value="unSave";
    },
    showFirst:function(category){
        var lies=jQuery("#"+category+"Num > li");
        for(var i=0;i<lies.length ;i++){
            lies[i].style.backgroundColor="";
        }
        lies[0].style.backgroundColor="#ddd";
        $("selBox").value=lies[0].innerHTML.strip();
        var tabs=jQuery("#"+category+"TableDiv > table");
        for(var i=0;i<tabs.length;i++){
            tabs[i].style.display="none";
        }
        $(category+"Table"+"_"+$("selBox").value).style.display="";
    },
    selSty:function(event,category){
        this.select(event,category);
    },
    select:function(event,category){
        var lies=$(category+"Num").getElementsByTagName("li");
        for(var i=0;i<lies.length ;i++){
            lies[i].style.backgroundColor="";
        }
        $("selBox").value=(window.event?Event.element(window.event).innerHTML:Event.element(event).innerHTML).strip();
        var tabs=jQuery("#"+category+"TableDiv > table");
        for(var i=0;i<tabs.length;i++){
            tabs[i].style.display="none";
        }
        $(category+"Table"+"_"+(window.event?Event.element(window.event).innerHTML:Event.element(event).innerHTML).strip()).style.display="";
        this.countBox();
        this.countTot();
    },
    countBox:function(){
        var count=0;
       jQuery("#showContent>div:visible>table:visible tr:visible>td>div[name='scan']").each(function(){
           if(this.innerHTML!=""){
               var cou=parseInt(this.innerHTML);
               cou=isNaN(cou)?0:cou;
               count=count+cou;
           }
       });
       jQuery("#currentBox").text(count);
    },
    countTot:function(){
        var count=0;
       jQuery("#showContent>div:visible>table tr:visible>td>div[name='scan']").each(function(){
           if(this.innerHTML!=""){
               var cou=parseInt(this.innerHTML);
               cou=isNaN(cou)?0:cou;
               count=count+cou;
           }
       });
       jQuery("#totBox").text(count);
    },
    pdtModel:function(){
        jQuery("#barcode").unbind("keydown");
        jQuery("#barcode").bind("keydown",function(event){cstable.handlerMe(event)});
        jQuery("#barcode").bind("keyup",function(e){tooltips.inputHandler(e);});
        jQuery("#barcode").bind("focus",function(e){tooltips.focusHandler(e)});
        jQuery("#forCode").bind("mousedown",function(e){tooltips.mousedownHandler()});
        jQuery("#forCode").bind("mouseup",function(e){tooltips.mouseupHandler()});
        jQuery("#barcode").bind("blur",function(e){tooltips.tipHide(e);});
        jQuery("#forCode").bind("mousemove",function(e){tooltips.setKeymode(e);});
    },
    codeModel:function(){
        jQuery("#barcode").unbind("keydown");
        jQuery("#barcode").unbind("keyup");
        jQuery("#barcode").unbind("focus");
        jQuery("#forCode").unbind("mousedown");
        jQuery("#forCode").unbind("mouseup");
        jQuery("#barcode").unbind("blur");
        jQuery("#forCode").unbind("mousemove");
        jQuery("#barcode").bind("keydown",function(event){
            if(event.which==13){
                box.codeRt(event);
            }
        });
    },
    codeRt:function(event){
        if(event.which==13){
            var rows=$($("selCategory").value+"Table_"+$("selBox").value).rows;
            var state=true;
            var isMatch=false;
            for(var i=0;i<rows.length;i++){
                rows[i].style.backgroundColor="";
                if(rows[i].cells[5].firstChild.id.substring(0,rows[i].cells[5].firstChild.id.lastIndexOf("_"))==($("selCategory").value.strip()+Event.element(event).value.strip())){
                    rows[i].style.backgroundColor="#ddd";
                    var old=rows[i].cells[5].firstChild.innerHTML;
                    if($("isRecoil").value=="normal"){
                        rows[i].cells[5].firstChild.innerHTML=isNaN(parseInt(old))?parseInt($("pdt_count").value):(parseInt(old)+parseInt($("pdt_count").value));
                    }else{
                        rows[i].cells[5].firstChild.innerHTML=isNaN(parseInt(old))?-parseInt($("pdt_count").value):(parseInt(old)-parseInt($("pdt_count").value));
                    }
                    if(this.totalBarCode($("selCategory").value,i)>parseInt(rows[i].cells[5].firstChild.title)||this.totalBarCode($("selCategory").value,i)<0){
                        var oldColor=rows[i].cells[5].style.backgroundColor;
                        rows[i].cells[5].style.backgroundColor="#ff0000";
                        alert("产品数量大于订单量或小于0，输入无效！");
                        rows[i].cells[5].firstChild.innerHTML=old;
                        rows[i].cells[5].style.backgroundColor=oldColor;
                    }
                    var f=parseInt(rows[i].cells[5].firstChild.innerHTML,10);
                    f=isNaN(f)?0:f;
                    if(f!=0){
                        rows[i].style.display="";
                    }else{
                        rows[i].style.display="none";
                    }
                    isMatch=true;
                }
                if(this.totalBarCode($("selCategory").value,i)<parseInt(rows[i].cells[5].firstChild.title)){
                    state=false;
                }
            }
            if(state){
                $($("selCategory").value+"eq").innerHTML="<img name='eq' src=\"images/inco-eq.gif\"  width=\"16\" height=\"16\"/>";
            }else{
                $($("selCategory").value+"eq").innerHTML="<img name='uneq' src=\"images/inco-uneq.gif\"  width=\"16\" height=\"16\"/>";
            }
            jQuery("#barcode").val("");
            if(!isMatch){
                if($("sound")){
                    if(!app1){
                        var app1=FABridge.b_playErrorSound.root();
                        app1.setStr($("sound").value.strip()); 
                    }
                    app1.getErrorSound().play();
                }
                alert("没有匹配的商品，请检查条码是否正确！");
            }
            jQuery("#barcode").focus();
            $("isSaved").value="unSave";
            box.countBox();
            box.countTot();
        }
    },
    totalBarCode:function(category,n){
        var lies=jQuery("#"+category+"Num > li");
        var tot=0;
        for(var i=0;i<lies.length-1;i++){
            var count=$(category+"Table_"+lies[i].innerHTML.strip()).rows[n].cells[5].firstChild.innerHTML;
            tot+=isNaN(parseInt(count))?0:parseInt(count);
        }
        return tot;
    },
    toSave:function(finish){
        if($("status").value.strip()=="2"){
            alert("单据已提交，不可操作！");
            return;
        }
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="DO_SAVE";
        var desc=$("desc").value||"-1";
        var m_box_id=$("m_box_id").value;
        var f="N";
        if(finish){
            f=finish;
            var eqImges=jQuery("#destination li span img[name='uneq']");
            if(eqImges.length>0){
                if(!confirm("存在未完全匹配单据，结束装箱？")){
                    return;
                }
            }
        }
        var m_item=new Array();
        var dest=this.returnData.DESTINATION;
        var rData=this.returnData.data;
        if(this.checkIsArray(dest)){
            for(var i=0;i<dest.length;i++){
                var list=jQuery("#"+dest[i]+"Num > li");
                for(var j=0;j<list.length-1;j++){
                    var num=list[j].innerHTML.strip();
                    for(var s=0;s<rData.length;s++){
                        if(rData[s].m_box_item.DESTINATION==dest[i]){
                            if($(dest[i]+rData[s].m_box_item.NO+"_"+num)){
                                if($(dest[i]+rData[s].m_box_item.NO+"_"+num).innerHTML){
                                    var item={};
                                    item.m_box_no=num;
                                    item.qty_ady=$(dest[i]+rData[s].m_box_item.NO+"_"+num).innerHTML.strip();
                                    item.m_product_alias=rData[s].m_box_item.NO;
                                    item.categorymark=dest[i];
                                    m_item.push(item);
                                }
                            }
                        }
                    }
                }
            }
        }else{
            var list1=jQuery("#"+dest+"Num > li");
            for(var j=0;j<list1.length-1;j++){
                var num=list1[j].innerHTML.strip();
                if(this.checkIsArray(rData)){
                    for(var s=0;s<rData.length;s++){
                        if(rData[s].m_box_item.DESTINATION==dest){
                            if($(dest+rData[s].m_box_item.NO+"_"+num)){
                                if($(dest+rData[s].m_box_item.NO+"_"+num).innerHTML){
                                    var item={};
                                    item.m_box_no=num;
                                    item.qty_ady=$(dest+rData[s].m_box_item.NO+"_"+num).innerHTML.strip();
                                    item.m_product_alias=rData[s].m_box_item.NO;
                                    item.categorymark=dest;
                                    m_item.push(item);
                                }
                            }
                        }
                    }
                }else{
                    if(rData.m_box_item.DESTINATION==dest){
                        if($(dest+rData.m_box_item.NO+"_"+num)){
                            if($(dest+rData.m_box_item.NO+"_"+num).innerHTML){
                                var item={};
                                item.m_box_no=num;
                                item.qty_ady=$(dest+rData.m_box_item.NO+"_"+num).innerHTML.strip();
                                item.m_product_alias=rData.m_box_item.NO;
                                item.categorymark=dest;
                                m_item.push(item);
                            }
                        }
                    }
                }
            }
        }
        var param={"m_box_id":m_box_id,"m_item":m_item,"finish":f,"desc":desc};
        evt.param=Object.toJSON(param);
        evt.table="m_box";
        evt.action="save";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    _onSave:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        if(ret.data=="OK"&&!ret.check){
            alert("保存成功！");
            $("isSaved").value="save";
        }else if(ret.data=="OK"&&ret.check=="E"){
            alert("装箱成功！");
            this.closePop();
        }
        else{
            alert("失败！");
        }
    },
    _finish:function(){

    },

    _executeCommandEvent :function (evt) {
        Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
                alert(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
    },
    checkIsObject:function(o){
        return (typeof(o)=="object");
    },

    checkIsArray: function(o){
        return (this.checkIsObject(o) && (o.length) &&(!this.checkIsString(o)));
    },
    checkIsString:function(o){
        return (typeof(o)=="string");
    },
    checkIsNum:function(event){
        if(window.event) var event=window.event;
        if(isNaN(parseInt(Event.element(event).value))){
            alert("请输入正确的数字！");
            Event.element(event).value=0;
            Event.element(event).focus();
        }else{
            Event.element(event).value=parseInt(Event.element(event).value);
        }
    },
    showObject:function(url, theWidth, theHeight,option){
        if( theWidth==undefined || theWidth==null) theWidth=956;
        if( theHeight==undefined|| theHeight==null) theHeight=670;
        var options={width:theWidth,height:theHeight,title:gMessageHolder.IFRAME_TITLE, modal:true,centerMode:"xy",maxButton:true};
        if(option!=undefined)
            Object.extend(options, option);
        Alerts.popupIframe(url,options);
        Alerts.resizeIframe(options);
        Alerts.center();
    },
    tabToArr:function(tab){
        var cellArr=new Array();
        for(var i=0;i<tab.rows.length;i++){
            cellArr[i]=new Array();
            for(var j=0;j<tab.rows[i].cells.length;j++){
                cellArr[i][j]=tab.rows[i].cells[j];
            }
        }
        return cellArr;
    }
}
BOX.main=function(){
    box=new BOX();
};
jQuery(document).ready(BOX.main);

/*TOOLTIPS CLASS*/
var tooltips;
var TOOLTIPS=Class.create();
TOOLTIPS.prototype={
    initialize:function(){
        this.textboxcontent=$("barcode").value;
        this.totaldata=0;
        this.focusshow=true;
        this.mousedown=false;
        this.currentrowid=null;
        this.tipgetrun=false;
        this.keymode=false;
        this.ieclicked=false;
        this.counter=0;
        //jQuery(document).bind("keyup",function(e){tooltips.updnkeyHandler(e);});

    },
    bindevents:function(){
        for(var j=0;j<this.totaldata;j++){
            jQuery("#sn"+j).bind("mouseover",function(e){tooltips.setMouseOver(e)});
            jQuery("#sn"+j).bind("mouseout",function(e){tooltips.removeColors(e)});
            jQuery("#sn"+j).bind("click",function(e){tooltips.setValueOnClick(e)});
        }
        jQuery("#fc_close").bind("click",function(e){tooltips.ieclicked=true;tooltips.focusshow = false;tooltips.tipHideFocus(e);});
    },
    setCaretPosition:function(elemId, caretPos) {
        if(!window.event)return;
        var elem = document.getElementById(elemId);
        if(elem != null) {
            if(elem.createTextRange) {
                var range = elem.createTextRange();
                range.move('character', caretPos);
                range.select();
            }
            else {
                if(elem.selectionStart){
                    elem.focus();
                    elem.setSelectionRange(caretPos, caretPos);
                }
                else
                    elem.focus();
            }
        }
    },
    mouseupHandler:function(e){
        this.mousedown=false;
    },
    mousedownHandler:function(e){
        this.mousedown=true;
    },
    inputHandler:function(e){
        var evt=window.event?window.event:e;
        var key=(window.event)?evt.keyCode:evt.which;
        // $("pdt_count").value=key;
        if((key==38)||(key==40)){this.updnkeyHandler(e);return;}
        if((key==13)||(key==27)){
            // if((key==13)&&(window.event)){window.event.cancelBubble();window.event.returnValue=false;}
            this.focusshow=false;
            this.tipHide();
            return;} //for enter and esc keys hide the tips
        var textchanged=(!(this.textboxcontent==$("barcode").value));
        if(!textchanged)return;
        this.textboxcontent = $("barcode").value;
        this.tipGet();
        this.tipShow();
    },
    sleep:function(millis){
        var date = new Date();
        var curDate = null;
        do { curDate = new Date(); }
        while(curDate-date < millis);
    },

    focusHandler:function(e){
        //this.counter++;$("pdt_count").value = this.counter;   this.sleep(2000);
        if(this.focusshow){
            this.tipShow();
        }else{
            if(window.event){
                if(this.ieclicked){
                    this.ieclicked=false;
                }else{this.focusshow=true; }
            }
            if(!window.event)this.focusshow=true;
        }
        if(window.event) this.setCaretPosition("barcode",$("barcode").value.length);

    },
    tipShow:function(){
        if((jQuery("#forCode").css("display")!="none" )&&(!this.tipgetrun)){this.tipgetrun=false;return;}
        var top = jQuery("#barcode").offset().top;
        var left = jQuery("#barcode").offset().left;
        jQuery("#forCode").css("left",left)
                .css("width","auto")
                .css("top",top-jQuery("#forCode").height()-5)
                .css("height","auto")
                .css("position","absolute")
            //.css("display","block")
                .css("z-index",999);
        if(jQuery("#forCode").css("bottom")>jQuery("#forCode").css("height")){
            jQuery("#forCode").css("top",top+jQuery("#barcode").height() + 5);
        }
        if (this.totaldata>0){jQuery("#forCode").css("display","block");  }
        else{ jQuery("#forCode").css("display","none");}
        this.tipvisible = true;
    },
    getStyleArray:function(){
        var styles=[[],[]];
        var code=$("barcode").value;
        var reg=new RegExp(code,"i");
        if(code.length>0){
            if(box.checkIsArray(box.returnData.data)){
                for(var i=0;i<box.returnData.data.length;i++){
                    if(reg.test(box.returnData.data[i].m_box_item.NAME)&&$("selCategory").value.strip()==box.returnData.data[i].m_box_item.DESTINATION){
                        if(styles[0].indexOf(box.returnData.data[i].m_box_item.NAME)==-1){
                            styles[0].push(box.returnData.data[i].m_box_item.NAME);
                            styles[1].push(box.returnData.data[i].m_box_item.VALUE);
                        }
                    }
                }
            }else{
                if(reg.test(box.returnData.data.m_box_item.NAME)&&$("selCategory").value.strip()==box.returnData.data.m_box_item.DESTINATION){
                    styles[0].push(box.returnData.data.m_box_item.NAME);
                    styles[1].push(box.returnData.data.m_box_item.VALUE);
                }
            }
        }//end of if code length
        return styles;
    },
    tipGet:function(){
        this.tipgetrun=true;
        var totaldata=0;
        var code=$("barcode").value;
        var styles=this.getStyleArray();
        var str="<table id='fc_data'>";
        if(code.length>0){
            for(var i=0; i<styles[0].length;i++){
                totaldata++;
                str+="<tr  id='sn"+(totaldata-1)+"'><td nowrap>"+styles[0][i]+"</td><td nowrap>"+styles[1][i]+"</td></tr>";
            }
        }//end of if code length
        str+="</table>";
        str+="<div align=right><a style='cursor:pointer;color:#0000ff' id='fc_close'>关闭</a></div>";
        $("forCode").innerHTML=str;
        this.totaldata=totaldata;
        this.bindevents();
        return totaldata;
    },
    setValueOnClick:function(e){
        if(window.event)this.ieclicked=true;
        var evt=window.event?window.event:e;
        var target=Event.element(evt);
        target=target.parentNode;
        if(target.tagName=='TR'){
            $("barcode").value = target.cells[0].innerHTML;
            this.textboxcontent=target.cells[0].innerHTML;
        }
        this.focusshow=false;
        this.tipHideFocus();
    },
    setMouseOver:function(e){
        if(this.keymode)return;
        var evt=e?e:Event;
        var target=evt.target?evt.target:evt.srcElement;
        target=target.parentNode;
        jQuery("#"+target.id).css("backgroundColor","#CCCCFF");
        this.currentrowid=target.id;
    },
    removeColors:function(e){
        for (var i=0;i<this.totaldata;i++){
            jQuery("#sn"+i).css("backgroundColor","#FFFFFF");
        }
        this.currentrowid=null;
    },
    tipHide:function(e){
        if(!this.mousedown){jQuery("#forCode").css("display","none");this.keymode=false;}
    },
    tipHideFocus:function(e){
        this.tipHide();
        jQuery("#barcode").focus();
    },
    setKeymode:function(e){
        if((this.currentrowid)&&(this.keymode)){
            jQuery("#"+this.currentrowid).css("backgroundColor","#FFFFFF");
        }
        this.keymode=false;
    },
    updnkeyHandler:function(e){
        var evt=window.event?window.event:e;
        var key=(window.event)?evt.keyCode:evt.which;
        if((key!=38)&&(key!=40)){return;}
        this.tipShow();
        this.keymode=true;
        var totalrows=this.totaldata;
        var targetrowno=null;
        if(this.currentrowid){
            targetrowno=parseInt(this.currentrowid.substring(2));
            targetrowno=(key==38)?(targetrowno-1):(targetrowno+1);
            if(targetrowno>(totalrows-1))targetrowno=null;
            if(targetrowno<0)targetrowno=null;
        } else{
            targetrowno=(key==38)?(targetrowno=(totalrows-1)):(targetrowno=0);
        }
        this.setValueOnKey(targetrowno);
    },
    setValueOnKey:function(targetrowno){
        this.removeColors();
        if(targetrowno!=null){
            $("barcode").value=$("fc_data").rows[targetrowno].cells[0].innerHTML;
            $("sn"+targetrowno).style.backgroundColor = "#CCCCFF";
            this.currentrowid="sn"+targetrowno;
        }else{
            $("barcode").value=this.textboxcontent;
            this.currentrowid=null;
        }
    }
},
        TOOLTIPS.main = function(){ tooltips=new TOOLTIPS(); tooltips.bindevents();},
        jQuery(document).ready(TOOLTIPS.main);

/*CSTABLE CLASS*/
var cstable;
var CSTABLE=Class.create();
CSTABLE.prototype={
    initialize:function(){
        this.currentstyle=null;
        this.styleDetail=[[],[],[],[]];
        this.retData=new Array();
         if(!window.document.addEventListener){
            window.document.attachEvent("onkeydown",hand11);
            function hand11()
            {
                if(window.event.keyCode==13){
                    return false;
                }
            }
        }
    },
    handlerMe:function(e){
        var event=null;
        window.event?event=window.event:event=e;
        var key=null;
        event.keyCode?key=event.keyCode:key=event.which;
        this.currentstyle=$("barcode").value;
        if(key==13){
            if(this.checkValidStyle()){
                $("barcode").blur();
                this.showMask();
                $("pop-up-title-0").innerHTML="款号:<span style='color:red;'>"+this.currentstyle+"</span>  装箱明细！";

            }
        }

    },
    //bindevents:function(){},
    checkValidStyle:function(){
        if(box.checkIsArray(box.returnData.data)){
            for(var i=0;i<box.returnData.data.length;i++){
                if(box.returnData.data[i].m_box_item.NAME==this.currentstyle&&box.returnData.data[i].m_box_item.DESTINATION==$("selCategory").value.strip())return true;
            }
        }else{
            if(box.returnData.data.m_box_item.NAME==this.currentstyle&&box.returnData.data.m_box_item.DESTINATION==$("selCategory").value.strip())return true;
        }
        return false;
    },
    getSingleValueArray:function(source){
        var temp=[];
        for(var i=0;i<source.length;i++){
            if(temp.indexOf(source[i])==-1)temp.push(source[i]);
        }
        return temp;
    },
    showStockTable:function(){
        jQuery("#stock_table").html("");
        this.styleDetail=[[],[],[],[]];
        if(box.checkIsArray(box.returnData.data)){
            var sdata=ztools.sortJSON(box.returnData.data,"m_box_item.VALUE2_CODE",2);
            for(var i=0;i<sdata.length;i++){
                if(sdata[i].m_box_item.NAME==this.currentstyle&&sdata[i].m_box_item.DESTINATION==$("selCategory").value.strip()){
                    this.styleDetail[0].push(sdata[i].m_box_item.VALUE1_CODE);
                    this.styleDetail[1].push(sdata[i].m_box_item.VALUE2_CODE);
                    this.styleDetail[2].push(sdata[i].m_box_item.QTY);
                    this.styleDetail[3].push(sdata[i].m_box_item.NO);
                }
            }
        }
        else{
            if(box.returnData.data.m_box_item.NAME==this.currentstyle&&box.returnData.data.m_box_item.DESTINATION==$("selCategory").value.strip()){
                this.styleDetail[0].push(box.returnData.data.m_box_item.VALUE1_CODE);
                this.styleDetail[1].push(box.returnData.data.m_box_item.VALUE2_CODE);
                this.styleDetail[2].push(box.returnData.data.m_box_item.QTY);
                this.styleDetail[3].push(box.returnData.data.m_box_item.NO);
            }
        }
        var colors=this.getSingleValueArray(this.styleDetail[0]);
        var sizes=this.getSingleValueArray(this.styleDetail[1]);
        var qtys=new Array(colors.length);
        var nums=new Array(colors.length);
        for (var j=0;j<qtys.length;j++){
            qtys[j]=new Array(sizes.length);
            nums[j]=new Array(sizes.length);
        }
        for (i=0;i<colors.length;i++){
            for(j=0;j<sizes.length;j++){
                qtys[i][j]=0;
            }
        }
        for(i=0;i<this.styleDetail[0].length;i++){
            j=colors.indexOf(this.styleDetail[0][i]);
            k=sizes.indexOf(this.styleDetail[1][i]);
            qtys[j][k]=this.styleDetail[2][i];
            nums[j][k]=this.styleDetail[3][i];
        }
        var str="<table id='modify_table_product'  sytle=\"table-layout:fixed;float:left;margin-left:5px;\" border=\"0\" cellpadding=\"0\" cellspacing=\"1\" bgcolor=\"#8db6d9\">";
        var len=sizes.length;
        for(var s=0;s<len+2;s++){
            str+="<col width=\"80\"/>";
        }
        str+="<tr><td class='hd' bgcolor=\"#FFFFFF\">色号/尺寸</td>";
        for (j=0;j<sizes.length;j++){
            str+="<td class='hd' bgcolor=\"#FFFFFF\">"+sizes[j]+"</td>";
        }
        str+="<td class='hd' bgcolor=\"#FFFFFF\">行合计</td></tr>";
        var k=0;
        for (i=0;i<colors.length;i++){
            str+="<tr><td class='hd' bgcolor=\"#FFFFFF\">"+colors[i]+"</td>";
            for(j=0;j<sizes.length;j++){
                if(qtys[i][j]){
                    k++;
                    str+="<td  class='hi' bgcolor=\"#FFFFFF\"><input id='cs"+k+"' class='inputline' type='text' value='' style='width:97%;border:0' name='"+nums[i][j]+"' title='"+qtys[i][j]+"' /></td>";
                }else
                    str+="<td style='background-color:#eeeeee' class='hi' bgcolor=\"#FFFFFF\"></td>";
            }
            str+="<td  class='hi' bgcolor=\"#FFFFFF\"></td></tr>";
        }
        str+="</table>";
        str+="<div style='display:inline-block;'></div>";
        $("stock_table").innerHTML=str;
        $("modify_table_product").width=(len+2)*80;
        jQuery("#stock_table table input").bind("keydown",function(event){
            var code=event.which;
            if(code==13&&jQuery("#dialouge").css("display")!="none"){
                cstable.saveData();
            }
        });
        jQuery("#stock_table table input").bind("keyup",function(event){
            var e=jQuery(this)[0];
            var tab=jQuery(e).parents("table")[0];
            var p=jQuery(e).parents("tr")[0];
            var rowInput=jQuery(p).find("input");
            var inputIndex=rowInput.index(e);
            var index=jQuery(p).children().index(jQuery(e).parent()[0]);
            var indexD=tab.rows[0].cells.length-jQuery(p).children().length;
            var rowIndex=jQuery(tab.rows).index(p);
            var col=new Array();//所在input列td组
            for(var j=1;j<tab.rows.length;j++){
                var lenC0=tab.rows[0].cells.length;
                var lenCj=tab.rows[j].cells.length;
                col[j-1]=tab.rows[j].cells[index+indexD-(lenC0-lenCj)];
            }
            var colForinput=jQuery(col).find("input");
            var colIndex=colForinput.index(e);
            var code=event.which;
            if((code>=48&&code<=57)||(code>=96&&code<=105)){
                var qty=parseInt(this.title.strip());
                var rQty=isNaN(parseInt(this.value,10))?0:parseInt(this.value,10);
                if(rQty>qty){
                    this.value=0;
                    alert("您最多只能输入"+qty+"件！");
                    dwr.util.selectRange(this,0,100);
                }
                if(qty<0){
                    this.value=0;
                    alert("您输入的数量不能小于0！");
                    dwr.util.selectRange(this,0,100);
                }
            }else if(code==37){ //响应上下左右键事件，及表格中输入框中移动
                if(rowInput[inputIndex-1]){
                    rowInput[inputIndex-1].focus();
                }else{
                    rowInput[rowInput.length-1].focus();
                }
            }else if(code==39){
                if(rowInput[inputIndex+1]){
                    rowInput[inputIndex+1].focus();
                }else{
                    rowInput[0].focus();
                }
            }else if(code==38){
                if(colForinput[colIndex-1]){
                    colForinput[colIndex-1].focus();
                }else{
                    colForinput[colForinput.length-1].focus();
                }
            }else if(code==40){
                if(colForinput[colIndex+1]){
                    colForinput[colIndex+1].focus();
                }else{
                    colForinput[0].focus();
                }
            }
            var rowSum=0;
            rowInput.each(function(){
                rowSum+=isNaN(parseInt(this.value,10))?0:parseInt(this.value,10);
            });
            jQuery(p).children()[jQuery(p).children().length-1].innerHTML=rowSum;
            event.stopPropagation();
        });
        if(jQuery("#stock_table table input").length>1){
            jQuery("#stock_table table input")[1].focus();
            jQuery("#stock_table table input")[0].focus();
        }else{
            jQuery("#stock_table table input")[0].focus();
        }
    },
    showMask:function(e){
        jQuery("#alert-message").css("display","block");
        jQuery("#dialouge").css("display","block");
        this.showStockTable();
    },
    removeMask:function(e){
        jQuery("#alert-message").css("display","none");
        jQuery("#dialouge").css("display","none");
    },
    saveData:function(){
        this.removeMask();
        var retDataes=jQuery("#stock_table table input");
        for(var i=0;i<retDataes.length;i++){
            var cou=isNaN(parseInt(retDataes[i].value,10))?0:parseInt(retDataes[i].value,10);
            if(cou!=0){
                this.metrixRt(retDataes[i].name, cou);
            }
        }
    },
    metrixRt:function(code,count){
        count=parseInt(count);
        var rows=$($("selCategory").value+"Table_"+$("selBox").value).rows;
        var state=true;
        for(var i=0;i<rows.length;i++){
            rows[i].style.backgroundColor="";
            if(rows[i].cells[5].firstChild.id.substring(0,rows[i].cells[5].firstChild.id.lastIndexOf("_"))==($("selCategory").value.strip()+code)){
                rows[i].style.backgroundColor="#ddd";
                rows[i].style.display="";
                var old=rows[i].cells[5].firstChild.innerHTML;
                if($("isRecoil").value=="normal"){
                    rows[i].cells[5].firstChild.innerHTML=isNaN(parseInt(old))?count:(parseInt(old)+count);
                }else{
                    rows[i].cells[5].firstChild.innerHTML=isNaN(parseInt(old))?-count:(parseInt(old)-count);
                }
                if(box.totalBarCode($("selCategory").value,i)>parseInt(rows[i].cells[5].firstChild.title)){
                    var oldColor=rows[i].cells[5].firstChild.style.backgroundColor;
                    rows[i].cells[5].firstChild.style.backgroundColor="#ff0000";
                    alert("扫描数量大于单据数量，输入无效！");
                    rows[i].cells[5].firstChild.innerHTML=old;
                    rows[i].cells[5].firstChild.style.backgroundColor=oldColor;
                }
                var f=parseInt(rows[i].cells[5].firstChild.innerHTML,10);
                f=isNaN(f)?0:f;
                if(f!=0){
                    rows[i].style.display="";
                }else{
                    rows[i].style.display="none";
                }
            }
            if(box.totalBarCode($("selCategory").value,i)<parseInt(rows[i].cells[5].firstChild.title)){
                state=false;
            }
        }
        if(state){
            $($("selCategory").value+"eq").innerHTML="<img name='eq' src=\"images/inco-eq.gif\"  width=\"16\" height=\"16\"/>";
        }else{
            $($("selCategory").value+"eq").innerHTML="<img name='uneq' src=\"images/inco-uneq.gif\"  width=\"16\" height=\"16\"/>";
        }

        if(!window.document.addEventListener){
            window.document.attachEvent("onkeydown",hand11);
            function hand11()
            {
                if(window.event.keyCode==13){
                    return false;
                }
            }
        }
        $("isSaved").value="unSave";
        box.countBox();
        box.countTot();
    }
}
CSTABLE.main = function(){ cstable=new CSTABLE();},
        jQuery(document).ready(CSTABLE.main);
