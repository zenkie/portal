var dist=null;
var DIST=Class.create();
DIST.prototype={
    initialize: function() {
        this.itemStr="";
        this.manuStr="";
        this.allot_id=null;
        this.manu=null;
        this.item=null;
        this.product=new Array();
        this.status=0;
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        dwr.util.setEscapeHtml(false);
        /** A function to call if something fails. */
        dwr.engine._errorHandler =  function(message, ex) {
            while(ex!=null && ex.cause!=null) ex=ex.cause;
            if(ex!=null)message=ex.message;// dwr.engine._debug("Error: " + ex.name + "," + ex.message+","+ ex.cause.message, true);
            if (message == null || message == "") alert("A server error has occured. More information may be available in the console.");
            else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
            else alert(message);
        };
        application.addEventListener( "DO_QUERY", this._onLoadMetrix, this);
        application.addEventListener("DO_SAVE",this._onsaveDate,this);
        application.addEventListener("RELOAD",this._onreShow,this);
        /*  application.addEventListener("FUND_BALANCE",this._onfundQuery,this);
         */
    },
    getCustomId:function(){
        var orderId=$("fk_column_40252").value||-1;
        if(orderId==-1){
            alert("订单号未选择或操作错误！");
            return;
        }
        jQuery.get("_getCustomId.jsp",{"orderid":orderId},function(data){
            oq.toggle_m('/html/nds/query/search.jsp?table=C_V_STORE2&return_type=f&accepter_id=column_26993&fixedcolumns=C_V_STORE2.C_CUSTOMER_ID%3D'+data, 'column_26993');
        });
    },
    queryObject: function(style){
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="DO_QUERY";
        var load_type=$("load_type").value;
        var m_allot_id=$("fund_balance").value||"-1";
        if(!$('fk_column_40252').value){
            alert("单据号不能为空！");
            return;
        }
        if(!$("column_26993").value){
            alert("收货店仓不能为空！");
            return;
        }
        var orig_in_sql=$("column_26993").value;
        var searchord=$('fk_column_40252').value;
        var param={"or_type":-1,"c_dest":orig_in_sql,"c_orig":-1,"m_product":-1,"porder":1,
            "datest":-1,"datend":-1,"load_type":load_type,"m_allot_id":m_allot_id,"searchord":searchord};
        evt.param=Object.toJSON(param);
        evt.table="m_allot";
        evt.action="distribution";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    saveDate:function(type){
        if($("orderStatus").value=="2"){
            alert("该单据已提交，不可再进行操作！");
            return;
        }
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="DO_SAVE";
        if(type=='ord'){
            if(!confirm("单据提交不可修改！确认提交？")){
                return;
            }
        }
        var m_allot_id=$("fund_balance").value||-1;
        var m_item=new Array();
        var inputItems=jQuery("#ph-from-right-table>table input[title][value!='']");
        for(var i=0;i<inputItems.length;i++){
            var ii={};
            if(!isNaN(inputItems[i].value)){
                ii.qty_ady=inputItems[i].value;
                ii.m_product_alias_id=inputItems[i].title;
                ii.store_id=jQuery(inputItems[i]).attr("store");
                m_item.push(ii);
            }
        }
        var docno=$("column_40252").value;
        var param={};
        param.type=type;
        param.m_allot_id=m_allot_id;
        param.m_item=(m_item.length==0?"null":m_item);
        param.docno=docno;
        evt.param=Object.toJSON(param);
        evt.table="m_allot";
        evt.action="save";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    reShow:function(){
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="RELOAD";
        var m_allot_id=$("fund_balance").value||"-1";
        var param={"or_type":"-1","c_dest":"-1","c_orig":"-1","m_product":"-1",
            "datest":"-1","datend":"-1","load_type":"reload","m_allot_id":m_allot_id,"porder":1};
        evt.param =Object.toJSON(param);
        evt.table="m_allot";
        evt.action="distribution";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    _onreShow:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        $("column_40252").value=ret.searchord;
        $("column_26993_fd").value=ret.DEST_FILTER||"(可用 = Y)";
        jQuery("#ph-serach>div[class='djh-table']>table input[class!='notes']").attr("disabled","true");
        jQuery("#ph-serach>div[class='djh-table']>table td>span").hide();
        var status=ret.status;
        $("orderStatus").value=status;
        if(status=="2"){
            $("submitImge").style.display="";
        }
        this._onLoadMetrix(e);
    },
    _onsaveDate:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        if(ret.data=="OK"){
            this.status=0;
            jQuery("#ph-serach-bg>div input[type='image']").hide();
            alert("保存成功！");
            $("isChanged").value="false";
        }else if(ret.data=="YES"){
            this.status=0;
            alert("提交成功！");
            $("isChanged").value="false";
            window.self.close();
        }else{
            alert("出现错误！可能原因："+ret.data);
        }
    },
    _onLoadMetrix:function(e){
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        if(ret.data&&ret.data=="null"){
            $("ph-from-right-table").innerHTML="<div style='font-size:20px;color:red;text-align:center;font-weight:bold;vertical-align:middle'>没有数据！</div>";
            return;
        }
        var pdts=this.pdtToJson(ret.data.m_product);
        $("isChanged").value='false';
        this.manuStr="";
        this.itemStr="";
        for(var i=0;i<pdts.length;i++){
            this.manuStr+="<li><div class='txt-on' name='"+pdts[i].dis+"' title='"+pdts[i].id+"'>"+pdts[i].pdtStyle+"</div></li>";
            this.itemStr+="<table title='"+this.getStyTotRem(pdts[i])+"' name='"+this.getStyTotCan(pdts[i])+"' id='"+pdts[i].id+"' style='display:none' cellspacing=\"1\" cellpadding=\"0\" border=\"0\" bgcolor=\"#8db6d9\">"
            var colors=pdts[i].color;
            this.itemStr+="<tr><td bgcolor=\"#ffffff\" width=\"55\" class=\"td-left-title\">颜色</td>"+
                          "<td bgcolor=\"#ffffff\" width=\"132\" class=\"td-left-title\">店仓\\尺寸</td>";
            for(var c=0;c<colors[0].sizes.length;c++){
                this.itemStr+="<td bgcolor=\"#b6d0e7\" width=\"65\" class=\"td-right-title\">"+colors[0].sizes[c]+"</td>";
            }
            this.itemStr+="</tr>";
            for(var j=0;j<colors.length;j++){
                var stors=colors[j].stors;
                for(var jj=0;jj<colors[j].rowSpan;jj++){
                    if(jj==0){
                        this.itemStr+="<tr>"+
                                      "<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-left-txt\" rowspan='"+colors[j].rowSpan+"'>"+colors[j].colorName+"</td>"+
                                      "<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txt\">可配</td>";
                        for(var s=0;s<colors[j].qtycan.length;s++){
                            if(colors[j].qtycan[s]!='no'){
                                this.itemStr+="<td id='"+colors[j].barcode[s]+"-can' bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtK\">"+colors[j].qtycan[s]+"</td>";
                            }else{
                                this.itemStr+="<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtK\" style=\"background-color:#eeeeee\"></td>";
                            }
                        }
                        this.itemStr+="</tr>";
                    }else if(jj==1){
                        this.itemStr+="<tr>"+
                                      "<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txt\">未配</td>";
                        for(var s1=0;s1<colors[j].qtyrem.length;s1++){
                            if(colors[j].qtyrem[s1]!='no'){
                                this.itemStr+="<td id='"+colors[j].barcode[s1]+"-rem' bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtW\">"+colors[j].qtyrem[s1]+"</td>";
                            }else{
                                this.itemStr+="<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtW\" style=\"background-color:#eeeeee\"></td>";
                            }
                        }
                        this.itemStr+="</tr>";
                    }else if(jj==2){
                        this.itemStr+="<tr>"+
                                      "<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txt\">订单量</td>";
                        for(var s2=0;s2<colors[j].qtyorder.length;s2++){
                            if(colors[j].qtyorder[s2]!='no'){
                                this.itemStr+="<td id='"+colors[j].barcode[s2]+"-order' bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtD\">"+colors[j].qtyorder[s2]+"</td>";
                            }else{
                                this.itemStr+="<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txtD\" style=\"background-color:#eeeeee\"></td>";
                            }
                        }
                        this.itemStr+="</tr>";
                    }else{
                        var v=jj-3;
                        this.itemStr+="<tr><td title='"+colors[j].stors[v].id+"' bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-right-txt\">"+colors[j].stors[v].name+"</td>";
                        for(var g=0;g<colors[j].qtyrem.length;g++){
                            if(colors[j].qtyrem[g]!='no'){
                                this.itemStr+="<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-bg\"><input type=\"text\" name='"+colors[j].sizes[g]+"' class=\"td-txt-input\" title='"+colors[j].barcode[g]+"' store='"+colors[j].stors[v].id+"'/></td>";
                            }else{
                                this.itemStr+="<td bgcolor=\"#8db6d9\" valign=\"top\" class=\"td-bg\" style=\"background-color:#eeeeee\"></td>";
                            }
                        }
                        this.itemStr+="</tr>";
                    }
                }
            }
            this.itemStr+="</table>";
        }
        jQuery("#styleManu").html(this.manuStr);
        jQuery("#ph-from-right-table").html(this.itemStr);
        $("fund_balance").value=ret.m_allot_id;
        this.autoShowManuAndItem();
        this.listener();
        this.manuStr=null;
        this.itemStr=null;
        if(ret.status=="2"){
            jQuery("#ph-from-right-table td input").attr("disabled","true");
        }
        if($("load_type").value=="reload"){
            if(ret.c_storeitem){
                this.fillItem(ret.c_storeitem);
            }
        }
        window.onbeforeunload=function(){
            if($("isChanged").value=='true'){
                return "页面数据已改动，还未保存！";
            }else{
                return;
            }
        }
    },
    fillItem:function(storeItem){
        var stores=new Array();
        if(this.checkIsArray(storeItem)){
            for(var i=0;i<storeItem.length;i++){
                stores[i]=storeItem[i];
            }
        }else{
            stores[0]=storeItem;
        }
        for(var j=0;j<stores.length;j++){
            jQuery("#ph-from-right-table>table input[title='"+stores[j].m_product_alias+"'][store='"+stores[j].content+"']").val(stores[j].QTY_ALLOT);
        }
    },
    autoDist:function(){
        jQuery("#ph-from-right-table>table input").each(function(){
            this.value="";
        });
        jQuery("#ph-from-right-table>table input").each(function(){
            if(this.value==""){
                var barcode=this.title;
                var storsInput=jQuery("#ph-from-right-table>table input[title="+barcode+"]");
                var can=jQuery("#"+barcode+"-can").text();
                can=isNaN(parseInt(can))?0:parseInt(can);
                var rem=jQuery("#"+barcode+"-rem").text();
                rem=isNaN(parseInt(rem))?0:parseInt(rem);
                var current=Math.min(rem,can);
                var len=storsInput.length;
                var every=Math.floor(current/len);
                var mod=current%len;
                storsInput.each(function(){
                    this.value = every;
                });
                if(mod>0){
                    for(var i=0;i<mod;i++){
                        var cou=parseInt(storsInput[i].value);
                        cou=isNaN(cou)?0:cou;
                        storsInput[i].value=cou+1;
                    }
                }
            }
        });
    },
    /*当未点击产品类别时调用，如页面载入，模糊查询*/
    autoShowManuAndItem:function(){
        var divs=jQuery("#styleManu>li:visible>div");
        if(divs[0]){
            this.autoViewForStyle(divs[0]);
        }else{
            jQuery("#ph-from-right-table>table").css("display","none");
        }
    },
    autoViewForStyle:function(div){
        jQuery("#styleManu>li:visible>div").css("backgroundColor","").css("color","");
        jQuery("#ph-from-right-table>table").css("display","none");
        jQuery(div).css("backgroundColor","#8db6d9").css("color","white");
        var styleId=jQuery(div).attr("title").strip();
        var styName=jQuery(div).attr("name").strip();
        jQuery("#"+styleId).show();
        jQuery("#ph-pic-img-border>img").attr("src","/pdt/"+styleId+"_1_2.jpg");
        jQuery("#ph-pic-img-txt").html(jQuery(div).text()+"<br/>"+styName);
        jQuery("#totStyleCan").html(jQuery("#"+styleId).attr("name"));
        jQuery("#totStyleRem").html(jQuery("#"+styleId).attr("title"));
        var inputs=jQuery("#"+styleId+" td>input");
        var totStyleAlready=0;
        for(var i=0;i<inputs.length;i++){
            if(i==0){
                inputs[i].focus();
            }
            var coun=parseInt(inputs[i].value,10);
            totStyleAlready+=isNaN(coun)?0:coun;
        }
        jQuery("#totStyleAlready").html(totStyleAlready);
    },
    listener:function(){
        jQuery("#styleManu>li>div").bind("click",function(){
            dist.autoViewForStyle(this);
        });
        jQuery("#ph-from-right-table>table td>input").bind("focus",function(){
            jQuery("#barcodeRem").html(jQuery("#"+this.title+"-rem").text());
            var barcodeInputs=jQuery("#ph-from-right-table>table:visible td>input[title="+this.title+"]");
            var totBarcodeAlready=0;
            for(var i=0;i<barcodeInputs.length;i++){
                var num=parseInt(barcodeInputs[i].value,10);
                totBarcodeAlready+=isNaN(num)?0:num;
            }
            jQuery("#barcodeAlready").html(totBarcodeAlready);
            var inputs=jQuery("#ph-from-right-table>table:visible td>input");
            var totStyleAlready=0;
            for(var j=0;j<inputs.length;j++){
                var coun=parseInt(inputs[j].value,10);
                totStyleAlready+=isNaN(coun)?0:coun;
            }
            jQuery("#totStyleAlready").html(totStyleAlready);
        });
        jQuery("#quickSearch").bind("keyup",function(){
            var sty=this.value.strip();
            var reg=new RegExp(sty,"i");
            jQuery("#styleManu>li").hide();
            jQuery("#styleManu>li>div").each(function(){
                if(reg.test(this.innerHTML)){
                    jQuery(this).parent("li").show();
                }
            });
            dist.autoShowManuAndItem();
        });
        jQuery("#ph-from-right-table>table td>input").bind("keyup",function(event){
            if(event.target==this){
                var row=jQuery(jQuery(this).parents("tr")[0]).find("input");
                var indexOfRow=row.index(this);
                var col=jQuery("#ph-from-right-table>table:visible td>input[name="+this.name+"]");
                var indexOfCol=col.index(this);
                if((event.which>=48&&event.which<=57)||(event.which>=96&&event.which<=105)){
                    $("isChanged").value='true';
                    if(this.value.strip()!=""){
                        var count=parseInt(this.value.strip());
                        this.value=count;
                        if(isNaN(count)||count<0){
                            alert("请输入非负的整数！");
                            this.value=0;
                            dwr.util.selectRange(this,0,20);
                        }
                    }
                    var barcodeInputs=jQuery("#ph-from-right-table>table:visible td>input[title="+this.title+"]");
                    var totBarcodeAlready=0;
                    for(var i=0;i<barcodeInputs.length;i++){
                        var num=parseInt(barcodeInputs[i].value,10);
                        totBarcodeAlready+=isNaN(num)?0:num;
                    }
                    var inputs=jQuery("#ph-from-right-table>table:visible td>input");
                    var totStyleAlready=0;
                    for(var j=0;j<inputs.length;j++){
                        var coun=parseInt(inputs[j].value,10);
                        totStyleAlready+=isNaN(coun)?0:coun;
                    }
                    var can=parseInt(jQuery("#"+this.title+"-can").text());
                    can=isNaN(can)?0:can;
                    var rem=parseInt(jQuery("#"+this.title+"-rem").text());
                    rem=isNaN(rem)?0:rem;
                    if(totBarcodeAlready<=can&&totBarcodeAlready<=rem&&totBarcodeAlready>=0){
                        jQuery("#totStyleAlready").html(totStyleAlready);
                        jQuery("#barcodeAlready").html(totBarcodeAlready);
                    }else{
                        alert("已配量不得大于可配量和未配量！");
                        var yy=parseInt(this.value);
                        jQuery("#totStyleAlready").html(totStyleAlready-yy);
                        jQuery("#barcodeAlready").html(totBarcodeAlready-yy);
                        this.value = 0;
                        dwr.util.selectRange(this,0,100);
                    }
                }else if(event.which==37){
                    if(indexOfRow>0){
                        row[indexOfRow-1].focus();
                    }else{
                        row[row.length-1].focus();
                    }
                }else if(event.which==39){
                    if(indexOfRow<(row.length-1)){
                        row[indexOfRow+1].focus();
                    }else{
                        row[0].focus();
                    }
                }else if(event.which==38){
                    if(indexOfCol>0){
                        col[indexOfCol-1].focus();
                    }else{
                        col[col.length-1].focus();
                    }
                }else if(event.which==40){
                    if(indexOfCol<col.length-1){
                        col[indexOfCol+1].focus();
                    }else{
                        col[0].focus();
                    }
                }
            }
        });
        jQuery("#ph-from-right-table>table td>input").bind("keydown",function(event){
            if(event.which==13){
                if(jQuery("#ph-from-right-table>table:visible input")[jQuery("#ph-from-right-table>table:visible input").index(this)+1]){
                    jQuery("#ph-from-right-table>table:visible input")[jQuery("#ph-from-right-table>table:visible input").index(this)+1].focus();
                }else{
                    jQuery("#ph-from-right-table>table:visible input")[0].focus();
                }
            }
        });
    },
    getStyTotRem:function(style){
        var colors=style.color;
        var rem=0;
        for(var i=0;i<colors.length;i++){
            for(var j=0;j<colors[i].qtyrem.length;j++){
                rem+=isNaN(parseInt(colors[i].qtyrem[j],10))?0:parseInt(colors[i].qtyrem[j],10);
            }
        }
        return rem;
    },
    getStyTotCan:function(style){
        var colors=style.color;
        var can=0;
        for(var i=0;i<colors.length;i++){
            for(var j=0;j<colors[i].qtycan.length;j++){
                can+=isNaN(parseInt(colors[i].qtycan[j],10))?0:parseInt(colors[i].qtycan[j],10);
            }
        }
        return can;
    },
    pdtToJson:function(pdt){
        var pdts=new Array();
        if(this.checkIsArray(pdt)){
            for(var i=0;i<pdt.length;i++){
                pdts[i]={};
                pdts[i].pdtStyle=pdt[i].xmlns;
                pdts[i].dis=pdt[i].value;
                pdts[i].id=pdt[i].M_PRODUCT_LIST;
                pdts[i].color=this.colorToJson(pdt[i].color);
            }
        }else{
            pdts[0]={};
            pdts[0].pdtStyle=pdt.xmlns;
            pdts[0].dis=pdt.value;
            pdts[0].id=pdt.M_PRODUCT_LIST;
            pdts[0].color=this.colorToJson(pdt.color);
        }
        return pdts;
    },
    colorToJson:function(color){
        var colors=new Array();
        if(this.checkIsArray(color)){
            for(var i=0;i<color.length;i++){
                colors[i]={};
                colors[i].colorName=color[i].xmlns;
                colors[i].rowSpan=this.getColorSpan(color[i]);
                colors[i].stors=this.storToJson(color[i].array.c_store);
                colors[i].sizes=this.getSizes(color[i].array.tag_c);
                colors[i].qtyrem=this.getQtyrem(color[i].array.tag_c);
                colors[i].barcode=this.getBarcode(color[i].array.tag_c);
                colors[i].qtycan=this.getQtycan(color[i].array.tag_c);
                colors[i].qtyorder=this.getOrder(color[i].array.tag_c);
                colors[i].qtyallot=this.getAllot(color[i].array.tag_c);
                colors[i].qtyso=this.getSo(color[i].array.tag_c);
            }
        }else{
            colors[0]={};
            colors[0].colorName=color.xmlns;
            colors[0].rowSpan=this.getColorSpan(color);
            colors[0].stors=this.storToJson(color.array.c_store);
            colors[0].sizes=this.getSizes(color.array.tag_c);
            colors[0].qtyrem=this.getQtyrem(color.array.tag_c);
            colors[0].barcode=this.getBarcode(color.array.tag_c);
            colors[0].qtycan=this.getQtycan(color.array.tag_c);
            colors[0].qtyorder=this.getOrder(color.array.tag_c);
            colors[0].qtyallot=this.getAllot(color.array.tag_c);
            colors[0].qtyso=this.getSo(color.array.tag_c);
        }
        return colors;
    },
    getSo:function(tags){
        var so=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                so[i]=tags[i].content?tags[i].QTY_SO:"no";
            }
        }else{
            so[0]=tags.content?tags.QTY_SO:"no";
        }
        return so;
    },
    getAllot:function(tags){
        var allot=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                allot[i]=tags[i].content?tags[i].QTY_ALLOT:"no";
            }
        }else{
            allot[0]=tags.content?tags.QTY_ALLOT:"no";
        }
        return allot;
    },
    getOrder:function(tags){
        var order=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                order[i]=tags[i].content?tags[i].DESTQTY:"no";
            }
        }else{
            order[0]=tags.content?tags.DESTQTY:"no";
        }
        return order;
    },
    getQtycan:function(tags){
        var qtycan=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                qtycan[i]=tags[i].content?tags[i].QTYCAN:"no";
            }
        }else{
            qtycan[0]=tags.content?tags.QTYCAN:"no";
        }
        return qtycan;
    },
    getBarcode:function(tags){
        var barcode=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                barcode[i]=tags[i].content?tags[i].m_product_alias_id:"no";
            }
        }else{
            barcode[0]=tags.content?tags.m_product_alias_id:"no";
        }
        return barcode;
    },
    getQtyrem:function(tags){
        var rems=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                rems[i]=tags[i].content?tags[i].QTYREM:"no";
            }
        }else{
            rems[0]=tags.content?tags.QTYREM:"no";
        }
        return rems;
    },
    getSizes:function(tags){
        var sizes=new Array();
        if(this.checkIsArray(tags)){
            for(var i=0;i<tags.length;i++){
                sizes[i]=tags[i].content?tags[i].content:tags[i];
            }
        }else{
            sizes[0]=tags.content?tags.content:tags;
        }
        return sizes;
    },
    storToJson:function(stor){
        var stors=new Array();
        if(this.checkIsArray(stor)){
            for(var i=0;i<stor.length;i++){
                stors[i]={};
                stors[i].name=stor[i].c_sname;
                stors[i].id=stor[i].content;
            }
        }else{
            stors[0]={};
            stors[0].name=stor.c_sname;
            stors[0].id=stor.content;
        }
        return stors;
    },
    getColorSpan:function(colorDetail){
        var det=colorDetail.array.c_store;
        var count=4;
        if(this.checkIsArray(det)){
            count=3+det.length;
        }
        return count;
    },
    checkIsObject:function(o) {
        return (typeof(o)=="object");
    },
    checkIsArray: function(o) {
        return (this.checkIsObject(o) && (o.length) &&(!this.checkIsString(o)));
    },
    checkIsString:function (o) {
        return (typeof(o)=="string");
    },
    _executeCommandEvent :function(evt){
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
    }
}
DIST.main = function () {
    dist=new DIST();
};
jQuery(document).ready(DIST.main);
jQuery(document).ready(function(){
    jQuery("body").bind("keyup",function(event){
        if(event.which==13){
            event.stopPropagation();
        }
    });
});