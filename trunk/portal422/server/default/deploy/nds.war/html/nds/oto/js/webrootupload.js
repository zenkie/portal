var fup;
FileUpload = Class.create();
// define constructor
FileUpload.prototype = {
	initialize: function() {
		//this methond will be called when class initialized
	},
	initForm:function(upinit,para,colid){
		this._upinit=upinit;
		this._para=para;
		jQuery("#"+colid).uploadifive({
			'removeCompleted' : true,
			'uploadScript'      : '/servlets/binserv/UploadforWebroot',
			'folder'        : '/html/nds',
			'multi'         : false,
			'buttonText'	: this._upinit.buttonText,
			'formData'	: this._para,
			'method'   : 'post',
			onError: function (evt) {
	            alert('error :'+evt);
			},
			onUploadComplete: function(a,b){
				jQuery("#whole").html(b);
				return true;
			}
		});
	},
	
	beginUpload:function(){
		var para=this._para;
		//jQuery('#fileInput1').Settings("scriptData",para,true);	
		jQuery('#fileInput1').uploadifive('upload'); }
};
FileUpload.main = function () {
	fup=new FileUpload();
};
jQuery(document).ready(FileUpload.main);
