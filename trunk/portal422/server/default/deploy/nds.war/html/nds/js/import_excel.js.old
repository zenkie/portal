var impxls;
ImportXLS = Class.create();
// define constructor
ImportXLS.prototype = {
	initialize: function() {
		$("#txt-param").css('display','none');
		$("#q_progress").attr("display", "none");
	},
	isFlashInstalled:function(){
		return false;//swfobject.getFlashPlayerVersion().major>9;
	},
	initForm:function(upinit,para){
		$("#btnImport").removeAttr('disabled');
		this._upinit=upinit;
		this._para=para;
		if(this.isFlashInstalled()){
			$("#fileInput1").uploadify({
				'uploader'      : '/html/nds/js/uploadify.swf',
				'script'        : '/control/importexcel',
				'cancelImg'     : '/html/nds/images/cancel.png',
				'folder'        : '/html/nds',
				'multi'         : false,
				'wmode'		: 'transparent',
				/*'buttonImg'	: '/html/nds/images/cancel.png',*/
				'sizeLimit'     : this._upinit.sizeLimit,
				'buttonText'	: this._upinit.buttonText,
				'fileDesc'      : this._upinit.fileDesc,
				'fileExt'       : '*.xls;*.csv;*.txt',
				onError: function (evt, b, c, errorObj) {
		         if (errorObj.info == 404)
		            alert('Could not find upload script.');
		         else
		            alert('error '+errorObj.type+": "+errorObj.info);
		         $("#btnImport").removeAttr('disabled');
				},
				onComplete:function(a,b,c,response,e){
					/*var ele = Alerts.fireMessageBox(
					{
						width: 550,height:300,
						modal: true,
						title: "Information",
						maxButton:false,
						closeButton:true
					});
					ele.innerHTML= response;*/
					$("#output").css("display","block");
					$("#whole").html(response);
					return true;
				},
				onAllComplete:function (evt, data) {
		         	if(data.filesUploaded>0){
		         		
		         	}
		         	$("#btnImport").removeAttr('disabled');
		         	return true;
				}
			});		
		}else{
			//flash not good	
			//$("#noflash").css("display","block");
		}
		$("#file_format_xls")[0].checked=true;
		this.updateFormat();
	},
	updateFormat:function(){
		var fmt=$("input[name='file_format']:checked").val();
		if(fmt=="xls"){
			$("#fmt-xls").css('display','block');
			$("#fmt-txt").css('display','none');
			$("#fmt-pd").css('display','none');
			$("#txt-param").css('display','none');
			$("#startRow").val("2");
			$("#start-column").css('display','inline');
			$("#start-skip").css('display','none');
		}else if(fmt=="txt"){
			$("#fmt-xls").css('display','none');
			$("#fmt-txt").css('display','block');
			$("#fmt-pd").css('display','none');
			$("#txt-param").css('display','block');
			$("#startRow").val("1");
			$("#start-column").css('display','none');
			$("#start-skip").css('display','none');
		}else if(fmt=="pandian"){
			$("#fmt-xls").css('display','none');
			$("#fmt-txt").css('display','none');
			$("#fmt-pd").css('display','block');
			$("#txt-param").css('display','none');
			$("#startRow").val("1");
			$("#start-column").css('display','none');
			$("#start-skip").css('display','none');
			
			$("#txt_type_fix").checked=true;
			//$("#txt_fix_len").value="20,5,1";
		}
	},
	updateTxtType:function(){
		var fmt=$("input[name='txt_type']:checked").val();
		if(fmt=="token"){
			$("#txt-token").css('display','block');
			$("#txt-fix").css('display','none');
			$("#collen").css('display','none');
			$("#start-column").css('display','inline');
			$("#start-skip").css('display','none');
			
		}else{
			$("#txt-token").css('display','none');
			$("#txt-fix").css('display','block');
			$("#collen").css('display','block');
			$("#start-column").css('display','none');
			$("#start-skip").css('display','inline');
		}
	},
	beginImport:function(){
		$("#btnImport").attr("disabled", "disabled");
		$("#whole").html('');
		$("#q_progress").attr("display", "block");
		var para=this._para;
		var a=new Array();
		if(para.partial_update){
			$("input[name='update_columns2']:checked").each(function(i){a.push($(this).val());});
			if(a.length==1){
				alert($("#selcol").html());
				$("#btnImport").attr("disabled", "");
				return;
			}
			para.update_columns= a;
			$("#update_columns").val(a.join(","));
		}
		
		var fmt=$("input[name='file_format']:checked").val();
		para.file_format=fmt;
		if(fmt!="xls"){
			para.file_format="txt";
			if(fmt=="pandian")para.txt_type="fix";
			else para.txt_type=$("input[name='txt_type']:checked").val();
			if(para.txt_type==undefined || para.txt_type=="" || para.txt_type=="undefined"){
				para.txt_type="token";
			}
			if(para.txt_type=="token" ){
				var t="";
				if($("#token_tab")[0].checked) t+="[\\t]";
				if($("#token_comma")[0].checked) t+="[,]";
				if($("#token_semi")[0].checked) t+="[;]";
				if($("#token_space")[0].checked) t+="[ ]";
				if($("#token_others")[0].checked) t+="["+ $("#token_other")[0].value +"]";
				para.txt_token=t;
			}else{
				var l="";
				if(fmt=="pandian"){
					l="20,5,0";
				}else{
					$("input[name='collen']").each(function(i){ 
						if(l!="") l+=",";
						if(isNaN($(this).val()) || parseInt($(this).val())<0 ) l+="0";
						else l+=parseInt($(this).val());
					});
				}
				para.txt_fix_len=l;
			}
			para.multiply_num=parseInt($("#multiply_num").val());
			if(para.multiply_num<=0)para.multiply_num=1;
		}
		para.startRow=parseInt($("#startRow").val());
		if(para.startRow<=0)para.startRow=1;
		//support startColumn 20100424 yfzhu
		para.startColumn=parseInt($("#start-column").val());
		if(para.startColumn<=0)para.startColumn=1;
		para.startSkip=parseInt($("#start-skip").val());
		if(para.startSkip<=0)para.startSkip=0;
		
		para.bgrun=$("#bgrun")[0].checked;
		if($("#update_on_unique_constraints").length>0)
			para.update_on_unique_constraints=$("#update_on_unique_constraints")[0].checked;
		
		if(!this.isFlashInstalled()){
			document.getElementById("txt_token").value=para.txt_token;
			document.getElementById("txt_fix_len").value=para.txt_fix_len;
			document.getElementById("form1").action="/control/importexcel";
			document.getElementById("form1").submit();
		}else{
			$('#fileInput1').uploadifySettings("scriptData",para,true);	
			$('#fileInput1').uploadifyUpload();
		}
 	}
};
ImportXLS.main = function () {
	impxls=new ImportXLS();
};
jQuery(document).ready(ImportXLS.main);
