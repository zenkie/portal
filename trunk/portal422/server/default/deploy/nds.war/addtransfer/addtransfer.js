var dist=null;
var DIST=Class.create();
DIST.prototype={
    initialize: function() {
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
        dwr.util.setEscapeHtml(false);
        this.windowLocation=window.location;
        //款号-颜色名字数组
    	  this.styleAndColorName=new Array();
    	  //款号-颜色json数据 styleAndColorDataItem:{"AS001-红色":[{item},{}……],"AS002-绿色":[{item},{}……]}
        this.styleAndColorDataItem={};
        //左边款号-颜色的innnerhtml
        this.style_color_name="";
        this.status=0;
        this.tonext=0;
        this.i=null;
        this.transresult=new Array();
        /** A function to call if something fails. */
        dwr.engine._errorHandler =  function(message, ex) {
            while(ex!=null && ex.cause!=null) ex=ex.cause;
            if(ex!=null)message=ex.message;// dwr.engine._debug("Error: " + ex.name + "," + ex.message+","+ ex.cause.message, true);
            if (message == null || message == "") alert("A server error has occured. More information may be available in the console.");
            else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
            else alert(message);
        };
        application.addEventListener( "DO_QUERY", this._onLoadMetrix, this);
        application.addEventListener("DO_SAVE",this._onsaveDate,this);
        application.addEventListener("RELOAD",this._onreShow,this);
    },
    queryObject: function(){
    	  
    	  this.status=0;
        var evt={};
        evt.callbackEvent="DO_QUERY";
        var load_type=$("load_type").value;
        var reg=/^\d{8}$/;
        var m_addtransfer_id=$("m_addtransfer_id").value||-1;
       
        if(!$("column_26993").value){
              alert("店仓不能为空！");
              return;
         }
        var store_fliter=$("column_26993").value;
        
        if(!$("column_26994").value){
              alert("款号不能为空！");
              return;
        }
        var product_filter=$("column_26994").value;
        
        var billdatebeg=$("column_26996").value.strip();
        var year=billdatebeg.substring(0,4);
        var month=billdatebeg.substring(4,6);
        var date=billdatebeg.substring(6,8);
        var beg=month+"/"+date+"/"+year;
        if(!this.checkIsDate(month,date,year)||!reg.test(billdatebeg)){
                alert("开始日期格式不对！请输入8位有效数字。");
                return;
         }
        var billdateend=$("column_26997").value.strip();
        var year1=billdateend.substring(0,4);
        var month1=billdateend.substring(4,6);
        var date1=billdateend.substring(6,8);
        var end=month1+"/"+date1+"/"+year1;
        if(!this.checkIsDate(month1,date1,year1)||!reg.test(billdateend)){
                alert("结束日期格式不对！请输入8位有效数字。");
                return;
         }
        
        var billdate=$("column_26995").value.strip();
        var year=billdate.substring(0,4);
        var month=billdate.substring(4,6);
        var date=billdate.substring(6,8);
        var beg=month+"/"+date+"/"+year;
        if(!this.checkIsDate(month,date,year)||!reg.test(billdate)){
            alert("日期格式不对！请输入8位有效数字。");
            return;
        }
        var docno=$("doc_no").value||-1; 
        var param={"docno":docno,"store_fliter":store_fliter,"product_filter":product_filter,"billdate":parseInt(billdate,10),"billdatebeg":parseInt(billdatebeg,10),"billdateend":parseInt(billdateend,10),"load_type":load_type,"m_addtransfer_id":m_addtransfer_id };
        evt.param=Object.toJSON(param);
       // alert(Object.toJSON(evt.param));
        evt.command="DBJSON";
        evt.table="m_addtransfer";
        evt.action="distribution";
        evt.permission="r";
        this.transresult.length=0;
        this._executeCommandEvent(evt);
    },
    saveDate:function(type){
       if($("orderStatus").value=="2"){
            alert("该单据已提交，不可再进行操作！");
            return;
        }
        var evt={};
        evt.command="DBJSON";
        evt.callbackEvent="DO_SAVE";
        if(type=='ord'){
            if(!confirm("单据提交不可修改！确认提交？")){
                return;
            }
        }

        var reg=/^\d{8}$/;
        var distdate=jQuery("#column_26995").val();
        distdate=distdate.strip();
        var year2=distdate.substring(0,4);
        var month2=distdate.substring(4,6);
        var date2=distdate.substring(6,8);
        var dist=month2+"/"+date2+"/"+year2;
        if(!this.checkIsDate(month2,date2,year2)||!reg.test(distdate)){
            alert("调拨日期格式不对！请输入8位有效数字。");
            return;
        }
        /*end*/
        var m_addtransfer_id=$("m_addtransfer_id").value||-1;
        var m_item=new Array();

       if(this.transresult.length>0){
           for(var i=0;i<this.transresult.length;i++){
        	if(parseInt(this.transresult[i].transcount,10)!=0){
        		var ii={};
        		ii.c_orig_id=this.transresult[i].c_orig_id;
        		ii.c_dest_id=this.transresult[i].c_dest_id;
        		ii.xmlns=this.transresult[i].xmls;
        		ii.color=this.transresult[i].color;
        		ii.size=this.transresult[i].sise;
        		ii.barcode=this.transresult[i].barcode;
        		ii.transcount=parseInt(this.transresult[i].transcount,10);
        		ii.mathround=this.transresult[i].mathround;
        		m_item.push(ii);
        	}
        }
        }
        

        var param={};
        param.type=type;  		
        param.docno=$("doc_no").value||-1;         		
        param.m_addtransfer_id=m_addtransfer_id;
        param.m_item=m_item;
        param.distdate=distdate;
        evt.param=Object.toJSON(param);
       // alert(Object.toJSON(evt.param));
        evt.table="m_addtransfer";
        evt.action="save";
        evt.permission="r";
        evt.isclob=true;
         
        this._executeCommandEvent(evt);
    },
    reShow:function(){
        var evt={};
        evt.command="DBJSON";
        evt.callbackEvent="RELOAD";
        var m_addtransfer_id=$("m_addtransfer_id").value||"-1";
        var param={"docno":-1,"store_fliter":-1,"product_filter":-1,"billdate":-1,"billdatebeg":-1,"billdateend":-1,"load_type":"reload","m_addtransfer_id":parseInt(m_addtransfer_id,10) };
        evt.param=Object.toJSON(param);
        evt.table="m_addtransfer";
        evt.action="distribution";
        evt.permission="r";
        this._executeCommandEvent(evt);
    },
    _onreShow:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        $("doc_no").value=ret.docno||"【系统维护】";
        $("column_26993_fd").value=ret.store_fliter.substring(ret.store_fliter.indexOf("<desc>")+6,ret.store_fliter.indexOf("</desc>"))||"(可用 = Y)";
        $("column_26994_fd").value=ret.product_filter.substring(ret.product_filter.indexOf("<desc>")+6,ret.product_filter.indexOf("</desc>"))||"";
        $("column_26996").value=ret.billdatebeg||"";
        $("column_26997").value=ret.billdateend||"";
        $("column_26995").value=ret.billdate||"";
        $("query_button").style.display='none';
        $("column_26993_link").style.display='none';
        $("column_26994_link").style.display='none';
        $("str_coolButton").style.display='none';
        $("end_coolButton").style.display='none';
        var status=ret.status;
        $("orderStatus").value=status;
        if(status=="2"){
           $("submitImge").style.display=""; 
        }
        this.transresult=ret.m_item;
        this._onLoadMetrix(e);
    },
    _onsaveDate:function(e){
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
        if(ret.data=="ok"){
            this.status=0;
            $("isChanged").value="false";
            jQuery("#query_button").hide();
            alert("保存成功！");
            window.location.href="/addtransfer/index.jsp?&&fixedcolumns=&id="+ret.m_addtransfer_id;
            
        }else if(ret.data=="yes"){
            this.status=0;
            alert("提交成功！");
            $("isChanged").value="false";
            window.self.close();
        }else{
            alert("出现错误！可能原因："+ret.data);
        }
    }, 
   _onLoadMetrix:function(e){
   	    var datastart=new Date();
        window.self.onunload=function(){
               var e=window.opener||window.parent;
               e.setTimeout("pc.doRefresh()",1);
         }
        dwr.util.useLoadingMessage(gMessageHolder.LOADING);
         this.styleAndColorName=new Array();
    	  //款号-颜色json数据 styleAndColorDataItem:{"AS001-红色":[{item},{}……],"AS002-绿色":[{item},{}……]}
        this.styleAndColorDataItem={};
        //左边款号-颜色的innnerhtml
        this.style_color_name="";
        this.status=0;
        this.tonext=0;
        this.i=null;
        $("load-s1-right").innerHTML="";
        $("style_color_name").innerHTML="";
       
        var data=e.getUserData();
        var ret=data.jsonResult.evalJSON();
         $("diffDate").value=ret.daydiff||1;
        var dataArray= ret.transDataItem;
       // alert(Object.toJSON(ret));
        if(dataArray.length==0){
            $("load-s1-right").innerHTML="<div style='font-size:20px;color:red;text-align:center;font-weight:bold;vertical-align:middle'>没有数据！</div>";
            return;
        }
       
       //界面赋值
        $("doc_no").value=ret.docno||"【系统维护】";
        for(var i=0;i<dataArray.length;i++){
        	var xmlsAndColor=dataArray[i].xmls+'---'+dataArray[i].color;
        	if(!this.styleAndColorName.contains(xmlsAndColor)){
        		this.styleAndColorName.push(xmlsAndColor);
        		}
        	}
        	
        	 //款号-颜色json数据 styleAndColorDataItem:["AS001-红色":[{item},{}……],"AS002-绿色":[{item},{}……]]
          for(var i=0;i<this.styleAndColorName.length;i++){
            var styleAndColorArray=new Array();
          	 for(var j=0;j<dataArray.length;j++){
          	 //	alert(this.styleAndColorName[i]);
          	 	//alert(dataArray[j].xmls+'---'+dataArray[j].color);
          	 	if(this.styleAndColorName[i] == dataArray[j].xmls+'---'+dataArray[j].color){
          	 		 styleAndColorArray.push(dataArray[j]);
          	 	 }
          	 	}
          	 	this.styleAndColorDataItem[this.styleAndColorName[i]]=styleAndColorArray;
          	}
        	//alert(Object.toJSON(this.styleAndColorDataItem));
        //画出左边界面  
        
       
        	for(var i=0;i<this.styleAndColorName.length;i++){//(i==0?"style='background:#8db6d9'":"")+
        		this.style_color_name+="<li onclick='javascript:dist.showcontent(\""+this.styleAndColorName[i]+"\");this.style.backgroundColor=\"#8db6d9\"; this.style.color=\"white\";' "+
			                              (i==0?" style='background:#8db6d9;color:white;'":"")+"><div  class=\"span-130\">"+this.styleAndColorName[i].split('---')[0]+"</div><div class=\"span-50\">"+this.styleAndColorName[i].split('---')[1]+"</div></li>";
        	}
      	$("style_color_name").innerHTML=this.style_color_name;
        $("showStyle").value="metrix";
       
        this.drawTableByStyleAndColorName(this.styleAndColorName[0]);
        this.autoView1();
        if($("orderStatus").value=="2"){
            jQuery("#con_two_1>table td input").attr("disabled","true");
        }
        var dataend=new Date();
        try{
            console.log("create page time:"+(dataend.getSeconds()-datastart.getSeconds()));
        }catch(e){
        }

   	
   	},
   	//产生20位随机数
   	transResultMathRount:function(){
   		var rnd="";
   		for(var i=0;i<20;i++){
   			 rnd+=Math.floor(Math.random()*10);
   			}　
   		 return rnd;
   		},
   	showcontent:function(styleandcolorname,type){
   		  var lies=$("style_color_name").getElementsByTagName("li");
        var tabs=$("load-s1-right").getElementsByTagName("table");
				if(type!="yes"){
					for(var d=0;d<lies.length;d++){
						lies[d].style.backgroundColor="";
						lies[d].style.color="";
					}
				}
   		 this.drawTableByStyleAndColorName(styleandcolorname);
   		 this.autoView1();
   		 if($("orderStatus").value=="2"){
            jQuery("#con_two_1>table td input").attr("disabled","true");
        }
   		},
   	 //画右边界面 第一次加载界面，画第一个款号  styleAndColorDataItem  return arry
   	drawTableByStyleAndColorName:function(styleAndColorName){
   		 var load_s1_right="";
   		 //款号和颜色相同的放在一个array中
   		 var styleAndColorData= this.styleAndColorDataItem[styleAndColorName];
   		// styleAndColorData=this.orderByStoreSaleCount(styleAndColorData,"asc");
   		 //店仓相同的放在一个array中  styleAndColorAndStoreName 所有同款号，同颜色的店仓名称
   		 var styleAndColorAndStoreName=new Array();
   		 for(var i=0;i<styleAndColorData.length;i++){
   		 	if(!styleAndColorAndStoreName.contains(styleAndColorData[i].storename)){
   		 		styleAndColorAndStoreName.push(styleAndColorData[i].storename);
   		 		}
   		 	}
   		 var styleAndColorAndStoreDateItem={};
   		 for(var i=0;i<styleAndColorAndStoreName.length;i++){
   		 	var tempArray=new Array();
   		 	for(var j=0;j<styleAndColorData.length;j++){
   		 		if(styleAndColorAndStoreName[i]==styleAndColorData[j].storename){
   		 			tempArray.push(styleAndColorData[j]);
   		 			}
   		 		}
   		 		var tempstorename= "storename-"+styleAndColorAndStoreName[i];
   		 		styleAndColorAndStoreDateItem[tempstorename]=tempArray;
   		 	}
   		 //款号 颜色相同，依据日销量，把店仓排序
   		 for(var i=0;i<styleAndColorAndStoreName.length;i++){
   		 	  var tempstorename= "storename-"+styleAndColorAndStoreName[i];
   		 	  var tempItem=styleAndColorAndStoreDateItem[tempstorename];
   		 	  var tempsaletotal=0;
   		 	  for(var j=0;j<tempItem.length;j++){
   		 	  	tempsaletotal+=parseInt(tempItem[j].qtysale,10);
   		 	   }
           styleAndColorAndStoreName[i]=styleAndColorAndStoreName[i]+"-tot-"+tempsaletotal;
   		 	}
   		  styleAndColorAndStoreName=this.orderByStoreSaleCount(styleAndColorAndStoreName,"asc");
   		 	//每个店仓下面所有条码信息  styleAndColorAndStoreDateItem
   	//	 	alert(Object.toJSON(styleAndColorAndStoreDateItem));
   		 //Tab1   调入调出按钮
   		 load_s1_right+="<div class=\"s1-right-t\" ><ul>"+ 
        "<li id=\"two1\" onmouseup=\"dist.setTab('two',1,2)\" class=\"s1-hover\"><a href=\"#\">调出和调入</a></li>"+
        "<li id=\"two2\" onmouseup=\"dist.setTab('two',2,2)\"><a href=\"#\">调拨结果</a></li></ul></div>";
      //调出table
        var dayDiff=parseInt($("diffDate").value,10);
        load_s1_right+="<div id=\"con_two_1\" class=\"s1-right-m s1-hover\" >";
        load_s1_right+="<table border=\"1\" id=\"out_trans_table\" class=\"table_s01\">";
        
        
        load_s1_right+="<tr>"+
          " <td width=\"25\" rowspan=\""+(styleAndColorAndStoreName.length*4+1)+"\" class=\"td_s00 span-black span-blod\"><p>调</p><p>出</p></td>"+
          
          " <td width=\"40\" height=\"20\" class=\"td_s01 span-white span-blod\">选择</td>"+
          " <td width=\"180\" class=\"td_s01 span-white span-blod\">店仓</td>"+
          " <td width=\"70\" class=\"td_s01 span-white span-blod\">日均销量</td>"+
          " <td width=\"70\" class=\"td_s01 span-white span-blod\">库存</td>"+
          " <td width=\"90\" class=\"td_s02 span-black span-blod\">尺寸</td>";
          for(var i=0;i<styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[0]].length;i++){
          	 load_s1_right+= " <td width=\"80\" class=\"td_s02 span-black span-blod\">"+styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[0]][i].size+"</td>";
          	}
         load_s1_right+="</tr>";
			   for(var i=0;i<styleAndColorAndStoreName.length;i++){
						     var dataItem= 	styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[i]];
						     var qtystorage=0;
						     var qtysale=0;
						     for(var j=0;j<dataItem.length;j++){
						       qtysale+=parseInt(dataItem[j].qtysale,10);
						       qtystorage+=	parseInt(dataItem[j].qtystorage,10);
						     	}
						      load_s1_right+="<tr>"+
			          
			          " <td rowspan=\"4\" class=\"td_s04\"><input type=\"checkbox\" name=\"out_store\" onclick=\"dist.storeValidate('out_store_"+styleAndColorAndStoreName[i]+"')\" id=\"out_store_"+styleAndColorAndStoreName[i]+"\""+"/></td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+styleAndColorAndStoreName[i]+"</td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+this.toDecimal(qtysale/dayDiff)+"</td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+qtystorage+"</td>"+
			          " <td height=\"20\" class=\"td_s03\">可配量</td>";
			
			          for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s03\" <div id=\"can_"+dataItem[j].storename+"_"+dataItem[j].size+"\">"+dataItem[j].qtycan+"</div></td>";
			          	}
			       load_s1_right+= " </tr>"+
			       " <tr>"+
			          " <td height=\"20\" class=\"td_s06\">本次调出</td>";
			           for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s06\"><input barcode=\""+dataItem[j].barcode+"\"  isInOrOut=\"out\" oldvalue=\"0\" xmls=\""+dataItem[j].xmls+"\" color=\""+dataItem[j].color+"\"  out_store=\"out_store_"+dataItem[j].storename+"\" store=\""+dataItem[j].storename+"\" sise=\""+dataItem[j].size+"\" type=\"text\" class=\"input_s01\"  value=\"0\" /></td>";
			          	}
			      load_s1_right+= " </tr>"+
			        "<tr>"+
			          " <td height=\"20\" class=\"td_s07\">总调出</td>";
			           for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s07\"><div id=\"out_"+dataItem[j].storename+"_"+dataItem[j].size+"\">"+dataItem[j].tot_qtyout+"</td>";
			          	}
			       load_s1_right+= "</tr>"+
			       " <tr>"+
			          " <td height=\"20\" class=\"td_s05\">余量</td>";
			          for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s05\"><div id=\"rem_"+dataItem[j].storename+"_"+dataItem[j].size+"\">"+dataItem[j].qtyrem+"</div></td>";
			          	}
			       load_s1_right+= "</tr>";
			 	}
      
        
        
        load_s1_right+="</table>"
      //确定调拨按钮
        load_s1_right+="<table width=\"865\" border=\"0\">";
        load_s1_right+="<tr height=\"40\"><td align=\"center\"><a onclick=\"dist.makeOrder()\" href=\"#\"><img src=\"images/s1-search_13.png\" /></a></td></tr>";
        load_s1_right+="</table>";
      //调入table
        load_s1_right+="<table border=\"1\" id=\"in_trans_table\" class=\"table_s01\">";

         load_s1_right+="<tr>"+
          " <td width=\"25\" rowspan=\""+(styleAndColorAndStoreName.length*4+1)+"\" class=\"td_s00_a span-black span-blod\"><p>调</p><p>入</p></td>"+
          
          " <td width=\"40\" height=\"20\" class=\"td_s01 span-white span-blod\">选择</td>"+
          " <td width=\"180\" class=\"td_s01 span-white span-blod\">店仓</td>"+
          " <td width=\"70\" class=\"td_s01 span-white span-blod\">日均销量</td>"+
          " <td width=\"70\" class=\"td_s01 span-white span-blod\">库存</td>"+
          " <td width=\"90\" class=\"td_s02 span-black span-blod\">尺寸</td>";
          for(var i=0;i<styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[0]].length;i++){
          	 load_s1_right+= " <td width=\"80\" class=\"td_s02 span-black span-blod\">"+styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[0]][i].size+"</td>";
          	}
         load_s1_right+="</tr>";
			   for(var i=(styleAndColorAndStoreName.length-1);i>=0;i--){
						     var dataItem= 	styleAndColorAndStoreDateItem["storename-"+styleAndColorAndStoreName[i]];
						      var qtystorage=0;
						      var qtysale=0;
						      for(var j=0;j<dataItem.length;j++){
						       qtysale+=parseInt(dataItem[j].qtysale,10);
						       qtystorage+=	parseInt(dataItem[j].qtystorage,10);
						     	}
						      load_s1_right+="<tr>"+
			          
			          " <td rowspan=\"4\" class=\"td_s04\"><input type=\"checkbox\" name=\"in_store\" onclick=\"dist.storeValidate('in_store_"+styleAndColorAndStoreName[i]+"')\"  id=\"in_store_"+styleAndColorAndStoreName[i]+"\"/></td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+styleAndColorAndStoreName[i]+"</td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+this.toDecimal(qtysale/dayDiff)+"</td>"+
			          " <td rowspan=\"4\" class=\"td_s04 span-blue\">"+qtystorage+"</td>"+
			          " <td height=\"20\" class=\"td_s03\">原预计库存</td>";
			
			          for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s03\">"+dataItem[j].qtyvalidorg+"</td>";
			          	}
			       load_s1_right+= " </tr>"+
			       " <tr>"+
			          " <td height=\"20\" class=\"td_s06\">本次调入</td>";
			           for(var j=0;j<dataItem.length;j++){
			          	  load_s1_right+=" <td class=\"td_s06\"><input barcode=\""+dataItem[j].barcode+"\" isInOrOut=\"in\"  oldvalue=\"0\"  xmls=\""+dataItem[j].xmls+"\" color=\""+dataItem[j].color+"\"  in_store=\"in_store_"+dataItem[j].storename+"\" store=\""+dataItem[j].storename+"\" sise=\""+dataItem[j].size+"\" type=\"text\" class=\"input_s01\"  value=\"0\"/></td>";
			          	}
			      load_s1_right+= " </tr>"+
			        "<tr>"+
			          " <td height=\"20\" class=\"td_s07\">总调入</td>";
			           for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s07\"><div id=\"in_"+dataItem[j].storename+"_"+dataItem[j].size+"\">"+dataItem[j].tot_qtyin+"</div></td>";
			          	}
			       load_s1_right+= "</tr>"+
			       " <tr>"+
			          " <td height=\"20\" class=\"td_s05\">预计库存</td>";
			          for(var j=0;j<dataItem.length;j++){
			          	 load_s1_right+=" <td class=\"td_s05\"><div id=\"prein_"+dataItem[j].storename+"_"+dataItem[j].size+"\">"+dataItem[j].qtyvalid+"</div></td>";
			          	}
			       load_s1_right+= "</tr>";
			 	}
        
        load_s1_right+="</table>"
        load_s1_right+="</div>"
        
        //Tab2  调拨明细
        load_s1_right+=" <div id=\"con_two_2\" class=\"s1-right-m s1-hidden\" >"
        load_s1_right+=" <table width=\"870\" id=\"trans_result_table\" overflow=\"auto\"  border=\"1\" class=\"table_s01\">"
       
         
         
        load_s1_right+="</table>"
        load_s1_right+="</div>"
       $("load-s1-right").innerHTML=load_s1_right;
       this.drawTransResult();
   		},
   		toDecimal:function(x) {  

            var f = parseFloat(x);  
            if (isNaN(f)) {  
                return;  
            }  
            f = Math.round(x*10)/10;  
            return f;  
        } , 

   	//按店仓的销量重整数据
   	orderByStoreSaleCount:function(dataArray,scOrDesc){

   		if(ascOrDesc="asc"){
   			for(var i=0;i<dataArray.length;i++){
   				for(var j=i+1;j<dataArray.length;j++){
   					if(parseInt(dataArray[i].split('-tot-')[1],10)<parseInt(dataArray[j].split('-tot-')[1],10)){
   						var temp=dataArray[i];
   						dataArray[i]=dataArray[j];
   						dataArray[j]=temp;
   						}
   					}
   				
   				}
   			}
   			if(ascOrDesc="des"){
   			for(var i=0;i<dataArray.length;i++){
   				for(var j=i+1;j<dataArray.length;j++){
   					if(parseInt(dataArray[i].split('-tot-')[1],10)>parseInt(dataArray[j].split('-tot-')[1],10)){
   						var temp=dataArray[i];
   						dataArray[i]=dataArray[j];
   						dataArray[j]=temp;
   						}
   					}
   				
   				}
   			}
   			for(var i=0;i< dataArray.length;i++){
   				dataArray[i]=dataArray[i].split('-tot-')[0];
   				}
   		/*	if(ascOrDesc="desc"){
   				for(var i=0;i<dataArray.length;i++){
   				for(var j=i+1;j<dataArray.length;j++){
   					if(dataArray[i].qtysale>dataArray[j].qtysale){
   						var temp=dataArray[i];
   						dataArray[i]=dataArray[j];
   						dataArray[j]=temp;
   						}
   					}
   				
   				}*/
   				
   			return dataArray;
   		},
   	drawTransResult:function(){
   			 //头部
   			 var temp_load_s1_right="";
   		  temp_load_s1_right +="<table width=\"870\" id=\"trans_result_table\" overflow=\"auto\"  border=\"1\" class=\"table_s01\">";
        temp_load_s1_right+=" <tr>"+
         " <td width=\"24\" rowspan=\""+(this.transresult.length+1)+"\" class=\"td_s08 span-black span-blod\"><p>调</p><p>拨</p><p>结</p><p>果</p></td>"+
         " <td width=\"39\" height=\"20\" class=\"td_s01 span-white span-blod\">序号</td>"+
         " <td width=\"130\" class=\"td_s01 span-white span-blod\">发货店仓</td>"+
         " <td width=\"130\" class=\"td_s01 span-white span-blod\">收货店仓</td>"+
         " <td width=\"120\" class=\"td_s01 span-white span-blod\">款号</td>"+
         " <td width=\"60\" class=\"td_s01 span-white span-blod\">颜色</td>"+
         " <td width=\"60\" class=\"td_s01 span-white span-blod\">尺寸</td>"+
         " <td width=\"169\" class=\"td_s01 span-white span-blod\">条码</td>"+
         " <td width=\"80\" class=\"td_s01 span-white span-blod\">合计数量</td>"+
         " </tr> ";
         //明细数据
         var tot_count=0;
         if(this.transresult){
         	for(var i=0;i<this.transresult.length;i++){
         		temp_load_s1_right+= "<tr> <td height=\"20\" class=\"td_s04\">"+(i+1)+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].c_orig_id+"</td>"+   //发货店仓
         " <td class=\"td_s04\">"+this.transresult[i].c_dest_id+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].xmls+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].color+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].size+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].barcode+"</td>"+
         " <td class=\"td_s04\">"+this.transresult[i].transcount+"</td></tr>";
         tot_count=tot_count+parseInt(this.transresult[i].transcount,10);
         		}
         }else{
         temp_load_s1_right+= "<tr> <td height=\"20\" class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td>"+
         " <td class=\"td_s04\">&nbsp;</td></tr>";
        	}         
         
         
       
        //尾部
        temp_load_s1_right+=" <tr>"+
         " <td height=\"20\" class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06\">&nbsp;</td>"+
         " <td class=\"td_s06 span-black span-blod\">"+tot_count+"</td>"+
         " </tr>";
         temp_load_s1_right +="</table>";
         $("con_two_2").innerHTML=temp_load_s1_right;
   			},
   	setTab:function(name,cursel,n){
				 for(i=1;i<=n;i++){
				  var menu=document.getElementById(name+i);
				  var con=document.getElementById("con_"+name+"_"+i);
				  menu.className=i==cursel?"s1-hover":"";
				  con.style.display=i==cursel?"block":"none";
				 }
   		},
   		//修改内存中数据数量    styleAndColorDataItem
   	updateCellData:function(xmls,color,barcode,size,storename,transrange){
   		var tempname=xmls+'---'+color;
   		for(var i=0;i<this.styleAndColorDataItem[tempname].length;i++){
   			if(this.styleAndColorDataItem[tempname][i].storename==storename&&this.styleAndColorDataItem[tempname][i].barcode==barcode&&this.styleAndColorDataItem[tempname][i].size==size){
   				this.styleAndColorDataItem[tempname][i].qtycan=parseInt(this.styleAndColorDataItem[tempname][i].qtycan,10)-parseInt(transrange,10);
   				this.styleAndColorDataItem[tempname][i].tot_qtyout=parseInt(this.styleAndColorDataItem[tempname][i].tot_qtyout,10)+parseInt(transrange,10);
   				this.styleAndColorDataItem[tempname][i].qtyrem=parseInt(this.styleAndColorDataItem[tempname][i].qtycan,10)-parseInt(this.styleAndColorDataItem[tempname][i].tot_qtyout,10);
   				this.styleAndColorDataItem[tempname][i].tot_qtyin=parseInt(this.styleAndColorDataItem[tempname][i].tot_qtyin,10)+parseInt(transrange,10);
   				this.styleAndColorDataItem[tempname][i].qtyvalid=parseInt(this.styleAndColorDataItem[tempname][i].qtyvalidorg,10)+parseInt(this.styleAndColorDataItem[tempname][i].tot_qtyin,10);
   				}
   			}
   			//alert(parseInt(jQuery("#can_"+storename+"_"+size).html(),10));
   		//	if(jQuery("#out_store_"+storename).attr("checked"))
   		//	jQuery("#can_"+storename+"_"+size).html(parseInt(jQuery("#can_"+storename+"_"+size).html(),10)-parseInt(transrange,10));
   		},
   	makeOrder:function(){
   		var isTransDataSucc=false;
   		if(!this.storeValidate(undefined,false)){
   			isTransDataSucc= this.transData(isTransDataSucc);
   		if(isTransDataSucc){
   			this.clearTempTransData();
   			jQuery("#con_two_1>table input[type='text']").each(function(){
    	  	jQuery(this).attr("oldvalue","0");
      	});
      	alert("调拨成功！");
   			}
   			}
   		
   		},
   		//trans_table将本次调拨数量清空
   	clearTempTransData:function(){
   		jQuery("#out_trans_table input[type='text']").each(function(){
   			jQuery(this).val(0);
   			});
   	jQuery("#in_trans_table input[type='text']").each(function(){
   			jQuery(this).val(0);

   			});
   		},
   	transData:function(isTransDataSucc){
   		//一个调出店仓，一个调入店仓； n个调出店仓，一个调入店仓；1个调出店仓，n个调入店仓
   		
   		var out_store_count= jQuery("[name='out_store']:checked").length;
   		var in_store_count= jQuery("[name='in_store']:checked").length;
   		if(out_store_count==1&&in_store_count==1){
   		 	var outcheckedStoreId= jQuery("[name='out_store']:checked")[0].id;
   		  var outstorecelldata= jQuery("[out_store='"+outcheckedStoreId+"']");
   		  var incheckedStoreId= jQuery("[name='in_store']:checked")[0].id;
   		  var instorecelldata= jQuery("[in_store='"+incheckedStoreId+"']");
   		  for(var i=0;i<outstorecelldata.length;i++){
   		  	var celldata={};
   		  	if(jQuery(outstorecelldata[i]).val()!=jQuery(instorecelldata[i]).val()){
   		  		alert("调入店仓与调出店仓的调拨数量不等！");
   		  		isTransDataSucc=false;
   		  		break;
   		  		}
   		  	 celldata.c_orig_id=jQuery(outstorecelldata[i]).attr("store");
   		  	 celldata.c_dest_id=jQuery(instorecelldata[i]).attr("store");
   		  	 celldata.xmls=jQuery(outstorecelldata[i]).attr("xmls");
   		  	 celldata.color=jQuery(outstorecelldata[i]).attr("color");
   		  	 celldata.size=jQuery(outstorecelldata[i]).attr("sise");
   		  	 celldata.barcode=jQuery(outstorecelldata[i]).attr("barcode");
   		  	 celldata.transcount=jQuery(outstorecelldata[i]).val();
   		  	 celldata.mathround=this.transResultMathRount();
   		  	 if(parseInt(jQuery(outstorecelldata[i]).val(),10)!=0){
   		  	 	 this.transresult.push(celldata);
   		  	 	 isTransDataSucc=true;
   		  	 	 this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_orig_id,celldata.transcount);
   		  	 	 this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_dest_id,celldata.transcount);
   		  	 	}
   		  	}
   		 }
   		 //1个调出店仓，n个调入店仓
   		 if(out_store_count==1&&in_store_count>1){
   		 	var outcheckedStoreId= jQuery("[name='out_store']:checked")[0].id;
   		  var outstorecelldata= jQuery("[out_store='"+outcheckedStoreId+"']");
   		  var incheckedStoreIds= jQuery("[name='in_store']:checked");
   		  var isBreak=false;
   		  for(var m=0;m<incheckedStoreIds.length;m++){
   		  	 var incheckedStoreId= jQuery("[name='in_store']:checked")[m].id;
   		  	 var instorecelldata= jQuery("[in_store='"+incheckedStoreId+"']");
   		  	
   		    for(var i=0;i<outstorecelldata.length;i++){
   		      if(isBreak){
   		      	break;
   		      	}
   		  	var celldata={};
   		  	//该尺寸下调入数量总数
   		  	var size_count=0;
   		  	for(var n=0;n<incheckedStoreIds.length;n++){
   		  		  var tempincheckedStoreId= jQuery("[name='in_store']:checked")[n].id;
   		  	    var tempinstorecelldata= jQuery("[in_store='"+tempincheckedStoreId+"']");
   		  			size_count=size_count+parseInt(jQuery(tempinstorecelldata[i]).val(),10);
   		  			
   		  		
   		  		}
   		  //	alert(parseInt(jQuery(outstorecelldata[i]).val(),10));
   		  	if(parseInt(jQuery(outstorecelldata[i]).val(),10)!==size_count){
   		  		alert("调入店仓与调出店仓的调拨数量不等！");
   		  		isTransDataSucc=false;
   		  	  isBreak=true;
   		  	  break;
   		  		}
   		  	 celldata.c_orig_id=jQuery(outstorecelldata[i]).attr("store");
   		  	 celldata.c_dest_id=jQuery(instorecelldata[i]).attr("store");
   		  	 celldata.xmls=jQuery(instorecelldata[i]).attr("xmls");
   		  	 celldata.color=jQuery(instorecelldata[i]).attr("color");
   		  	 celldata.size=jQuery(instorecelldata[i]).attr("sise");
   		  	 celldata.barcode=jQuery(instorecelldata[i]).attr("barcode");
   		  	 celldata.transcount=jQuery(instorecelldata[i]).val();
   		  	 celldata.mathround=this.transResultMathRount();
   		  	 if(parseInt(jQuery(instorecelldata[i]).val(),10)!=0){
   		  	 	  this.transresult.push(celldata);
   		  	 	  isTransDataSucc=true;
   		  	 	  this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_orig_id,celldata.transcount);
   		  	 	  this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_dest_id,celldata.transcount);
   		  	 	}
   		  	}
   		  	}
   		  
   		 	}
   		 	//n个调出店仓，1个调入店仓
   		 	if(out_store_count>1&&in_store_count==1){

        var outcheckedStoreId= jQuery("[name='in_store']:checked")[0].id;
   		  var outstorecelldata= jQuery("[in_store='"+outcheckedStoreId+"']");
   		  var incheckedStoreIds= jQuery("[name='out_store']:checked");
   		  var isBreak=false;
   		  for(var m=0;m<incheckedStoreIds.length;m++){
   		  	 var incheckedStoreId= jQuery("[name='out_store']:checked")[m].id;
   		  	 var instorecelldata= jQuery("[out_store='"+incheckedStoreId+"']");
   		  	
   		    for(var i=0;i<outstorecelldata.length;i++){
   		      if(isBreak){
   		      	break;
   		      	}
   		  	var celldata={};
   		  	//该尺寸下调入数量总数
   		  	var size_count=0;
   		  	for(var n=0;n<incheckedStoreIds.length;n++){
   		  		  var tempincheckedStoreId= jQuery("[name='out_store']:checked")[n].id;
   		  	    var tempinstorecelldata= jQuery("[out_store='"+tempincheckedStoreId+"']");
   		  			size_count=size_count+parseInt(jQuery(tempinstorecelldata[i]).val(),10);
   		  			
   		  		
   		  		}
   		  //	alert(parseInt(jQuery(outstorecelldata[i]).val(),10));
   		  	if(parseInt(jQuery(outstorecelldata[i]).val(),10)!==size_count){
   		  		alert("调入店仓与调出店仓的调拨数量不等！");
   		  		isTransDataSucc=false;
   		  	  isBreak=true;
   		  	  break;
   		  		}
   		  	 celldata.c_dest_id=jQuery(outstorecelldata[i]).attr("store");
   		  	 celldata.c_orig_id=jQuery(instorecelldata[i]).attr("store");
   		  	 celldata.xmls=jQuery(instorecelldata[i]).attr("xmls");
   		  	 celldata.color=jQuery(instorecelldata[i]).attr("color");
   		  	 celldata.size=jQuery(instorecelldata[i]).attr("sise");
   		  	 celldata.barcode=jQuery(instorecelldata[i]).attr("barcode");
   		  	 celldata.transcount=jQuery(instorecelldata[i]).val();
   		  	 celldata.mathround=this.transResultMathRount();
   		  	 if(parseInt(jQuery(instorecelldata[i]).val(),10)!=0){
   		  	 	  this.transresult.push(celldata);
   		  	 	  isTransDataSucc=true;
   		  	 	  this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_orig_id,celldata.transcount);
   		  	 	  this.updateCellData(celldata.xmls,celldata.color,celldata.barcode,celldata.size,celldata.c_dest_id,celldata.transcount);
   		  	 	}
   		  	}
   		  	}
   		 	}
   			if(this.transresult.length>0){
   		    this.drawTransResult(this.transresult);
   		  }
   		  var tempbool=false;
   		  jQuery("#con_two_1>table input[type='text']").each(function(){
    	  	if(this.value>0){
    	  		tempbool=true;
    	  		}
      	});
      	if(!tempbool){
      		alert('调拨数量不能为0，请重新输入！');
      		}
   		  return isTransDataSucc;
   		},
   	storeValidate:function(storename,isvalidate){
   		var out_store_count= jQuery("[name='out_store']:checked").length;
   		var in_store_count= jQuery("[name='in_store']:checked").length;
   		if(out_store_count==0&&!storename){
   			alert("没有选择调出店仓！");
   			return true;
   		}
   		if(in_store_count==0&&!storename){
   			alert("没有选择调入店仓！");
   			return true;
   		}
   		if(storename){
   	  storename=storename.replace("in_store_","");
   		storename=storename.replace("out_store_","");  
      if(jQuery("#"+"out_store_"+storename).is(":checked")&& jQuery("#"+"in_store_"+storename).is(":checked")){
      	alert('不能同家店仓调拨！');
      	jQuery("#"+"in_store_"+storename).removeAttr("checked");
      	return true;
      	}
   		if(out_store_count>1&&in_store_count>1){
   			alert("不能同时选择多个调入与调出店仓！");
   			jQuery("#"+"in_store_"+storename).removeAttr("checked","");
   			return true;
   			}
   		}
   		return false;
   	},

    _executeCommandEvent :function (evt) {
        Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
                alert(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
    },
    checkIsDate:function(month,date,year){
        if(parseInt(month,10)>12||parseInt(month,10)<1||parseInt(date,10)>31||parseInt(date,10)<1||parseInt(year,10)<1980||parseInt(year,10)>3000) {
            return false;
        }
        return true;
    },
    autoView1:function(){
    	 window.onbeforeunload=function(){
        		if(window.location==dist.windowLocation){
            	if( $("isChanged").value=='true'){
 	               		return "页面数据已改动，还未保存！";
		            }else{
		                return;
		            }
          	}
       	 }
     	jQuery("#pdt-search").bind("keyup",function(event){
					if(event.target==this&&event.which==13){
						dist.pdt_search();
						jQuery("#con_two_1>table input[type='text']:first").focus();
					}
				});
				
				
			 jQuery("#con_two_1>table input[type='text']").bind("focus",function(event){
        	if(event.target==this){
            var e=Event.element(event)
            dwr.util.selectRange(this,0,100);
          }
        });
        jQuery("#con_two_1>table input[type='text']").bind("keyup",function(event){
          	 //	alert(dist.tonext);
       	   //var x=parseInt(jQuery(this).attr("x-index"),10);
           //var y=parseInt(jQuery(this).attr("y-index"),10);
		       if(event.target=this){
		          if(isNaN(this.value)){
		           	this.value=0;
		        	 //  alert("请输入数字");
		            jQuery(this).focus();
		         }else if(event.which==32){
		         	    this.value=0; 
		         	 jQuery(this).focus();     	
		         	}else{
		        		if(dist.tonext==0){ 
		           
		              }else{
		                 dist.tonext=0;
		            jQuery(dist.i).focus();
		              	}
		               }       
		           }
        });
        jQuery("#con_two_1>table input[type='text']").bind("keydown",function(event){
          	 if(event.target=this){
          	 	if(event.which==32){
          	 		this.value=0;
          	 		}
          	 	}
          	
          	});
       jQuery("#con_two_1>table input[type='text']").bind("blur",function(event){
        	   if(event.target==this){
                this.status=1;
                if(this.value==""){
                	  this.value=0;
                } 
                $("isChanged").value='true';
                 
                var isInOrOut= jQuery(this).attr("isInOrOut");  
                var sise= jQuery(this).attr("sise");
                var store=jQuery(this).attr("store"); 
                var oldValue=parseInt(jQuery(this).attr("oldvalue"),10);
                var newValue=parseInt(this.value,10);
                var transrange=newValue-oldValue;
                if(isInOrOut=="out"){
                	var tempName="#can_"+store+"_"+sise;
                	var tempcan=	parseInt(jQuery(tempName).html()==""?0:jQuery(tempName).html(),10);
                	if(this.value>tempcan){
                		alert('本次调出数量不能大于可配量！');
                		dist.tonext=1;
                    dist.i=this;
                    this.value = 0;
                    dwr.util.selectRange(this,0,100);
                    jQuery(this).focus();
                    return;
                		}
                //	tempvalue=tempvalue-transrange;
                	//jQuery(tempName).html(tempvalue+"");
                  tempName="#out_"+store+"_"+sise;
                  var tempvalue=	parseInt(jQuery(tempName).html()==""?0:jQuery(tempName).html(),10)+transrange;
                  if(tempvalue>tempcan){
                  	alert('本次调出数量与总调出可配量不能大于可配量！');
                		dist.tonext=1;
                    dist.i=this;
                    this.value = 0;
                    dwr.util.selectRange(this,0,100);
                    jQuery(this).focus();
                    return;
                  	}
                  if(tempvalue<0){
                  	alert("总调拨量不能为负数！");
                  	dist.tonext=1;
                    dist.i=this;
                    this.value = 0;
                    dwr.util.selectRange(this,0,100);
                    jQuery(this).focus();
                  	return;
                  	}
                	jQuery(tempName).html(tempvalue+"");
                	tempName="#rem_"+store+"_"+sise
                	tempvalue=	parseInt(jQuery("#can_"+store+"_"+sise).html()==""?0:jQuery("#can_"+store+"_"+sise).html(),10)-parseInt(jQuery("#out_"+store+"_"+sise).html()==""?0:jQuery("#out_"+store+"_"+sise).html(),10);
                	jQuery(tempName).html(tempvalue+"");
                }else{
                	var tempName="#in_"+store+"_"+sise;
                	var tempvalue=	parseInt(jQuery(tempName).html()==""?0:jQuery(tempName).html(),10)+transrange;
                	if(tempvalue<0){
                  	alert("总调拨量不能为负数！");
                  	dist.tonext=1;
                    dist.i=this;
                    this.value = 0;
                    dwr.util.selectRange(this,0,100);
                    jQuery(this).focus();
                  	return;
                  	}
                	jQuery(tempName).html(tempvalue+"");
                	tempName="#prein_"+store+"_"+sise;
                	tempvalue=	parseInt(jQuery(tempName).html()==""?0:jQuery(tempName).html(),10)+transrange;
                	jQuery(tempName).html(tempvalue+"");
                	}
                jQuery(this).attr("oldvalue",this.value);
                if(dist.tonext==1){
                  	jQuery(this).focus();
                }
           }
        });
        
        jQuery("#con_two_1>table input[type='text']:first").focus();
     	},
     	refresh_ff_ie:function(){
     		try{   
          //for IE   
          document.execCommand('Refresh',false,0);   
        }catch (BorwerSupportException){   
          //for firefox   
          window.location.reload();   
       } 


     		},
    pdt_search:function(){
        var cdt=$("pdt-search").value;
        if($("showStyle").value=="metrix"){
		        var pdts=new Array();
		        if(!cdt||!cdt.strip()){
							$("style_color_name").innerHTML=this.style_color_name;
							this.drawTableByStyleAndColorName(this.styleAndColorName[0]);
		        }else{
							cdt=cdt.strip();
							var style_color_nameStr="";
							var reg= new RegExp(cdt,"i");
							 for(var i=0;i<this.styleAndColorName.length;i++){
								if(reg.test(this.styleAndColorName[i])){
									pdts.push(this.styleAndColorName[i]);
								}
							}
							for(var j=0;j<pdts.length;j++){
								  
								style_color_nameStr+="<li onclick='javascript:dist.showcontent(\""+pdts[j]+"\");this.style.backgroundColor=\"#8db6d9\"; this.style.color=\"white\";' "+
			                              (j==0?"style='background:#8db6d9'":"")+"><div class=\"span-130\">"+pdts[j].split('---')[0]+"</div><div class=\"span-50\">"+pdts[j].split('---')[1]+"</div></li>";
							}
							$("style_color_name").innerHTML=style_color_nameStr;
					  }
				  	if(pdts[0])this.showcontent(pdts[0],"yes");
        }
    }
   
  
}
DIST.main = function(){
    dist=new DIST();
};
jQuery(document).ready(DIST.main);
jQuery(document).ready(function(){
   jQuery("body").bind("keyup",function(event){
       if(event.which==13){
           event.stopPropagation();
       }
   });
});

Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
}