<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	/**------获取参数---**/
	String ptype=request.getParameter("ptype");
	/**------获取参数 end---**/
	 String dialogURL=request.getParameter("redirect");
	 if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
		response.sendRedirect("/c/portal/login"+
			(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+
				java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
			return;
		}
	 if(!userWeb.isActive()){
		session.invalidate();
		com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
		response.sendRedirect("/login.jsp");
		return;
	 }
	TableManager manager=TableManager.getInstance();
	String tableId="AD_SITE_TEMPLATE";//需要读取的表
	Table table;
	HashMap<String, String> tempMap = new HashMap<String, String>();//用来存储首页模板的风格
	int clientId = userWeb.getAdClientId();
	table=manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("NAME").getId());
	query.addSelection(table.getColumn("IMGURL").getId());
	query.addSelection(table.getColumn("TPCLASS").getId());
	query.addSelection(table.getColumn("WX_TP_STYLE_ID").getId());
	query.addSelection(table.getColumn("WX_TP_STYLE_ID;NAME").getId());
	//添加过滤 区别使用模板
	query.addParam(table.getColumn("USETMP").getId(), ptype);
	
	int[] orderKey;//排序
	Column colOrderNo = table.getColumn("WX_TP_STYLE_ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	
	int[] orderKey2;
	Column colOrderNo2 = table.getColumn("TPCLASS");
	if(colOrderNo2!=null)orderKey2= new int[]{ colOrderNo2.getId()};
	else orderKey2= new int[]{ table.getAlternateKey().getId()};
	
	int[] orderKey3;
	Column colOrderNo3 = table.getColumn("NAME");
	if(colOrderNo3!=null)orderKey3= new int[]{ colOrderNo3.getId()};
	else orderKey3= new int[]{ table.getAlternateKey().getId()};
	
	
	query.setOrderBy(orderKey, true);//升序
	query.setOrderBy(orderKey2, true);
	query.setOrderBy(orderKey3, true);
	
	query.setRange(0, Integer.MAX_VALUE);
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);
	result= QueryEngine.getInstance().doQuery(query);	
	
	//查找公司默认模板
	String queryTemp = null;
	if(ptype.equals("home")){
		queryTemp = "select HOME_TMP,LIST_TMP,CLASS_TMP from WEB_CLIENT_TMP where AD_CLIENT_ID = "+ clientId;
	}else if(ptype.equals("mall")){
		queryTemp = "select HOME_TMP,MLIST_TMP,MCLASS_TMP from WEB_MAIL_TMP where AD_CLIENT_ID = "+ clientId;	
	}
	List li = QueryEngine.getInstance().doQueryList(queryTemp);
	ArrayList<String> listTemplate = new ArrayList<String>();	
	if(li.size()>0){
	int num = ((List)li.get(0)).size();
		for(int i = 0; i < num; i++){
			listTemplate.add(((List)li.get(0)).get(i).toString());
		}
	}
		
