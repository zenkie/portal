jQuery(document).ready(function(){
var upinit={
	'sizeLimit':1024*1024 *1,
	'buttonText'	: '上传图片',
	'fileDesc'      : '上传文件(dat)',
	'fileExt'		: '*.dat;'
};
var para={
	"isThum":true,
	"width":600,
	"hight":600,
	"onsuccess":"jQuery(\"#photo\").attr(\"src\",\"$filepath$\")",
	"onfail":"alert(\"上传图片失败，请重新选择上传\");"	,
	"modname":"invitation"
};
fup.initForm(upinit,para,"btnUploadify");
});