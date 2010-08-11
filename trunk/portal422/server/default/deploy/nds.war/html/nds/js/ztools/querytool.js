/**
 *Edit by Robin 20100810
 *PORTAL界面 条件查询 工具类
 *提供 字段查询多选 等功能
 */
var qt=null;
var QUERYTOOL=Class.create();
QUERYTOOL.prototype={
    initialize: function() {
    },
    /**
     *用户需要在字段条件查询时（非日期，单对象及多对象查询）可以多选；
     *复制(如：EXCEL表格)类容即可达到效果。
     *此方法实现：弹出文本输入框；用户输入类容（复制）点击确定
     *将类容转换（回车转换为“,”）填入字段条件input框、
     *关闭文本输入框
     *@param clniptid 字段条件 input 框ID
     */
		toggle:function(clniptid){
				var e=jQuery("#"+clniptid);
				var top=e.css("top");
				top=parseInt(top,10);
				var left=e.css("left");
				left=parseInt(left,10);
				left-=240;
				if(left<0)left=0;
					var ele = Alerts.fireMessageBox(
				{
					"top":top,
					"left":left,
					"width": 255,
					"modal": true,
					title: gMessageHolder.EDIT_MEASURE
				});
				
				var str="<div style=\"border:1px solid #678FC2; width:250px; height:160px; font-size:12px; padding:3px; background:#DAE3EA;\">"+
								"<div style=\"font-size:14px; font-weight:bold; color:#000; height:24px; line-height:24px;\">输入内容</div>"+
								"<div><textarea id=\""+clniptid+"-ta\" cols=\"35\" rows=\"5\" style=\"font-size:12px; color:#000;\"></textarea>
								"</div><div style=\"height:24px; line-height:24px; text-align:center\">"+
								"<input type=\"button\" value=\"确定\" id=\""+clniptid+"-sure\" style=\"width:46px; height:20px; font-size:12px;\" />&nbsp;&nbsp;"+
								"<input type=\"button\" onclick=\"Alerts.killAlert($("+clniptid+"));\" name=\"Submit\" value=\"取消\" id=\""+clniptid+"-cancel\" style=\"width:46px; height:20px; font-size:12px;\" /></div></div>";
				ele.innerHTML=str;
				executeLoadedScript(ele);
				jQuery("#"+clniptid+"-sure").click(function(){
					var val=jQuery("#"+clniptid+"-ta").val();
					val=jQuery.trim(val);
					var vs=val.split("\n");
					for(var i=0;i<vs.length;i++){
						vs[i]=jQuery.trim(vs[i]);
					}
					jQuery("#"+clniptid).val(vs.join(","));
				});
		}
}
QUERYTOOL.main = function(){
    qt=new QUERYTOOL();
};
jQuery(document).ready(QUERYTOOL.main);