var mujs=null;
var media=function(){}

media.prototype.inits=function(){
	this.imgalist=jQuery("#").val();
	if(!this.imgalist){this.imgalist=[];}
	this.upinit={
		'sizeLimit':1024*1024 *1,
		'buttonText'    : "上传图片",
		'fileDesc'      : "上传图片(dat)",
		'fileExt'       :'*.dat;'
	};
	this.upload_44444={
		"JSESSIONID":"4s3nc19p7bfb4",
		"isThum":false,
		"width":640,
		"hight":640,
		"onsuccess":"mujs.updateimage('$filepath$')",
		"onfail":"",
		"modname":"WX_APPENDGOODS"
	};
	this.table="WX_APPENDGOODS";
	fup.initForm(this.upinit,this.upload_44444,"upload_44444");
	this.binddeleteimage();
	this.initimage();
	jQuery("#media_position").on('click','.media-upload',function(){
		var ind  =jQuery("#media_position .media-upload").index(this);
		fup._para.onsuccess = "mujs.updateimage('$filepath$',"+ind+")";
		jQuery("#upload_44444").parent().find(":file:last").click();
	});
	
};
media.prototype.updateimage=function(imageaddress,ind){
	var list = jQuery("#imgList").find("img:eq("+ind+")");
//	list.each(function(ind){
	//	if(jQuery(this).attr("src")==""){
				list.attr("src",imageaddress);
				list.parent().addClass("meupload");
				imageaddress=imageaddress.substr(imageaddress.lastIndexOf('/')+1);
				mujs.imgalist[ind]=imageaddress;
//				return false;
//		}
//	});
	var stsr=JSON.stringify(mujs.imgalist).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\s*/g,"");
//	alert(stsr);
	jQuery("#productpics").attr("value",stsr);//mujs.imgalist.toString()
};

media.prototype.binddeleteimage=function(){	
	var spanlist = jQuery("#imgList").find("span");
	spanlist.each(function(ind){
		jQuery(this).click(function(){
		if(jQuery(this).prev().attr("src")!=""){
				jQuery(this).prev().attr("src","");
				jQuery(this).parent().removeClass("meupload");
	//			jQuery(this).hide();
				mujs.imgalist[ind]="";
				jQuery("#productpics").val((JSON.stringify(mujs.imgalist).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")).replace(/\s*/g,""));//mujs.imgalist.toString()
				return false;
				}
			});
	});
};

media.prototype.initimage=function(){
	 var listval=jQuery("#productpics").val();
	 try{
	 		listval=eval('('+listval+')');
	 }catch(e){
		listval=null;
	 }
	 if(!listval){
	 		return;
	 	}
	 this.imgalist = listval;//listval.split(',');
	 for(var i=0;i<this.imgalist.length;i++){ 
	 	if(this.imgalist[i]!=""){
	 		jQuery(".media-upload:eq("+i+")").addClass("meupload");
	 	var imgpath="/servlets/userfolder/"+this.table+"/"+this.imgalist[i];
		jQuery("#imgList").find("img:eq("+i+")").attr("src",imgpath);
	 } 	
 	 
 }
	//alert(imagelist);
//	console.log();
};

media.main=function(){
	mujs=new media();
	mujs.inits();
}
jQuery(document).ready(media.main);



