<%@ page language="java" import="java.util.*,nds.velocity.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
   String defaultClientWebDomain=conf.getProperty("webclient.default.webdomain");
   int defaultClientID= Tools.getInt(conf.getProperty("webclient.default.clientid"), 37);
   WebClient myweb=new WebClient(37, "","burgeon",false);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>首页</title> 
<style type="text/css">
body {
    font-size: 12px;
    background: #FFF;
    width: 100%; height: 100%;
    min-width: 1200px;
    overflow: hidden;
    margin: 0 auto;
    padding: 0;
	font-family: "微软雅黑" !important;
	font-weight: bold;
	color:#5C676D;
}
input{ outline: none;}
body img { border: none }
body ul {
    margin: 0;
    padding: 0;
}
body li { list-style: none }
.main-login {
    width: 710px;
    height: 450px;
    position: absolute;
    left: 50%;
    top: 50%;
    margin-left: -355px;
    margin-top: -225px;
}
.login {
    width: 364px;
    height: 330px;
    border: 2px solid #E0DFDF;
    margin: 0 auto;
}
.main-login-bot {
    width: 708px;
    height: 34px;
    background: url(images/logo.png) no-repeat;
    margin: 90px auto 0;
	background-position: 178px -2px;
}
.login1 {
    width: 291px;
    height: 44px;
    margin: 25px auto 0;
}
.login2 {
    width: 291px;
    height: auto;
    margin: 25px auto 0;
}
.yan_zhen{
    text-align: left!important;
}

