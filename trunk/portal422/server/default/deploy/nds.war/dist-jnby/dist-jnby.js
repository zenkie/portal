var dist=null;
var DIST=Class.create();
DIST.prototype={
    initialize: function() {
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        dwr.util.setEscapeHtml(false);
        this.windowLocation=window.location;
        this.allot_id=null;
        this.manu=null;
        this.item=null;

        this.cell_data=new Array();
        this.status=0;
        this.loadStatus="load";
        this.ylen=0;
    	  this.data=new Array();//按店仓排序数据
				this.data1=new Array();//按款号排序数据    	  
        this.dataForQtyCan=new Array();//所有可配量数组
        this.bodyWidth=0;
        this.docNoes=new Array();
        /** A function to call if something fails. */
        dwr.engine._errorHandler =  function(message, ex) {
            while(ex!=null && ex.cause!=null) ex=ex.cause;
            if(ex!=null)message=ex.message;// dwr.engine._debug("Error: " + ex.name + "," + ex.message+","+ ex.cause.message, true);
            if (message == null || message == "") alert("A server error has occured. More information may be available in the console.");
            else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
            else alert(message);
        };
        application.addEventListener( "DO_QUERY", this._onLoadMetrix, this);
        application.addEventListener("FUND_BALANCE",this._onfundQuery,this);
        application.addEventListener("DO_SAVE",this._onsaveDate,this);
        application.addEventListener("RELOAD",this._onreShow,this);
    },
    queryObject: function(style){
    	  var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="DO_QUERY";
        var load_type=$("load_type").value;
        var reg=/^\d{8}$/;
        var m_allot_id=$("fund_balance").value||"-1";
        if(style&&style=='doc'){
            if(!$('column_41520').value){
                alert("单据号不能为空！");
                return;
            }
           var searchord=$('column_41520').value;
           var param={"or_type":"","c_dest":"","c_orig":"","m_product":"",
                "datest":"","datend":"","load_type":load_type,"m_allot_id":m_allot_id,"searchord":searchord,"porder":-1};
        }else{
            var doctype=$("column_26991").value;
            if(!doctype){
                alert("订单类型不能为空！");
                return;
            }
            var orig_out_fk=$("fk_column_26992").value;
            if(!orig_out_fk){
                alert("发货店仓不能为空！");
                return;
            }
            if(!$("column_26993").value){
                alert("收货店仓不能为空！");
                return;
            }
            var orig_in_sql=$("column_26993").value;

            if(!$("column_26994").value){
                alert("款号不能为空！");
                return;
            }
            var product_filter=$("column_26994").value;
            var billdatebeg=$("column_26995").value.strip();
            var year=billdatebeg.substring(0,4);
            var month=billdatebeg.substring(4,6);
            var date=billdatebeg.substring(6,8);
            var beg=month+"/"+date+"/"+year;
            if(!this.checkIsDate(month,date,year)||!reg.test(billdatebeg)){
                alert("开始日期格式不对！请输入8位有效数字。");
                return;
            }
            var billdateend=$("column_269966").value.strip();
            var year1=billdateend.substring(0,4);
            var month1=billdateend.substring(4,6);
            var date1=billdateend.substring(6,8);
            var end=month1+"/"+date1+"/"+year1;
            if(!this.checkIsDate(month1,date1,year1)||!reg.test(billdateend)){
                alert("结束日期格式不对！请输入8位有效数字。");
                return;
            }
            var param={"or_type":doctype,"c_dest":orig_in_sql,"c_orig":orig_out_fk,"m_product":product_filter,
                "datest":billdatebeg,"datend":billdateend,"load_type":load_type,
                "m_allot_id":m_allot_id,"searchord":"","porder":-1};
        }
        evt.param=Object.toJSON(param);
        evt.table="m_allot";
        evt.action="distribution_jnby";
        evt.permission="r";
        jQuery("#ph-from-right-table").html("");
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
        /**
         * 2010-4-28 edit by Robin
         */
        var reg=/^\d{8}$/;
        var distdate=jQuery("#distdate").val();
        distdate=distdate.strip();
        var year2=distdate.substring(0,4);
        var month2=distdate.substring(4,6);
        var date2=distdate.substring(6,8);
        var dist=month2+"/"+date2+"/"+year2;
        if(!this.checkIsDate(month2,date2,year2)||!reg.test(distdate)){
            alert("配货日期格式不对！请输入8位有效数字。");
            return;
        }
        /*end*/
        var m_allot_id=$("fund_balance").value||-1;
        var m_item=new Array();
        for(var i=0;i<this.cell_data.length;i++){
        		var ii={};
        		ii.qty_ady=this.cell_data[i].qtyal;
        		ii.m_product_alias_id=this.cell_data[i].barcode;
        		ii.docno=this.cell_data[i].docno;
        		m_item.push(ii);
        }
       
        //end
        var param={};
        param.type=type;
        param.m_allot_id=m_allot_id;
        param.notes=$("notes").value.strip()||"";
        param.m_item=(m_item.length==0?"null":m_item);
        //Edit by Robin 2010-4-28
        param.distdate=distdate;
        //end

        evt.param=Object.toJSON(param);
        //alert(Object.toJSON(param));
        evt.table="m_allot";
        evt.action="save_jnby";
        evt.permission="r";
        evt.isclob=true;
        this._executeCommandEvent(evt);
    },
    reShow:function(){
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="RELOAD";
        var m_allot_id=$("fund_balance").value||"-1";
        var param={"or_type":"-1","c_dest":"-1","c_orig":"-1","m_product":"-1","datest":"-1","datend":"-1","load_type":"reload","m_allot_id":m_allot_id,"porder":-1};
        evt.param=Object.toJSON(param);
        evt.table="m_allot";
        evt.action="distribution_jnby";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    _onreShow:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        $("column_26992").value=ret.C_ORIG||"";
        $("column_26993_fd").value=ret.DEST_FILTER||"(可用 = Y)";
        $("column_26994_fd").value=ret.Product_Filter||"";
        $("column_26995").value=ret.Billdatebeg||"";
        $("column_269966").value=ret.Billdateend||"";
        //alert(ret.distdate);
        jQuery("#distdate1").val(ret.distdate||"");
        jQuery("#distdate").val(ret.distdate||"");
        var isArray=ret.isarray;
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
    //经销商资金余额
    fundQuery:function(){
        var evt={};
        evt.command="DBJSONXML";
        evt.callbackEvent="FUND_BALANCE";
        var w=window.parent;
        if(!w)w=window.opener;
        var m_allot_id=w.document.getElementById("fund_balance").value||"-1";
        var param={"m_allot_id":m_allot_id};
        evt.param=Object.toJSON(param);
        evt.table="m_allot";
        evt.action = "cus";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    _onfundQuery:function(e){
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        var fundStr= "<table  width=\"700\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#8db6d9\" bordercolorlight=\"#FFFFFF\" bordercolordark=\"#FFFFFF\" bgcolor=\"#8db6d9\" class=\"modify_table\" align=\"center\">"+
                     "<tr><td width=\"70\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">序号</div></td>"+
                     "<td width=\"90\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">经销商</div></td>"+
                     "<td width=\"80\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">资金余额</div></td>"+
                     "<td width=\"90\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">已占用金额</div></td>"+
                     "<td width=\"100\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">配货信用下限</div></td>"+
                     "<td width=\"90\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">可用金额</div></td>"+
                     "<td width=\"90\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">本次配货金额</div></td>"+
                     "<td width=\"90\" bgcolor=\"#8db6d9\" class=\"table-title-bg\"><div class=\"td-title\">剩余金额</div></td>"+
                     "</tr>";
        if(ret.data=="null"){
            fundStr="<div style='font-size:20px;color:red;text-align:center;font-weight:bold;vertical-align:middle'>您没有选择经销商！</div>";
        }else{
            var funditem=ret.data;
            if(this.checkIsArray(funditem)){
                for(var i=0;i<funditem.length;i++){
                    fundStr+="<tr>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(i+1)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.NAME||"")+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEEREMAIN||0)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEECHECKED||0)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEELTAKE||0)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEECANTAKE||0)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEEALLOT||0)+"</div></td>"+
                             "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem[i].facusitem.FEEREM||0)+"</div></td>"+
                             " </tr>";
                }
            }
            else{
                fundStr+="<tr>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+1+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.NAME||"")+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEEREMAIN||0)+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEECHECKED||0)+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEELTAKE||0)+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEECANTAKE||0)+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEEALLOT||0)+"</div></td>"+
                         "<td bgcolor=\"#8db6d9\" class=\"td-bg\"><div class=\"td-font\">"+(funditem.facusitem.FEEREM||0)+"</div></td>"+
                         " </tr>";
            }
            fundStr+="</table>";
        }
        $("fund_table1").innerHTML=fundStr;
    },
    _onLoadMetrix:function(e){
    	var datastart=new Date();
        window.self.onunload=function(){
               var e=window.opener||window.parent;
               e.setTimeout("pc.doRefresh()",1);
         }
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        this.manuStr="";
        this.itemStr="";
        if(ret.data&&ret.data=="null"){
            $("table-main").innerHTML="<div style='font-size:20px;color:red;text-align:center;font-weight:bold;vertical-align:middle'>没有数据！</div>";
            return;
        }
        var orderAmount=ret.feeallot||0;
        jQuery("#amount").html(orderAmount).css("display","");
        if(this.checkIsArray(ret.data1)){
        	this.data=ret.data1;
        }else{
        	this.data[0]=ret.data1;
        }
        if(this.checkIsArray(ret.data)){
        	this.data1=ret.data;
        }else{
        	this.data1[0]=ret.data;
        }
        //alert(Object.toJSON(ret));
        var str="";
        var str1="";
        this.ylen=this.data1.length;
        for(var i=0;i<this.ylen;i++){
        	var cell={};
        	cell.docno=this.data[i].m_allotitem.DOCNO;
        	cell.store=this.data[i].m_allotitem.C_STORE;
        	cell.barcode=this.data[i].m_allotitem.M_PRODUCT_ALIAS_ID;
        	cell.qtyal=isNaN(parseInt(this.data[i].m_allotitem.QTY_ALLOT,10))?0:parseInt(this.data[i].m_allotitem.QTY_ALLOT,10);
        	cell.stylename=this.data[i].m_allotitem.NAME;
        	cell.stylevalue=this.data[i].m_allotitem.VALUE;
        	cell.color=this.data[i].m_allotitem.VALUE1;
        	cell.size=this.data[i].m_allotitem.VALUE2;
        	cell.qtyrem=this.data[i].m_allotitem.QTYREM;
        	cell.qtyconsign=isNaN(parseInt(this.data[i].m_allotitem.QTYCONSIGN,10))?0:parseInt(this.data[i].m_allotitem.QTYCONSIGN,10);
        	cell.qtycan=isNaN(parseInt(this.data[i].m_allotitem.QTYCAN,10))?0:parseInt(this.data[i].m_allotitem.QTYCAN,10);
        	cell.qtyaddnow=isNaN(parseInt(this.data[i].m_allotitem.QTYADDNOW,10))?0:parseInt(this.data[i].m_allotitem.QTYADDNOW,10);
        	cell.qtyadd=isNaN(parseInt(this.data[i].m_allotitem.QTYADD,10))?0:parseInt(this.data[i].m_allotitem.QTYADD,10);
        	cell.destqty=isNaN(parseInt(this.data[i].m_allotitem.DESTQTY,10))?0:parseInt(this.data[i].m_allotitem.DESTQTY,10);
        	cell.doctype=this.data[i].m_allotitem.DOCTYPE;
        	this.cell_data.push(cell);
        	this.UpdateDataForQtyCan(cell);
        	
        	str1+=this.data[i].m_allotitem.DOCTYPE=="FWD"?"<div class=\"table-sidebar row\">":"<div class=\"table-sidebar row highlight-xian\">";
        	str1+="<div class=\"row-line\">"+
								"<div class=\"span-18\">"+(i+1)+"</div>"+
                "<div class=\"span-15\">"+this.data[i].m_allotitem.NAME+"</div>"+
								"<div class=\"span-15\">"+this.data[i].m_allotitem.VALUE+"</div>"+
							  "<div class=\"span-12\">"+this.data[i].m_allotitem.VALUE1+"</div>"+
							  "<div class=\"span-12\">"+this.data[i].m_allotitem.VALUE2+"</div>"+
							  "<div class=\"span-15\">"+this.data[i].m_allotitem.NO+"</div>"+
							  "<div class=\"span-14\">"+(this.data[i].m_allotitem.AREA||"无")+"</div>"+
							  "<div class=\"span-15\">"+this.data[i].m_allotitem.C_STORE+"</div>"+
							  "<div class=\"span-15\">"+this.data[i].m_allotitem.DOCNO+"</div>"+
							  "<div class=\"span-12\">"+this.data[i].m_allotitem.QTYREM+"</div>"+
							  "<div class=\"span-12\"><input id='"+cell.barcode+"-"+cell.docno+"' y='"+(i+1)+"' docno='"+cell.docno+"' doctype='"+cell.doctype+"' store='"+cell.store+"' barcode='"+cell.barcode+"' qtycan='"+cell.qtycan+"' qtyrem='"+cell.qtyrem+"' value='"+cell.qtyal+"' type=\"text\" class=\"ipt-25\" /></div>"+
							  "<div class=\"span-12\">"+this.data[i].m_allotitem.QTYCAN+"</div>"+
							  "<div class=\"span-13\">"+this.data[i].m_allotitem.QTYCONSIGN+"</div>"+
							  "<div class=\"span-14\">"+this.data[i].m_allotitem.QTYADDNOW+"</div>"+
							  "<div class=\"span-13\">"+this.data[i].m_allotitem.QTYADD+"</div>"+
							  "<div class=\"span-14\">"+this.data[i].m_allotitem.DESTQTY+"</div>"+
							  "<div class=\"span-13\">"+(this.data[i].m_allotitem.ALLOTSTATE==1?"正常":"全可发")+"</div>"+
							  "<div class=\"span-17\">"+(this.data[i].m_allotitem.PREDATEOUT||"无")+"</div></div>";
        }
        for(var i=0;i<this.data1.length;i++){
        	var cell={};
        	cell.docno=this.data1[i].m_allotitem.DOCNO;
        	cell.store=this.data1[i].m_allotitem.C_STORE;
        	cell.barcode=this.data1[i].m_allotitem.M_PRODUCT_ALIAS_ID;
        	cell.qtyal=this.data1[i].m_allotitem.QTY_ALLOT;
        	cell.stylename=this.data1[i].m_allotitem.NAME;
        	cell.stylevalue=this.data1[i].m_allotitem.VALUE;
        	cell.color=this.data1[i].m_allotitem.VALUE1;
        	cell.size=this.data1[i].m_allotitem.VALUE2;
        	cell.qtyrem=this.data1[i].m_allotitem.QTYREM;
        	cell.qtyconsign=this.data1[i].m_allotitem.QTYCONSIGN;
        	cell.qtycan=this.data1[i].m_allotitem.QTYCAN;
        	
        	cell.qtyaddnow=this.data1[i].m_allotitem.QTYADDNOW;
        	cell.qtyadd=this.data1[i].m_allotitem.QTYADD;
        	cell.destqty=this.data1[i].m_allotitem.DESTQTY;
        	cell.doctype=this.data1[i].m_allotitem.DOCTYPE;
        	str+=this.data1[i].m_allotitem.DOCTYPE=="FWD"?"<div class=\"table-sidebar row\">":"<div class=\"table-sidebar row highlight-xian\">";
        	str+="<div class=\"row-line\">"+
							 "<div class=\"span-18\">"+(i+1)+"</div>"+
							 "<div class=\"span-14\">"+(this.data1[i].m_allotitem.AREA||"无")+"</div>"+
							 "<div class=\"span-15\">"+this.data1[i].m_allotitem.C_STORE+"</div>"+
							 "<div class=\"span-15\">"+this.data1[i].m_allotitem.NAME+"</div>"+
							 "<div class=\"span-15\">"+this.data1[i].m_allotitem.VALUE+"</div>"+
							 "<div class=\"span-12\">"+this.data1[i].m_allotitem.VALUE1+"</div>"+
							 "<div class=\"span-12\">"+this.data1[i].m_allotitem.VALUE2+"</div>"+
							 "<div class=\"span-15\">"+this.data1[i].m_allotitem.NO+"</div>"+
							 "<div class=\"span-15\">"+this.data1[i].m_allotitem.DOCNO+"</div>"+
							 "<div class=\"span-12\">"+this.data1[i].m_allotitem.QTYREM+"</div>"+
							 "<div class=\"span-12\"><input y='"+(i+1)+"' id='"+cell.barcode+"-"+cell.docno+"-1' doctype='"+cell.doctype+"' store='"+cell.store+"' barcode='"+cell.barcode+"' qtycan='"+cell.qtycan+"' docno='"+cell.docno+"' qtyrem='"+cell.qtyrem+"' value='"+cell.qtyal+"' type=\"text\" class=\"ipt-25\" /></div>"+
							 "<div class=\"span-12\">"+this.data1[i].m_allotitem.QTYCAN+"</div>"+
							 "<div class=\"span-13\">"+this.data1[i].m_allotitem.QTYCONSIGN+"</div>"+
							 "<div class=\"span-14\">"+this.data1[i].m_allotitem.QTYADDNOW+"</div>"+
							 "<div class=\"span-13\">"+this.data1[i].m_allotitem.QTYADD+"</div>"+
							 "<div class=\"span-14\">"+this.data1[i].m_allotitem.DESTQTY+"</div>"+
							 "<div class=\"span-13\">"+(this.data1[i].m_allotitem.ALLOTSTATE==1?"正常":"全可发")+"</div>"+
							 "<div class=\"span-17\">"+(this.data1[i].m_allotitem.PREDATEOUT||"无")+"</div></div>";
        }
        jQuery("#table-main1").html(str1);
        jQuery("#table-main").html(str);
        this.listener();
        //alert(Object.toJSON(this.dataForQtyCan));
        //alert(Object.toJSON(this.dataForQtyAddNow));
        
        //alert(Object.toJSON(this.dataForQtyConsign));
    },
            
    //是否在this.dataForQtyCan
    existInDataForQtyCan:function(cell){
    	for(var i=0;i<this.dataForQtyCan.length;i++){
    		if(cell.doctype==this.dataForQtyCan[i].doctype&&cell.barcode==this.dataForQtyCan[i].barcode){
    			return i;
    		}
    	}
    	return -1;
    },
    //更新条码可配量，注意 doctype
    UpdateDataForQtyCan:function(cell){
    	var i=this.existInDataForQtyCan(cell);
    	if(i!=-1){
    		this.dataForQtyCan[i].qtycan-=cell.qtyal;
    		this.dataForQtyCan[i].qtyaddnow-=cell.qtyal;
    		this.dataForQtyCan[i].qtyconsign-=cell.qtyal;
    	}else{
    		var cellForQtyCan={};
    		cellForQtyCan.barcode=cell.barcode;
    		cellForQtyCan.doctype=cell.doctype;
    		cellForQtyCan.qtycan=isNaN(parseInt(cell.qtycan))?0:parseInt(cell.qtycan);
    		cellForQtyCan.qtycan-=cell.qtyal;
    		cellForQtyCan.qtyaddnow=isNaN(parseInt(cell.qtyaddnow,10))?0:parseInt(cell.qtyaddnow,10);
    		cellForQtyCan.qtyaddnow-=cell.qtyal;
    		cellForQtyCan.qtyconsign=isNaN(parseInt(cell.qtyconsign,10))?0:parseInt(cell.qtyconsign,10);
    		cellForQtyCan.qtyconsign-=cell.qtyal;    		
    		this.dataForQtyCan.push(cellForQtyCan);
    	}
    },
    analysis:function(){
        var solist="";
        for(var i=0;i<this.docNoes.length;i++){
            if(i==0){
                solist+="'"+this.docNoes[i]+"'";
            }else{
                solist+=",'"+this.docNoes[i]+"'";
            }
        }
        this.execCxtab(solist);
    },
    execCxtab:function(solist){
        var q={table:"RP_CUSTOMER_SORETSALE",column_masks:4,params:{column:"B_SO_ID;DOCNO", condition:"in ("+solist+")"}};
        var evt={};
        evt.command="ExecuteCxtab";
        evt.callbackEvent="ExecuteCxtab";
        evt.query=Object.toJSON(q);
        evt.cxtab= "806";
        evt.filetype="cub";
        evt.isrest=true;
        Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
                alert(result.message);
            }else {
                var r=result.data;
                if(r.message){
                    alert(r.message.replace(/<br>/g,"\n"));
                }
                if(r.url){
                    dist.showObject( r.url, 400, 200,null);
                }
            }
        });
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
    checkIsObject:function(o) {
        return (typeof(o)=="object");
    },
    checkIsArray: function(o) {
        return (this.checkIsObject(o) && (o.length) &&(!this.checkIsString(o)));
    },
    checkIsString:function (o) {
        return (typeof(o)=="string");
    },
    checkIsDate:function(month,date,year){
        if(parseInt(month,10)>12||parseInt(month,10)<1||parseInt(date,10)>31||parseInt(date,10)<1||parseInt(year,10)<1980||parseInt(year,10)>3000) {
            return false;
        }
        return true;
    },
    auto_dist:function(){
    	var height=document.body.clientHeight;
    	var width=document.body.clientWidth;
    	jQuery("#auto_dist").css("top",height/2-200).css("left",width/2-300).show();
    },
    closeAuto:function(){
    	jQuery("#auto_dist").hide();
    },
    exec_dist:function(){
     	if(!confirm("自动配货会清空已编辑内容，确认继续？")){
          return;
      }
    	var expr="#jnby-from>div:visible input[y]";
    	var dist_type=jQuery("#dist_type").val();
    	if(jQuery("#"+dist_type)[0]){
    		var dist_param=jQuery("#"+dist_type).val();
    	}
    	jQuery(expr).each(function(){
    		jQuery(this).val("0");
    		dist.updatecell(this,false);
    	});
    	if(dist_type=="specNumber"){
    		this.auto_dist_for_specNumber(dist_param,expr);
    	}else if(dist_type=="fowNotOrderPercent"){
    		this.auto_dist_for_fowNotOrderPercent(dist_param,expr);
    	}else if(dist_type=="fowOrderPercent"){
    		this.auto_dist_for_fowOrderPercent(expr);
    	}
    	jQuery("#auto_dist").hide();
    },
    auto_dist_for_specNumber:function(dist_param,expr){
    	dist_param=parseInt(dist_param,10);
    	dist_param=isNaN(dist_param)?0:dist_param;
    	jQuery(expr).each(function(){
    		jQuery(this).val(dist_param);
    		dist.updatecell(this,false);
    	});
    },
    auto_dist_for_fowNotOrderPercent:function(dist_param,expr){
    	dist_param=parseFloat(dist_param);
    	dist_param=isNaN(dist_param)?0:dist_param;
    	jQuery(expr).each(function(){
	    	var qty=parseInt(dist_param*parseInt(jQuery(this).attr("qtyRem"),10),10);
		    jQuery(this).val(qty);
    		dist.updatecell(this,false);  		
    	});    	
    },
    /**
     * edit by Robin 2010.5.7
     * 传入一个JSON对象在this.data中查找符合的结果集数组并返回
     * @param cellData JSON对象可能含有color、size、docNo、store、barCode中多个或1个用此对象和this.data数组中的JSON对象比较
     */
    v2m_get_ret:function(cellData){
    		//alert(Object.toJSON(this.v2m_get_ret_any(cellData,this.data)));
        return this.v2m_get_ret_any(cellData,this.cell_data);
    },
    /**
     * edit by Robin 2010.5.11
     * 传入一个JSON对象在data中查找符合的结果集数组并返回
     * @param cellData JSON对象可能含有color、size、docNo、store、barCode中多个或1个用此对象和data数组中的JSON对象比较
     * @param data 包含color、size、docNo、store、barCode属性元素的数组
     */    
		v2m_get_ret_any:function(cellData,data){
        var result=new Array();
        for(var i=0;i<data.length;i++){
            if((cellData.doctype?data[i].doctype==cellData.doctype:true)&&(cellData.sty?data[i].sty==cellData.sty:true)&&(cellData.color?data[i].color==cellData.color:true)&&(cellData.size?data[i].size==cellData.size:true)&&(cellData.docno?cellData.docno==data[i].docno:true)&&(cellData.store?cellData.store==data[i].store:true)&&(cellData.barcode?cellData.barcode==data[i].barcode:true)){
                result.push(data[i]);
            }
        }
        return result;			
		},
		get_totrem_for_param:function(barcode,doctype){
			var cellData={};
			cellData.barcode=barcode;
			cellData.doctype=doctype;
			var cells=this.v2m_get_ret(cellData);
			var totrem=0;
			for(var i=0;i<cells.length;i++){
				totrem+=cells.qtyrem;
			}
			return totrem;
		},
    auto_dist_for_fowOrderPercent:function(expr){
    	jQuery(expr).each(function(){
    		var totrem=dist.get_totrem_for_param(jQuery(this).attr("barcode"),jQuery(this).attr("doctype"));
				var qtyrem=jQuery(this).attr("qtyrem");
				qtyrem=isNaN(parseInt(qtyrem))?0:parseInt(qtyrem);
				var qtycan=jQuery(this).attr("qtycan");
				qtycan=isNaN(parseInt(qtycan))?0:parseInt(qtycan);
		  	var percent=qtyrem/totrem;
		  	var qty=parseInt(percent*qtycan,10);
		  	jQuery(this).val(qty);
    		dist.updatecell(this,false);
    	});     
    },        
    /**
    *传入元素聚焦下个编辑
    */
    next_cell:function(e){
    	 var y=parseInt(jQuery(e).attr("y"),10);
       var cell=jQuery("#jnby-from>div:visible input[y='"+(y+1)+"']")[0];
       if(cell){
           cell.focus();
        }else{
           var cell=jQuery("#jnby-from>div:visible input[y='1']")[0].focus();
        }
    },
    /**
    *传入元素聚焦上个编辑
    */
    next_cell_up:function(e){
    	 var y=parseInt(jQuery(e).attr("y"),10);
       var cell=jQuery("#jnby-from>div:visible input[y='"+(y-1)+"']")[0];
       if(cell){
           cell.focus();
        }else{
           var cell=jQuery("#jnby-from>div:visible input[y='"+this.ylen+"']")[0].focus();
        }
    },
    /**
    给定元素节点查询在this.dataForQtyCan的单元
    */
    get_qty_cell:function(e){
    	var barcode=jQuery(e).attr("barcode");
    	var doctype=jQuery(e).attr("doctype");
    	for(var i=0;i<this.dataForQtyCan.length;i++){
    		if(barcode==this.dataForQtyCan[i].barcode&&this.dataForQtyCan[i].doctype==doctype){
    			return this.dataForQtyCan[i];
    		}
    	}
    	return -1;
    },
    /**
    给定元素节点返回对应数据单元
    */
   get_data_cell:function(e){
    	var barcode=jQuery(e).attr("barcode");
    	var docno=jQuery(e).attr("docno");			   	
    	for(var i=0;i<this.cell_data.length;i++){
    		if(barcode==this.cell_data[i].barcode&&this.cell_data[i].docno==docno){
    			return this.cell_data[i];
    		}
    	}
    	return -1;
   }, 
    /**
    根据节点更新头可配量。。。信息
    */
    updatetitle:function(e){
    	var cell=this.get_qty_cell(e);
    	if(cell!=-1){
    		jQuery("#qty-can").html(cell.qtycan+"");
    		jQuery("#qty-consign").html(cell.qtyconsign+"");
    		jQuery("#qty-addnow").html(cell.qtyaddnow+"");
    	}
    },
    //当编辑配货数可配时，更新数据层和编辑单元的数据
    updatedata:function(cell,cell1,newqty,newdiffqty){
	    		cell1.qtycan-=newdiffqty;
	    		cell1.qtyconsign-=newdiffqty;
	    		cell1.qtyaddnow-=newdiffqty;
	    		cell.qtyal+=newdiffqty;
	    		var barcode=cell.barcode;
	    		var docno=cell.docno;
	    		jQuery("#"+barcode+"-"+docno).val(newqty);
	    		jQuery("#"+barcode+"-"+docno+"-1").val(newqty);
    },
    //传入在编辑的单元，更新数据
    updatecell:function(e,aler){
    	var nowqty=jQuery(e).val();
    	nowqty=isNaN(parseInt(nowqty,10))?0:parseInt(nowqty,10);
    	var cell=this.get_data_cell(e);
    	
    	var cell1=this.get_qty_cell(e);
    	if(cell!=-1&&cell1!=-1){
    		if(nowqty<0){
    			jQuery(e).val(cell.qtyal);
    			alert("不可输入负数");
    			return;
    		}
	    	var diffqty=nowqty-cell.qtyal;
	    	var qtycan=Math.min(cell1.qtycan,cell1.qtyconsign,cell1.qtyaddnow);
	    	if(diffqty>qtycan){
	    		var newqty=qtycan+cell.qtyal;
	    		var newdiffqty;
	    		if(!newqty<0){
	    			newdiffqty=qtycan;

	    		}else{
	    			newqty=0;
	    			newdiffqty=0-cell.qtyal;
	    		}
   				this.updatedata(cell,cell1,newqty,newdiffqty);
   				if(aler==true)alert("配货量不得大于实际可配发量！");
	    		return;
	    	}else{
	    		this.updatedata(cell,cell1,nowqty,diffqty);
	    		return;
	    	}
    	}else{
    		alert("错误！");
    		return;
    	}
    },
    listener:function(){
        window.onbeforeunload=function(){
        		if(window.location==dist.windowLocation){
            	if( $("isChanged").value=='true'){
 	               		return "页面数据已改动，还未保存！";
		            }else{
		                return;
		            }
          	}
       	 }

        jQuery("#jnby-from>div input[y]").bind("focus",function(event){
        	if(event.target==this){
            
            dist.updatecell(this,false);
            dist.updatetitle(this);
            dwr.util.selectRange(this,0,100);
          }
        });
        jQuery("#jnby-from>div input[y]").bind("keydown",function(event){
            if(event.which==13){
            	if(event.target=this){
            		dist.next_cell(this);

              }
            }
        });
        jQuery("#jnby-from>div input[y]").bind("keyup",function(event){
            if(event.target==this){
                this.status=1;
                if((event.which>=48&&event.which<=57)||(event.which>=96&&event.which<=105)){
            				dist.updatecell(this,true);
           				  dist.updatetitle(this);
                }else if(event.which==38){//上
										dist.next_cell_up(this);
                }else if(event.which==40){//下
                		dist.next_cell(this);
                }else if(event.which==8||event.which==46){
                    if(this.value==""||this.value.strip()==""){
                      this.value=0;
                    }
                }
                   
            }
        });
        jQuery("#model").bind("click",function(){
        	if(jQuery("#model").is(":checked")){
        		jQuery("#jnby-from").show();
        		jQuery("#jnby-from1").hide();
        	}else{
         		jQuery("#jnby-from1").show();
        		jQuery("#jnby-from").hide();       		
        	}
        });
        jQuery("#jnby-from>div:visible input[y]:first").focus();
    },
    showObject:function(url, theWidth, theHeight,option){
        if( theWidth==undefined || theWidth==null) theWidth=956;
        if( theHeight==undefined|| theHeight==null) theHeight=570;
        var options={width:theWidth,height:theHeight,title:gMessageHolder.IFRAME_TITLE, modal:true,centerMode:"x",maxButton:true,onCenter:true};
        if(option!=undefined){
            Object.extend(options, option);
        }
        Alerts.popupIframe(url,options);
        Alerts.resizeIframe(options);
    }
}
DIST.main = function(){
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