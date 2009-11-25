	jQuery.noConflict();
	// mc object to dispaly messages delivered to user from u_note
	//
	
	var mc;//message control
	var MC=Class.create();
	MC.prototype={

	 initialize:function(){
	    jQuery(document.body).append("<div id=\"dialog\" title=\"通知\" style=\"display:none;background-color:white;\"><div id='dialog-dt' ></div></div>");
	    var date=new Date();
		jQuery.ajax({
		url: "http://192.168.1.102:100/jqdialouge/getMessage.jsp?t="+date.getTime(),
		success: function(response) {
			//alert(new XMLSerializer().serializeToString(response));
			var root = response.documentElement;

			// loop through all tree children
			var cs = mc.getChildren(root,"message");
			var str="<div style='height:150px;overflow-y:scroll;overflow-x:visible;'><table cellspacing='0' cellpadding='0'><thead><tr><th></th><th>优先级</th><th>上载时间</th><th>编号</th><th>标题</th></tr></thead><tbody>";
			var count=0;//count no. of most emergent message
			var priority;
			var index=0;
			for (var i = 0; i < cs.length; i++) {	
				index++;
				priority=mc.getChildValue(cs[i],"PRIORITYRULE");
				str+="<tr "+(priority=='1'?"style='background-color:#D2DFE9;'":"")+"><td style='border-bottom:1px dotted grey;'>"+index+"</td>";		
				if (priority=='1'){count++;str +="<td style='border-bottom:1px dotted grey;'>!!!</td>";}
				else if (priority=='2'){str+="<td style='border-bottom:1px dotted grey;'>!!</td>";}
				else str+="<td style='border-bottom:1px dotted grey;'></td>";
				str+="<td style='border-bottom:1px dotted grey;'>"+mc.getChildValue(cs[i],"CREATIONDATE").substr(0,10)+"</td>";
				str+="<td style='border-bottom:1px dotted grey;padding-left:5px;'>"+mc.getChildValue(cs[i],"NO")+"</td>";
				str+="<td style='border-bottom:1px dotted grey;padding-left:5px;' title='"+mc.getChildValue(cs[i],"DESCRIPTION")+"'>"+mc.getChildValue(cs[i],"TITLE")+"</td>";
				str+="</tr>";
			}
		      
			str+="</tbody></table></div>";
			jQuery("#dialog-dt").html(str);
			var title=jQuery("#dialog").attr("title");
			if (count>0)title+="  &nbsp; &nbsp;<span style='color:red;'>你有"+count+"条紧急消息必需马上处理!!!</span>";
			else title+="  &nbsp; &nbsp;<span >共有"+cs.length+"条需要确认.</span>";
			title+="&nbsp;<input type='button' value='立即确认' style='vertical-align:middle;padding-top:4px;cusor:pointer;position:relative;left:"+((count>0)?"50":"120")+"px;' onclick='mc.goto();'>";
			jQuery("#dialog").attr("title",title);
			var modal=(count>0)?true:false;
			mc.showMessages(modal);
			jQuery("dialog").css("overflow","scroll");
			jQuery("dialog").css("height","150px");
			if(!modal){setTimeout("mc.fadeMessage();",2000);}
		
		}, 
		error:function(xhr) {
        //alert('系統不能獲取通知');
		}
		});//end of ajax call

	 },//end of initialize
	 showMessages:function(modal) {
		var setting={
			//bgiframe: true,
			//modal: true,
			resizable:false,
			width:420,
			height:200,
			position:['right','bottom']
			
		};
		if(modal)setting.modal=true;
		jQuery("#dialog").dialog(setting);
	 },
	 fadeMessage:function(){
		jQuery("#dialog").parent().mouseenter(function(){
				jQuery("#dialog").parent().stop();
				jQuery("#dialog").parent().css('opacity',1);
				});
		jQuery("#dialog").parent().fadeOut(3000,function(){jQuery("#dialog").dialog('close');});
	 },
	 goto:function(){
		
		pc.navigate('u_note');
		jQuery("#dialog").dialog('close');
		
		
	},
	xml2Str:function(xmlNode){
	try {
      // Gecko- and Webkit-based browsers (Firefox, Chrome), Opera.
		return (new XMLSerializer()).serializeToString(xmlNode);
		}
		catch (e) {
     try {
        // Internet Explorer.
        return xmlNode.xml;
     }
     catch (e) {  
        //Other browsers without XML Serializer
        alert('Xmlserializer not supported');
		}
	 }
		return false;
	},

	getChildValue:function (node,nodename){
	  var value="";
	  for(var i=0; i<node.childNodes.length;i++){
		if (node.childNodes[i].tagName==nodename)value=node.childNodes[i].childNodes[0].nodeValue;
	  }
	  return value;
	},
    getChildren:function(node,nodename){
	  var childs=[];
	  for (var i=0;i<node.childNodes.length;i++){
		if (node.childNodes[i].tagName==nodename)childs.push(node.childNodes[i]);
	  }
	  return childs;
	}

};
	MC.main = function(){ mc=new MC(); },
    jQuery(document).ready(MC.main);