.yan_zhen input{
    border-radius: 5px;
	width:150px;
	height:25px;
	background-color:#f6f6f6;
	font-size: 18px;
}
.yan_zhen b{
     height:26px; line-height: 26px; /*padding-right:20px*/
}
.login2 ul li {
    margin-top: 10px;
    text-align: center;
    font-size: 15px;
    font-family: "微软雅黑";
    font-weight: 700;
    color: #828282;
}
.login2 ul li a {
    color: #828282;
    text-decoration: none;
}
.login2 ul li a:hover {
    color: #1BA0E1;
    text-decoration: none;
}
.login_input_1 {
    width: 291px;
    height: 41px;
    background: url(images/login_06.png) no-repeat;
    text-indent: 50px;
    line-height: 20px;
    border: none;
}
.login_input_2 {
    width: 291px;
    height: 41px;
    background: url(images/login_08.png) no-repeat;
    text-indent: 50px;
    line-height: 20px;
    border: none;
}
.login_button_1 {
    width: 250px;
    height: 36px;
    background: #1670A5;
    color: #fff;
    font-family: 微软雅黑;
    font-size: 15px;
    font-weight: 700;
    border: none;
    cursor: pointer;
}
.login3 {
    width: 291px;
    height: 14px;
    margin-top: 10px;
    margin-left: 132px;
    text-align: center;
}
.login3 ul li {
    width: 14px;
    height: 14px;
    float: left;
    margin-left: 2px;
    display: inline;
}
.red,
.purple,
.green,
.dark-blue,
.light-blue,
.orange {
    width: 14px;
    height: 14px;
    display: block;
}
.red { background: #FD3738 }
.purple { background: #A257B4 }
.green {
    width: 14px;
    height: 14px;
    background: #41BB1A;
    display: block;
}
.dark-blue {
    width: 14px;
    height: 14px;
    background: #1670A5;
    display: block;
}
.light-blue {
    width: 14px;
    height: 14px;
    background: #1BA0E1;
    display: block;
}
.orange {
    width: 14px;
    height: 14px;
    background: #FE791E;
    display: block;
}
#container {
    position: relative;
    left: 0;
}
#top_alert_box {
    position: absolute;
    left: 100%;
    top: 0;
    margin-left: 0;
    width: 300px;
    height: 100%;
    font-family: 微软雅黑;
    color: #fff;
    background-color: #444;
}
#top_alert_box dl dt {
    height: 24px;
    line-height: 24px;
    text-indent: 40px;
    font-size: 14px;
    background-color: #444;
    background: rgba(55,55,55,.8) url(images/top_alert_arrow.png) no-repeat 10px 50%;
    border-bottom: 1px solid #333;
    border-top: 1px solid #666;
    cursor: pointer;
}
#top_alert_box dl dt a {
    float: right;
    display: none;
    margin: 2px 20px 0 0;
}
#top_alert_box dd:nth-child(2) { display: block }
#top_alert_box dl dd {
    display: none;
    overflow: auto;
}
#top_alert_box dl dd li {
    line-height: 30px;
    position: relative;
    cursor: pointer;
    padding: 0 6px 0 40px;
}
#top_alert_box dl dd li b {
    position: absolute;
    top: 12px;
    left: 20px;
    width: 6px;
    height: 6px;
    background-color: #0c76a8;
}
#top_alert_box dl dd li:hover { background-color: #999 }
#top_alert_box dl dd li:hover a { text-decoration: underline }
#top_alert_box dl dd li input {
    float: right;
    width: 14px;
    height: 14px;
    margin: 8px 20px 0 0;
}
.menu_show_arrow,
.menu_show_arrow1 {
    position: absolute;
    top: 50%;
    margin-top: -15px;
    cursor: pointer;
    z-index: 6;
}
#mail_nums {
    width: 14px;
    height: 14px;
    line-height: 14px;
    text-align: center;
    background-color: #09f;
    color: #fff;
    border-radius: 10px;
    position: absolute;
    left: 50%;
    top: -14px;
}
.menu_show {
    position: relative;
    width: 96%;
    min-width: 1100px;
    height: 214px;
    background:#1670a5;
    margin: 12px auto 0;
}
.menu_show_arrow {
    left: 0;
    width: 30px;
    height: 30px;
    background: url(images/left.png) no-repeat;
}
.menu_show_arrow1 {
    right: 0;
    width: 30px;
    height: 30px;
    background: url(images/right.png) no-repeat;
}
.menu_show_main {
    width: 100%;
    height: 100%;
    position: relative;
    margin: 0 auto;
}
.menu_show_main ul {
    height: 100%;
    width: 100%;
    display: table;
    position: absolute;
    left: 0;
    top: 0;
}
.menu_show_main ul li {
    display: table-cell;
    width: 100%;
    height: 100%;
    vertical-align: middle;
    text-align: center;
}
.menu_show_main ul li .span-box {
    width: 110px;
    height: 120px;
    display: inline-block;
    cursor: pointer;
}
.menu_show_main ul li .span-box:hover { background: #09537f }
.menu_show_main ul li .span-box a {
    color: #EEF9FF;
    text-decoration: none;
    font-size: 14px;
    font-family: 微软雅黑;
    font-weight: 700;
}
.menu_show_main ul li .span-box a:hover {
    color: #EEF9FF;
    text-decoration: none;
}
.menu_show_main ul li .span-box p { margin-top: 25px }
.index_main {
    width: 96%;
    height: auto;
    clear: both;
    margin: 10px auto 0;
}
.index_main-title {
    width: 200px;
    height: 20px;
    background: url(images/home_50.png) no-repeat left center;
    text-indent: 20px;
}
.index_main-table {
    width: 100%;
    margin-top: 10px;
}
.table01 td {
    border: 2px #EAEAEA solid;
    text-indent: 10px;
}
.nohover tr:hover { background: none!important }
.bk1 { background: #F7F7F7 }
#collect {
    position: absolute;
    left: -67px;
    top: 20px;
    width: 124px;
    text-align: left;
    color: #000;
    border: 1px solid #b4b9bd;
    z-index: 111;
    background-color: #f6f6f6;
}
#collect .til {
    font-size: 14px;
    line-height: 14px;
    text-indent: 20px;
    border-bottom: 1px solid #a8a8a8;
    position: relative;
    padding: 15px 0 6px;
}
#collect .til img {
    position: absolute;
    right: 8px;
    top: 12px;
}
#collect .con { padding: 0 0 5px 16px }
#collect .con dd {
    line-height: 12px;
    margin: 12px 0;
}
#collect .con dd span {
    display: inline-block;
    width: 78px;
    vertical-align: middle;
}
#collect .con dd input { vertical-align: middle }
#small_arrow {
    width: 13px;
    height: 6px;
    position: absolute;
    left: 73px;
    top: -6px;
    background: url(images/index_arrow.png);
    overflow: hidden;
    z-index: 888;
}
/* =============================================Pop_up=====================================================*/
.Pop_up {
    width: 928px;/*928px*/
    height: 588px;/*588px*/
    border: 1px #000 solid;
    display: inline-block;
    overflow: hidden;
    vertical-align: middle;
    background: #fff;
    -webkit-transition: all .5s ease;
    transition: all .5s ease;
}
.Pop_up-top {
    height: 28px; width: 100%;
    background: url(images/tanchu/tanchu_03.png) repeat-x;
}
.Pop_up-top-l {
    width: 200px;
    height: 28px;
    float: left;
    margin-left: 20px;
    display: inline;
    background: url(images/tanchu/tanchu_10.png) no-repeat left center;
    padding-left: 30px;
    line-height: 28px;
    font-weight: 700;
}
.Pop_up-top-r {
    width: 200px;
    height: 28px;
    float: right;
    text-align: right;
    padding-right: 10px;
}
.Pop_up-top-r a{
    display: inline-block;
    margin-right: -4px;
}
.Pop_up td{
    /*vertical-align:middle;*/
}
.Pop_up-bot {
    height:auto;
    background: #FFF;
    border-top: none;
}
.Pop_up-bot-l {
    width: 200px;
    height: 528px;
    float: left;
    margin-left: 10px;
    margin-top: 10px;
    display: inline;
}
#wrap{
    vertical-align: top;
    position: relative;
    overflow: hidden;
}
.Pop_up-bot-r {
    height: 482px;
    width: 96%;
    margin-left: 10px;
    position: relative;
    overflow: hidden;
    padding-top: 10px;
}
.Pop_up .out_scroll_btn_bar{
    position: absolute; right:6px; top:10px;
    height:528px; width:7px;    
}
.Pop_up .out_scroll_btn_bar .arrow_up,
.Pop_up .out_scroll_btn_bar .arrow_down
{
    display: block;
    border:3px solid transparent;
    border-bottom-color:#515151;
    margin-bottom:8px;
}
.Pop_up .out_scroll_btn_bar .arrow_center{
    height:82%;
    background-color: #e8e8e8;
    margin-bottom:8px;
    border-radius:3px;
    position: relative;
}
.Pop_up .out_scroll_btn_bar .arrow_center b{
    position: absolute; left:0; top:0;
    width:100%; height:90px;
    background-color: #b6b6b6;
    border-radius:3px;
}
.Pop_up .out_scroll_btn_bar .arrow_down{
    margin: 0px;
    border-top:none;
    border-top-color:#515151;
}
.Pop_up-bot-r1 {
    border: 1px #D4D4D4 solid;
}
.Pop_up-bot-r3 {
    margin-top: 10px;
    width: 100%;
}
.r3-01 {
    font-size: 12px;
}
.r3-01-l {
    width: 500px;
    height: 22px;
    float: left;
    margin-left: 10px;
    display: inline;
}
.r3-01-l lable{
    vertical-align: bottom;
}
.r3-01-l ol{
    display: inline-block;
    vertical-align: middle;
}
.r3-01-l ol li{
    display: inline-block;
    cursor: pointer;
}
.r3-01-r {
    width: 230px;
    height: 22px;
    float: right;
    text-align: right;
    line-height: 28px;
}
.r3-02 {
    width: 678px;
    height: auto;
}
.r3-03 {
    width: 678px;
    height: 26px;
    text-align: right;
    margin-top: 20px;
}
.table02 td {
    border: none;
    text-indent: 10px;
}
.table03 td {
    border: 1px #DFDFDF solid;
    text-align: center;
}
#table03{
    width: 690px; height: 234px;
    margin-top: 5px;
    overflow-x: scroll;
    overflow-y: hidden;
}
#table03 .nobor td{
    border: none;
}
#inset_scroll_window{
    height: 193px; width: 1200px;
    overflow-y:scroll;
    overflow-x: visible; 
}
.table04 td {
    border: 5px #fff solid; border-right: none;
    position: relative;
}
.table04 td a{
    position: absolute; left: 100px; top: 50%; margin-top: -9px;
}
.f7f7f7{
    background-color: #F7F7F7; text-align: center;
}
.sub_top {
    width: 100%;
    min-width: 950px;
    height: 56px;
    background: url(images/top-bk_02.png) repeat-x;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 9999;
}
*html,
*html body {
    background-image: url(about:blank);
    background-attachment: fixed;
}
*html .sub_top {
    position: absolute;
    z-index: 9999;
    left: expression(eval(document.documentElement.scrollLeft));
    top: expression(eval(document.documentElement.scrollTop));
}
.sub_top_left {
    width: 345px;
    padding-left: 20px;
    float: left;
    display: inline;
}
.content {
    min-width: 1250px;
    overflow-x: hidden;
    clear: both;
    width: 98%;
    margin: 66px auto 0;
}
.content_left {
    width: 50px;
    height: 100%;
    float: left;
    overflow: hidden;
}
.nav_left {
    width: 36px;
    height: 100%;
    float: left;
    background: #1670A5;
}
.nav_left a {
    width: 36px;
    height: 35px;
    display: block;
    background: url(images/icon_02.png) no-repeat;
    text-indent: -9999px;
}
.nav_left a.icon1-1 { background-position: 0 0 }
.nav_left a.icon1-2 { background-position: -36px 0 }
.nav_left a.icon1-3 { background-position: -72px 0 }
.nav_left a.icon1-1:hover { background-position: 0 -35px }
.nav_left a.icon1-2:hover { background-position: -36px -35px }
.nav_left a.icon1-3:hover { background-position: -72px -35px }
.nav_left a.icon2-1 { background-position: -108px 0 }
.nav_left a.icon2-2 { background-position: -144px 0 }
.nav_left a.icon2-3 { background-position: -180px 0 }
.nav_left a.icon2-4 { background-position: -216px 0 }
.nav_left a.icon2-5 { background-position: -252px 0 }
.nav_left a.icon2-6 { background-position: -288px 0 }
.nav_left a.icon2-1:hover { background-position: -108px -35px }
.nav_left a.icon2-2:hover { background-position: -144px -35px }
.nav_left a.icon2-3:hover { background-position: -180px -35px }
.nav_left a.icon2-4:hover { background-position: -216px -35px }
.nav_left a.icon2-5:hover { background-position: -252px -35px }
.nav_left a.icon2-6:hover { background-position: -288px -35px }
.nav_left a.icon3-1 { background-position: -324px 0 }
.nav_left a.icon3-2 { background-position: -360px 0 }
.nav_left a.icon3-3 { background-position: -396px 0 }
.nav_left a.icon3-4 { background-position: -432px 0 }
.nav_left a.icon3-5 { background-position: -468px 0 }
.nav_left a.icon3-6 { background-position: -504px 0 }
.nav_left a.icon3-7 { background-position: -540px 0 }
.nav_left a.icon3-8 { background-position: -576px 0 }
.nav_left a.icon3-1:hover { background-position: -324px -35px }
.nav_left a.icon3-2:hover { background-position: -360px -35px }
.nav_left a.icon3-3:hover { background-position: -396px -35px }
.nav_left a.icon3-4:hover { background-position: -432px -35px }
.nav_left a.icon3-5:hover { background-position: -468px -35px }
.nav_left a.icon3-6:hover { background-position: -504px -35px }
.nav_left a.icon3-7:hover { background-position: -540px -35px }
.nav_left a.icon3-8:hover { background-position: -576px -35px }
.nav_left a.icon4-1 { background-position: -612px 0 }
.nav_left a.icon4-2 { background-position: -648px 0 }
.nav_left a.icon4-1:hover { background-position: -612px -35px }
.nav_left a.icon4-2:hover { background-position: -648px -35px }
.nav_left a.icon5-1 { background-position: -684px 0 }
.nav_left a.icon5-1:hover { background-position: -684px -35px }
.nav_left a.icon6-1 { background-position: -720px 0 }
.nav_left a.icon6-2 { background-position: -756px 0 }
.nav_left a.icon6-3 { background-position: -792px 0 }
.nav_left a.icon6-4 { background-position: -828px 0 }
.nav_left a.icon6-5 { background-position: -864px 0 }
.nav_left a.icon6-6 { background-position: -900px 0 }
.nav_left a.icon6-7 { background-position: -936px 0 }
.nav_left a.icon6-8 { background-position: -972px 0 }
.nav_left a.icon6-9 { background-position: -1008px 0 }
.nav_left a.icon6-1:hover { background-position: -720px -35px }
.nav_left a.icon6-2:hover { background-position: -756px -35px }
.nav_left a.icon6-3:hover { background-position: -792px -35px }
.nav_left a.icon6-4:hover { background-position: -828px -35px }
.nav_left a.icon6-5:hover { background-position: -864px -35px }
.nav_left a.icon6-6:hover { background-position: -900px -35px }
.nav_left a.icon6-7:hover { background-position: -936px -35px }
.nav_left a.icon6-8:hover { background-position: -972px -35px }
.nav_left a.icon6-9:hover { background-position: -1008px -35px }
.nav_left a.icon7-1 { background-position: -1044px 0 }
.nav_left a.icon7-2 { background-position: -1080px 0 }
.nav_left a.icon7-3 { background-position: -1116px 0 }
.nav_left a.icon7-1：hover { background-position: -1044px -35px }
.nav_left a.icon7-2：hover { background-position: -1080px -35px }
.nav_left a.icon7-3：hover { background-position: -1116px -35px }
.nav_left a.icon8-1 { background-position: -1152px 0 }
.nav_left a.icon8-2 { background-position: -1188px 0 }
.nav_left a.icon8-3 { background-position: -1224px 0 }
.nav_left a.icon8-4 { background-position: -1260px 0 }
.nav_left a.icon8-5 { background-position: -1296px 0 }
.nav_left a.icon8-6 { background-position: -1332px 0 }
.nav_left a.icon8-7 { background-position: -1368px 0 }
.nav_left a.icon8-1：hover { background-position: -1152px -35px }
.nav_left a.icon8-2：hover { background-position: -1188px -35px }
.nav_left a.icon8-3：hover { background-position: -1224px -35px }
.nav_left a.icon8-4：hover { background-position: -1260px -35px }
.nav_left a.icon8-5：hover { background-position: -1296px -35px }
.nav_left a.icon8-6：hover { background-position: -1332px -35px }
.nav_left a.icon8-7：hover { background-position: -1368px -35px }
.nav_left a.icon9-1 { background-position: -1404px 0 }
.nav_left a.icon9-2 { background-position: -1440px 0 }
.nav_left a.icon9-3 { background-position: -1476px 0 }
.nav_left a.icon9-1：hover { background-position: -1404px -35px }
.nav_left a.icon9-2：hover { background-position: -1440px -35px }
.nav_left a.icon9-3：hover { background-position: -1476px -35px }
.nav_left a.icon10-1 { background-position: -1512px 0 }
.nav_left a.icon10-2 { background-position: -1548px 0 }
.nav_left a.icon10-3 { background-position: -1584px 0 }
.nav_left a.icon10-4 { background-position: -1620px 0 }
.nav_left a.icon10-5 { background-position: -1656px 0 }
.nav_left a.icon10-1：hover { background-position: -1512px -35px }
.nav_left a.icon10-2：hover { background-position: -1548px -35px }
.nav_left a.icon10-3：hover { background-position: -1584px -35px }
.nav_left a.icon10-4：hover { background-position: -1620px -35px }
.nav_left a.icon10-5：hover { background-position: -1656px -35px }
.nav_left a.icon11-1 { background-position: -1692px 0 }
.nav_left a.icon11-2 { background-position: -1728px 0 }
.nav_left a.icon11-3 { background-position: -1764px 0 }
.nav_left a.icon11-4 { background-position: -1800px 0 }
.nav_left a.icon11-5 { background-position: -1836px 0 }
.nav_left a.icon11-1：hover { background-position: -1692px -35px }
.nav_left a.icon11-2：hover { background-position: -1728px -35px }
.nav_left a.icon11-3：hover { background-position: -1764px -35px }
.nav_left a.icon11-4：hover { background-position: -1800px -35px }
.nav_left a.icon11-5：hover { background-position: -1836px -35px }
.nav_left a.icon12-1 { background-position: -1872px 0 }
.nav_left a.icon12-2 { background-position: -1908px 0 }
.nav_left a.icon12-3 { background-position: -1944px 0 }
.nav_left a.icon12-4 { background-position: -1980px 0 }
.nav_left a.icon12-1：hover { background-position: -1872px -35px }
.nav_left a.icon12-2：hover { background-position: -1908px -35px }
.nav_left a.icon12-3：hover { background-position: -1944px -35px }
.nav_left a.icon12-4：hover { background-position: -1980px -35px }
.nav_left a.icon13-1 { background-position: -2016px 0 }
.nav_left a.icon13-1：hover { background-position: -2016px -35px }
.nav_left a.icon14-1 { background-position: -2052px 0 }
.nav_left a.icon14-2 { background-position: -2088px 0 }
.nav_left a.icon14-1：hover { background-position: -2052px -35px }
.nav_left a.icon14-2：hover { background-position: -2088px -35px }
.nav_left a.icon15-1 { background-position: -2124px 0 }
.nav_left a.icon15-2 { background-position: -2160px 0 }
.nav_left a.icon15-1：hover { background-position: -2124px -35px }
.nav_left a.icon15-2：hover { background-position: -2160px -35px }
.nav_left a.icon16-1 { background-position: -2196px 0 }
.nav_left a.icon16-2 { background-position: -2232px 0 }
.nav_left a.icon16-1：hover { background-position: -2196px -35px }
.nav_left a.icon16-2：hover { background-position: -2232px -35px }
.nav_left a.icon17-1 { background-position: -2268px 0 }
.nav_left a.icon17-2 { background-position: -2304px 0 }
.nav_left a.icon17-3 { background-position: -2340px 0 }
.nav_left a.icon17-4 { background-position: -2376px 0 }
.nav_left a.icon17-5 { background-position: -2412px 0 }
.nav_left a.icon17-1：hover { background-position: -2268px -35px }
.nav_left a.icon17-2：hover { background-position: -2304px -35px }
.nav_left a.icon17-3：hover { background-position: -2340px -35px }
.nav_left a.icon17-4：hover { background-position: -2376px -35px }
.nav_left a.icon17-5：hover { background-position: -2412px -35px }
.nav_left a.icon18-1 { background-position: -2448px 0 }
.nav_left a.icon18-1：hover { background-position: -2448px -35px }
.nav_left a.icon18-2：hover { background-position: -2484px -35px }
.nav_left a.icon18-3：hover { background-position: -2520px -35px }
.nav_right {
    height: 100%;
    float: left;
    border-right: 1px #CFCFCF solid;
    position: relative;
}
.nav_right-tit {
    height: 29px;
    background: url(images/sub_nav_rt.png) no-repeat;
    line-height: 29px;
    text-indent: 40px;
}
.nav_right-con {
    overflow: hidden;
}
.nav_right .out_scroll_btn_bar{
    position: absolute; right:2px; top:29px;
    height:100%; width:7px;
}
.nav_right .out_scroll_btn_bar .arrow_up,
.nav_right .out_scroll_btn_bar .arrow_down
{
    display: block;
    border:3px solid transparent;
    /*border-right:none;*/
    border-bottom-color:#515151;
    margin-bottom:8px;
}
.nav_right .out_scroll_btn_bar .arrow_center{
    height:90%;
    background-color: #e8e8e8;
    margin-bottom:8px;
    border-radius:3px;
    position: relative;
}
.nav_right .out_scroll_btn_bar .arrow_center b{
    position: absolute; left:0; top:0;
    width:100%; height:90px;
    background-color: #b6b6b6;
    border-radius:3px;
}
.nav_right .out_scroll_btn_bar .arrow_down{
    margin: 0px;
    border-top:none;
    border-top-color:#515151;
}
.nav_right-con ul {
    padding-top: 15px;
    padding-bottom: 15px;
}
.nav_right-con ul li {
    width: 190px;
    text-indent: 30px;
    padding-top: 8px;
}
.nav_right-con ul li a {
    color: #333;
    text-decoration: none;
}
.nav_right-con ul li a:hover {
    color: #333;
    text-decoration: underline;
}
.content_right {
    position: relative;
    margin-left: 0;
    min-width: 990px;
    overflow: auto;
    overflow-x: hidden;
    width: 80.5%;
    height: 100%;
    float: left;
}
.content_right-title {
    width: 300px;
    height: 24px;
    float: left;
    line-height: 24px;
    font-size: 14px;
    font-weight: 700;
    font-family: 微软雅黑;
}
.con-r1 {
    border: 1px #ccc solid;
    margin-top: 20px;
    overflow: hidden;
}
.con-r1-top { text-align: center }
.con-r2 {
    width: 100%;
    height: 20px;
    margin: 10px 0;
    vertical-align: middle;
}
.con-r2-l {
    width: 50%;
    height: 22px;
    float: left;
    margin-left: 10px;
    display: inline;
}
.con-r2-r {
    height: 22px;
    float: right;
    line-height: 28px;
    margin-right: 12px;
}
.con-r3 {
    width: 100%;
    height: 22px;
    float: left;
    margin-top: 10px;
    line-height: 10px;
}
.table05 {
    width: 100%;
    border: none;
    font-size: 12px;
}
.table05 td {
    border: 5px #FFF solid;
    border-collapse: collapse;
    text-indent: 10px;
}
#page,
#page a {
    display: inline-block;
    vertical-align: middle;
}
#page a img { display: inline }
.table01,
.table02,
.table03,
.table04 {
    width: 100%;
    border-collapse: collapse;
    border: none;
    font-size: 12px;
}
.my_thead{
    background: #494944;
    color: #fff;
}
.my_thead:hover{
    background: #494944!important;
}
.my_thead td{
    border: none;
}
.table01 tr:hover,
.bk2,
.table03 tr:hover{ background: #d7e9f3;}
.nav_left a.icon0-1,
.nav_left a.icon18-2 { background-position: -2484px 0 }
.nav_left a.icon0-2,
.nav_left a.icon18-3 { background-position: -2520px 0 }
.nav_left a.icon0-1:hover,
.nav_left a.icon0-2:hover { filter: alpha(opacity=60) }

/*paco add begin*/
.l{
	font-size: 16px;
	color: #5C676D;
	font-family: "微软雅黑";
	font-weight: bold;
	padding:10px;
}	
	
.right_text{
	font-size: 18px;
	color: #5C676D;
	font-family: "微软雅黑";
	font-weight: bold;
}	
.lx {
	font-size:16px;
	padding:10px;
}
.lx a{
	font-size: 18px;
	color: #5C676D;
	font-family: "微软雅黑";
	font-weight: bold;
	position: relative;
	text-decoration: none;
	border-bottom: 2px solid #5C676D;
}	
/*paco add begin*/
</style>
<SCRIPT type=text/javascript>
function onReturn(event){
  if (!event) event = window.event;
  if (event && event.keyCode && event.keyCode == 13) submitForm();
}
function submitForm(){
	if(document.getElementById("login").value==""){ 
		alert("请输入会员用户名");
		return;
	}
	else if(document.getElementById("password1").value==""){
		alert("请输入密码");
		return;
	}
	else if(document.getElementById("verifyCode").value==""){
		alert("请输入验证码");
		return;
	}else if(document.getElementById("verifyCode").value.length!=4){
		alert("您的输入验证码的长度不对!");
		return;
	}
	document.fm1.submit();
	document.body.innerHTML=document.getElementById("progress").innerHTML;
}
</SCRIPT>
</head>
<body style="background:#F4F3F2;">
<div class="main-login">
	<div class="login">
		<div class="bar"></div>
		<form action="/loginproc.jsp" method="post" name="fm1">
			<input type="hidden" value="already-registered" name="cmd"/>
			<input type="hidden" value="already-registered" name="tabs1"/> 
			<c:choose>
				<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
					<div class="login1"><img src="images/login_03.png" /></div>
					<div style="margin: 50px 0 50px 60px;">
						<ul>
							<li>
								<div class="l"><%= LanguageUtil.get(pageContext, "current-user")%>:
								<span class="right_text"><%=userWeb.getUserDescription() %></span></div>
							</li>
							<li>
								<div class="lx">
									<%= LanguageUtil.get(pageContext, "enter-view") %>:&nbsp;<a href="/html/nds/portal/portal.jsp"><%= LanguageUtil.get(pageContext, "backmanager") %></a>&nbsp;,
									<%= LanguageUtil.get(pageContext, "or") %>:&nbsp;<a href="/c/portal/logout"><%= LanguageUtil.get(pageContext, "logout") %></a>
								</div><div></div>
							</li>
						</ul>
					</div>
					<div class="login3">
					  <ul>
						<li><a href="#"><span class="red"></span></a></li>
						<li><a href="#"><span class="purple"></span></a></li>
						<li><a href="#"><span class="green"></span></a></li>
						<li><a href="#"><span class="dark-blue"></span></a></li>
						<li><a href="#"><span class="light-blue"></span></a></li>
						<li><a href="#"><span class="orange"></span></a></li>
					  </ul>
					</div>
				</c:when>
				<c:otherwise>
					<%
					String  login ="";
					if(company==null){company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");}
					login =LoginAction.getLogin(request, "login", company);
					%> 
					<div class="login1"><img src="images/login_03.png" /></div>
					<div class="login2">
						<ul>
							<li><input  id="login" name="login" type="text"  class="login_input_1" value="<%=login %>" style="font-size: 18px;font-family: '微软雅黑';" placeholder="用户名"/></li>
							<li><input  id="password1" name="<%= SessionParameters.get(request, "password")%>" class="login_input_2" value="" type="password" style="font-size: 18px;font-family: '微软雅黑';" placeholder="密码"/></li>
							<li class="yan_zhen">
								<lable>
									<span>验证码</span>
									<input id="verifyCode" name="verifyCode" type="text" onKeyPress="onReturn(event)" value="" />
								</lable>
								<b><img id="chkimg" style="margin-bottom: 6px;" width="60" height="25" align="absmiddle" src="/servlets/vms" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" /> </b>
							</li>
							<li style="text-align:left;display:none;"><input type="checkbox" />记住密码 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#">找回密码</a></li>
							<li style="padding-top:15px;"><input type="button" class="login_button_1" value="登录" onclick="javascript:submitForm()"/></li>
						</ul> 
					</div><!--login2 end-->
					<div class="login3">
					  <ul>
						<li><a href="#"><span class="red"></span></a></li>
						<li><a href="#"><span class="purple"></span></a></li>
						<li><a href="#"><span class="green"></span></a></li>
						<li><a href="#"><span class="dark-blue"></span></a></li>
						<li><a href="#"><span class="light-blue"></span></a></li>
						<li><a href="#"><span class="orange"></span></a></li>
					  </ul>
					</div><!--login3  end-->
				</c:otherwise>
			</c:choose> 
		</form>
	</div><!--login  end-->
	<div class="main-login-bot" style="position:relative;">
		<span style="position: absolute;font-size: 12px;  font-family: &quot;微软雅黑&quot;;  font-weight: 700;  color: #828282;left: 250px;top: 5px;letter-spacing: 2px;">上海伯俊软件科技有限公司&nbsp;&nbsp;www.burgeon.cn</span>
	</div>
</div>	
<%@ include file="/inc_progress.jsp" %>
</body>
</html>
