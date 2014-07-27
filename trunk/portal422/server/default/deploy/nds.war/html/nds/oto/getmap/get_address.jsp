<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" %>
<%@page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%
String pid=request.getParameter("id");
//System.out.print("get_address.jsp ->"+pid);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择地点</title>
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=1.2"></script>
	<script type="text/javascript" src="http://api.map.baidu.com/getscript?v=1.2&amp;ak=&amp;services=&amp;t=20130716024057"></script>
	<link rel="stylesheet" type="text/css" href="http://api.map.baidu.com/res/12/bmap.css">
</head>
<body>
<form method="get">
  <label style="font-size:12px">查找位置</label>：<input id="where" name="where" type="text" onkeypress="sear(document.getElementById(&#39;where&#39;).value);">
  <input id="hiddenText" type="text" style="display:none">
  <input type="button" value="搜索" onclick="sear(document.getElementById(&#39;where&#39;).value);">
  <label style="font-size:12px;color:#878787;">如：杭州古墩路</label>
  <input type="button" value="保存坐标" onclick="setaddress('<%=pid%>');">

  <br>
  <div style="width: 679px; height: 370px; border: 1px solid gray; overflow: hidden; position: relative; z-index: 0; background-color: rgb(243, 241, 236); color: rgb(0, 0, 0); text-align: left;" id="container">
  </div>
  <br>
  <input id="latlng" name="latlng" type="hidden">
</form>
<script type="text/javascript">
    var  setipcenter=false;
    var map = new BMap.Map("container"); //在指定的容器内创建地图实例
    map.setDefaultCursor("crosshair"); //设置地图默认的鼠标指针样式
    map.enableScrollWheelZoom(); //启用滚轮放大缩小，默认禁用。
    map.addControl(new BMap.NavigationControl());
    map.addEventListener("click", function (e) {//地图单击事件
        map.clearOverlays(); 
        document.getElementById("latlng").value = e.point.lat+","+e.point.lng;
        map.addOverlay(getMar(e.point.lng, e.point.lat)); //添加标注信息
    });
    window.onload=getMak;
	function setaddress(colid){
		//alert($('#latlng').val());
	   var w = window.opener;
		if(w==undefined)w= window.parent;
		if (w){
			//w.document.getElementById(colid);
			var gps=$("#latlng").val();
			if(w.jQuery("#ifr").length > 0){
				w.jQuery("#ifr").contents().find("#"+colid).prev().val(gps);
			}else{//这里用来设置门店位置				
				w.jQuery("#popup-iframe-0").attr("id","popup-iframe-1");
				w.jQuery("#popup-iframe-0").contents().find("#"+colid).prev().val(gps);
				w.jQuery("#popup-iframe-1").attr("id","popup-iframe-0");
			}
			
      }
	}
    function getMak()
    {
        if (GetQueryString("lx") != "" && GetQueryString("ly") != "")
        { 
            var lx=GetQueryString("lx");
            var ly= GetQueryString("ly");
            document.getElementById("latlng").value=lx+","+ly;

            map.addOverlay(getMar(lx, ly)); //添加标注信息

            var point = new BMap.Point(lx,ly);//定义一个中心点坐标

            map.centerAndZoom(point,30);//设定地图的中心点和坐标并将地图显示在地图容器中
        }
        else
        { 
            map.centerAndZoom("西安",5);
        }
    }

    function sear(result) {//地图搜索
        var local = new BMap.LocalSearch(map, {
            renderOptions: { map: map }
        });
        local.search(result);
    }

    function getMar(vlng, vlat) {
        var icon = new BMap.Icon("http://wxres.kun-hong.com/" + "images/markicon.png", new BMap.Size(25, 39), {
            anchor: new BMap.Size(12, 40),              //图标的定位点相对于图标左上角的偏移值  
            infoWindowAnchor: new BMap.Size(10, 0)      //信息窗口开启位置相对于图标左上角的偏移值  
        });
        var mkr = new BMap.Marker(new BMap.Point(vlng, vlat), {//创建一个图标实例  
            icon: icon
        });
        return mkr;
    }

    function GetQueryString(name) {

        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");

        var r = window.location.search.substr(1).match(reg);

        if (r != null && r[2] !=null) return unescape(r[2]); 

        else   return "";
    }
</script>
</body></html>