%>
<%!
private StringBuffer getAttributeDiv(QueryResult result,HashMap<String,String> tempMap,ArrayList<String> list,String ptype){
		String tempStyleId = "-1";//用来区别首页模板的风格
		StringBuffer homePreDiv = new StringBuffer();
		StringBuffer homeNextUl = new StringBuffer();//首页模板
		StringBuffer listTemplate = new StringBuffer();//列表模板
		StringBuffer channeltemplate = new StringBuffer();//类目模板
		homePreDiv.append("<div class='stylelist' id='tempTypeList'>");
		homeNextUl.append("<div id='tempTypecontent'>");
		listTemplate.append("<div class='tag-panel-content'><ul class='templatelist clearfix' id='temp1'>");
		channeltemplate.append("<div class='tag-panel-content'><ul class='templatelist clearfix' id='temp1'>");		
		try{
		String id=null,name=null,imgUrl=null;
		String tpclass=null,tpStyleId=null,tpStyleName=null;//表中的各个字段
		for (int j = 0; j < result.getRowCount(); j++) {
			result.next();			
			id = result.getObject(1).toString();
			name = result.getObject(2).toString();
			imgUrl = result.getObject(3).toString();
			tpclass = result.getObject(4).toString();//模板类型 1.首页 2.列表 3.类目
			tpStyleId = (result.getObject(5)!=null)?result.getObject(5).toString():"";
			tpStyleName = (result.getObject(6)!=null)?result.getObject(6).toString():"";
			if(tpclass.equals("HOME")){	
			if (!tempMap.keySet().contains(tpStyleId)&& tpStyleId != null) {
					if (!tempStyleId.equals(tpStyleId)){
						if(!tempStyleId.equals("-1"))homeNextUl.append(" </ul></div>");
						tempStyleId = tpStyleId;						
					}				
				tempMap.put(tpStyleId,tpStyleName);
				homeNextUl.append("<div class='tag-panel-list'><ul class='templatelist clearfix' id='temp1'>");
				homeNextUl.append(getImage(id,name,imgUrl,list,ptype));
			}else{
				homeNextUl.append(getImage(id,name,imgUrl,list,ptype));
			}
			}else if(tpclass.equals("LIST")){
				listTemplate.append(getImage(id,name,imgUrl,list,ptype));
			}else if(tpclass.equals("CLASS")){
				channeltemplate.append(getImage(id,name,imgUrl,list,ptype));
			}
			
		}
		homeNextUl.append("</ul></div></div>");
		listTemplate.append("</ul></div>");
		channeltemplate.append("</ul></div>");		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		//自定义排序 按id升序显示风格
		List<Entry<String, String>> infoIds = new ArrayList<Entry<String, String>>(tempMap.entrySet());
			Collections.sort(infoIds, new Comparator<Entry<String, String>>() {   
		    public int compare(Map.Entry<String, String> o1, Map.Entry<String, String> o2) {      
		        return (o1.getKey()).toString().compareTo(o2.getKey());
		    }
		}); 
		for (int i = 0; i < infoIds.size(); i++) {
		    Entry<String, String> entry = infoIds.get(i);
		    homePreDiv.append("<a id='"+entry.getKey()+"' href=''>"+entry.getValue()+"</a>");
		}
		homePreDiv.append("</div>");
		homePreDiv.append(homeNextUl);
		homePreDiv.append("</div>");
		homePreDiv.append(listTemplate);		
		homePreDiv.append(channeltemplate);
		return homePreDiv;
	}
	
	private StringBuffer getImage(String id,String name,String imgUrl,ArrayList<String> list,String ptype){
		StringBuffer img = new StringBuffer();
		String selectClass = "";
		if(list.contains(id)){
			selectClass = " selected";
		}
		img.append("<li onclick='st.choose_template(this,\""+ptype+"\")'><a href='javascript:void(0)' class='zz"+selectClass+"' id='tempImg")
		.append(id+"'><img src='"+imgUrl+"' class='templateimg'> <em class='templatechoose'>T"+name+"</em></a></li>");
		return img;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>模板选择</title>
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>

<script src="/html/nds/oto/sel_temple/js/tab.js"></script>
<script src="/html/nds/oto/sel_temple/js/select_template.js"></script>	
<link href="/html/nds/oto/sel_temple/css/style.css" rel="stylesheet" type="text/css">
<link href="/html/nds/oto/sel_temple/css/goodsCatg.css" rel="stylesheet" type="text/css">
<link href="/html/nds/oto/sel_temple/css/ssdp.css" rel="stylesheet" type="text/css">
<link href="/html/nds/oto/sel_temple/css/index.css" rel="stylesheet" type="text/css">
</head>
<body>
<input id="ad_client_id" type="hidden" value="<%=clientId%>">
    <div id="mainContent">  
		<h4 id="aeaoofnhgocdbnbeljkmbjdmhbcokfdb-mousedown">模板设置</h4>
        <div id="contentWrap">
            <div id="tabs" class="tag-panel">
                <div class="tag-panel-head" id="divTempHeader">
                    <a id="tab1" class="tag-panel-title tag-panel-iscurrent" >首页模板</a>
                    <a id="tab2" class="tag-panel-title" >列表模板</a>
                    <a id="tab3" class="tag-panel-title" >类目模板</a>
                </div>
                <div class="tag-panel-contnt1">
                    <div class="tag-panel-content show" id="list">                        
                        <%=getAttributeDiv(result,tempMap,listTemplate,ptype)%>                    
                </div>
            </div>
        </div>
    </div>
    <script>
        jQuery(function(){
            var tab = new Tab('#tabs');
			var opt={
			btnBox: '#tempTypeList',	//按钮包裹
			listBox: '#tempTypecontent',	//切换列表包裹
			btn: 'a',					//按钮
			list: '>div',					//列表
			btnActiveClass: 'selected',	//按钮切换的class
			listActiveClass: 'show'	};//列表切换的class
			var list = new Tab('.tag-panel-contnt1',opt);
			jQuery("#tempTypecontent").find(">div").eq(0).addClass("show");//显示首页第一个风格
			jQuery("#tempTypeList").find(">a").eq(0).addClass("selected");
        });
    </script>
</body>
</html>
