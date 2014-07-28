var readCount=0;
function readMessage(){
	var _command = "ObjectModify";	 //wx_message 15945 全部消息
	var _params = "{\"table\":15945,\"partial_update\":true,\"id\":"+replyid+",\"ISREAD\":Y}";
	jQuery.ajax({
	url: '/html/nds/schema/restajax.jsp',
	type: 'post',
	data:{command:_command,params:_params},
	success: function (data) {
		readCount++;
		var _data = eval("("+data+")");
		if (_data[0].code == 0) {
			
		} else {
			if(readCount<3){
				setTimeout('readMessage()',1000);
			}			
		}
	}					
});
}
jQuery(document).ready(readMessage);
	
	