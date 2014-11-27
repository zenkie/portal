var csi=null;
var companysmsinfo=function(){};
companysmsinfo.prototype.initialize=function(){
	this.smsinfo={};
	this.rechargediaid=null;
};
companysmsinfo.prototype.initsmsinfo=function(){
	if(!this.smsinfo||jQuery.isEmptyObject(this.smsinfo)){return;}
	jQuery("#createOrder #money").html(this.smsinfo.money);
	jQuery("#createOrder #canusenumber").html(this.smsinfo.canuse);
	jQuery("#createOrder #usednumber").html(this.smsinfo.used);
	jQuery("#createOrder #price").html(this.smsinfo.price);
};
companysmsinfo.prototype.recharge=function(){
	var url="/html/nds/oto/alipay/alipayQrcode.jsp";
	var options=$H({padding: 0,width:'700px',height:'370px',top:'7%',title:'短信充值',skin:'chrome',drag:true,lock:true,esc:true,effect:false/*,close:function close(){alert("dd");}*/});
	jQuery.ajax({
		url:url,
		type:"post",
		//data:{"category":val},
		success:function(data){
			options.content=data;
			csi.rechargediaid=art.dialog(options);
			//executeLoadedScript(data);
		},
		error:function(data){
			alert("error");
		}
	});
};
companysmsinfo.prototype.saveregharge=function(smsmoney,smsnumber){
	if(csi.rechargediaid){csi.rechargediaid.close();} 
	this.smsinfo.money+=smsmoney;
	this.smsinfo.canuse+=smsnumber;
	this.initsmsinfo();
};
companysmsinfo.prototype.closedia=function(){
	if(csi.rechargediaid){csi.rechargediaid.close();}   
};

companysmsinfo.main=function(){
	csi=new companysmsinfo();
	csi.initialize();
};