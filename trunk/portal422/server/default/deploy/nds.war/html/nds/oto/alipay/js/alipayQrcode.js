var al=null;
var ALIPAY=Class.create();
ALIPAY.prototype={
    initialize: function() {
		this.alipay={};
		this.smsmoney=0;
		this.smsnumber=0;
		this.ismakeout='n';
		this.isWaitePay=false;
        dwr.util.setEscapeHtml(false);
        dwr.engine._errorHandler =  function(message, ex) {
            while(ex!=null && ex.cause!=null) ex=ex.cause;
            if(ex!=null)message=ex.message;
            if (message == null || message == "") alert("A server error has occured. More information may be available in the console.");
            else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
            else alert(message);
        };
        application.addEventListener("DO_TRADEADVANCE",this._onADVANCE,this);
		application.addEventListener("DO_ALIQUERY",this._onALIQUERY,this);
		application.addEventListener("DO_TRADECANCEL",this._onTRDCEL,this);
		application.addEventListener("DO_CREATERECHARERECODE",this._onCreateRechareRecode,this);
    },
	enterpress:function(event){
		var e = event || window.event || arguments.callee.caller.arguments[0];		
		if(e && e.keyCode==27){ // 按 Esc 
			al.closeDialog()
		}else if(e && e.keyCode==13){ // enter 键
			al.createRechareRecode();
		}else {
			var values=jQuery("#recharemoney").val();//obj.value.replace(/[^\d.]/g,"");
			var reg1=/^[0-9]*[1-9][0-9]*$/;
			if(e.keyCode!=39 && e.keyCode!=40 && e.keyCode!=37 && e.keyCode!=38 && !reg1.test(values)){ 
				jQuery("#recharemoney").val(values.replace(/[^\d.]/g,''));
			}			
			//values+=String.fromCharCode(e.keyCode);	
			//var reg=/^(|([1-9]\d*))(\.\d{0,2})?$/;
			//if(!reg.test(values)){return false;}
			
			var smsnumber=0;
			var smsmoney=Math.round(parseFloat(values)*100)/100;
			if(smsmoney<1000){
				smsnumber=Math.ceil(smsmoney/0.1);
			}else{
				smsnumber=Math.ceil(smsmoney/0.08);
			}
			if(smsmoney>=0.1){
				jQuery("#recharenumber").html(smsnumber);
			}else{
				jQuery("#recharenumber").html("");
			}
			//jQuery("#recharemoney").val(smsmoney);
			return true;
		}
	},
	verifymoney:function(){
		var smsmoney=jQuery("#recharemoney").val();
		var ismakeout=jQuery("input[type='radio']:checked").val();
		if(isNaN(smsmoney)||!smsmoney){
			alert("请输入正确的金额！");
			var ele=jQuery("#recharemoney");
			ele.focus();
			ele.select();
			return false;
		}
		smsmoney=Math.round(parseFloat(smsmoney)*100)/100;
		if(smsmoney<=0){
			alert("请输入正确的金额！");
			var ele=jQuery("#recharemoney");
			ele.focus();
			ele.select();
			return false;
		}
		if(smsmoney<=0.1){
			alert("充值金额太小。");
			var ele=jQuery("#recharemoney");
			ele.focus();
			ele.select();
			return false;
		}
		var smsnumber=0;
		if(smsmoney<1000){
			smsnumber=Math.ceil(smsmoney/0.1);
		}else{
			smsnumber=Math.ceil(smsmoney/0.08);
		}
		if(smsnumber<=0){
			alert("请输入正确的金额！");
			var ele=jQuery("#recharemoney");
			ele.focus();
			ele.select();
			return false;
		}
		
		this.smsnumber=smsnumber;
		this.smsmoney=smsnumber;
		this.ismakeout=ismakeout
		jQuery("#recharenumber").html(smsnumber);
		return true;
	},
	//创建短信充值记录
	createRechareRecode:function(){
		/*this.smsmoney=jQuery("#recharemoney option:selected").val();
		this.smsnumber=jQuery("#recharemoney option:selected").attr("text");
		if(isNaN(this.smsmoney)||isNaN(this.smsnumber)){
			alert("请选择正确的金额！");
			return;
		}*/
		if(!al.verifymoney()){return;}
		var evt={};
		
        evt.command="nds.weixin.ext.AlipayRecharegeCommand";
        evt.callbackEvent="DO_CREATERECHARERECODE";
        var param={"money":this.smsmoney,"smsnumber":this.smsnumber,"ismakeout":this.ismakeout};
        evt.params=Object.toJSON(param);
        evt.method="advancecreate";
        this._executeCommandEvent(evt);
	},
	_onCreateRechareRecode:function(e){
		var data=e.getUserData();
		this.alipay=data;
		this.advancepay();
	},
	//支付宝下单
	advancepay:function(){
        var evt={};
        evt.command="nds.alipay.ext.Alipay_Execut";
        evt.callbackEvent="DO_TRADEADVANCE";
        var param={"fee":al.alipay.fee,"docno":al.alipay.docno,"subject":al.alipay.subject,"operid":al.alipay.operid,"product_code":"QR_CODE_OFFLINE","machineid":"","storetype":"1","storeid":al.alipay.storeid,"terminalid":"","notify_url":al.alipay.notify_url};
		param.key=al.alipay.key;
		param.partnerid=al.alipay.partnerid;
		param.sell_mail=al.alipay.sell_mail;
        evt.param=Object.toJSON(param);
        evt.method="advancecreate";
        this._executeCommandEvent(evt);
    },
	_onADVANCE:function(e){
        var data=e.getUserData();
		jQuery("#quickMark").attr({src:data.small_pic_url});
		jQuery("#createOrder").hide();
		jQuery("#printQuickMark").show();
    },
	querytrade:function(){
        var evt={};
        evt.command="nds.alipay.ext.Alipay_Execut";
        evt.callbackEvent="DO_ALIQUERY";
        var param={"docno":al.alipay.docno,"partnerid":al.alipay.partnerid,"key":al.alipay.key};
        evt.param=Object.toJSON(param);
        evt.method="querytrade";
		jQuery("#printQuickMark").hide();
		jQuery("#waitPay").show();
		jQuery("#search").attr({"disabled":"true"});
		this.isWaitePay=true;
        this._executeCommandEvent(evt);
    },
    _onALIQUERY:function(e){
        var data=e.getUserData();
		try{
			if(data.trade_status=="TRADE_SUCCESS"){
				jQuery("#waitPay").hide();
				jQuery("#paySuccess").show();
				return;
			}
			al.autoExecuteId=window.setTimeout("al.querytrade('"+al.alipay.docno+"')",1000);
		}catch(e){
			al.autoExecuteId=window.setTimeout("al.querytrade('"+al.alipay.docno+"')",1000);
		}
		return;
    },
	tradecancel:function(){
        var evt={};
        evt.command="nds.alipay.ext.Alipay_Execut";
        evt.callbackEvent="DO_TRADECANCEL";
        var param={"docno":al.alipay.docno,"partnerid":al.alipay.partnerid,"key":al.alipay.key};
        evt.param=Object.toJSON(param);
        evt.method="tradecancel";
        this._executeCommandEvent(evt);
    },
    _onTRDCEL:function(e){
		al.isPaySuccess=false;
        var data=e.getUserData();
		jQuery("#waitPay").hide();
		jQuery("#paySuccess").hide();		
		jQuery("#waitCancle").hide();
		jQuery("#cancleSuccess").show();
		jQuery("#closeRefund").focus();
    },
	reghargesummess:function(){
		//csi.saveregharge(this.smsmoney,this.smsnumber);
		//art.dialog.list['load_dialog'].close();
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		var artlist=w.art.dialog.list;
		if(artlist){
			for(att in artlist){
				artlist[att].close();
			}
		}
		w.pc.refreshGrid();
	},
    closeDialog:function(){
		//art.dialog.list['load_dialog'].close();
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if(!w){return;}
		var artlist=w.art.dialog.list;
		if(artlist){
			for(att in artlist){
				artlist[att].close();
			}
		}
		return false;
	},
    checkIsDate:function(month,date,year){
        if(parseInt(month,10)>12||parseInt(month,10)<1||parseInt(date,10)>31||parseInt(date,10)<1||parseInt(year,10)<1980||parseInt(year,10)>3000) {
            return false;
        }
        return true;
    },
    _executeCommandEvent :function (evt) {
        Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code <0){
				alert(result.message);
				if(al.isWaitePay){
					jQuery("#printQuickMark").show();
					jQuery("#waitPay").hide();
					jQuery("#search").removeAttr("disabled");
				}
            }else {
				al.isWaitePay=false;
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
    }
}
ALIPAY.main = function () {
    al=new ALIPAY();
};
jQuery(document).ready(ALIPAY.main);