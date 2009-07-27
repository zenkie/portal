function launch_spyWin(){
  if(window.screenTop>10000){
	var theWidth=330;
	var theHeight=200;
	var theTop=(screen.height/2)-(theHeight/2);
	var theLeft=(screen.width/2)-(theWidth/2);
	var features="height="+theHeight+",width="+theWidth+",top="+theTop+",left="+theLeft+",dependent=yes,resizable=no,scrollbars=no,toolbar=no,menubar=no,status=no";
	window.open("/html/nds/common/check_close.jsp","spyWin",features);
	//spyWin = open('/html/nds/common/spywin.htm','spyWin','width=100,height=100,left=2000,top=0,status=0');
	//spyWin.blur();
  }
  return false;
}
function check_close(b){
  if(b==null|| b==undefined) b=false;	
  // since there may exists mutiple frame using top.jsp in the same window, we should check_close 
  // only for the top window
  if( window.top==window || b){
	window.onunload = launch_spyWin;
  }
}
function showDialog(url, theWidth, theHeight,refreshWindowWhenClose){
	if( theWidth==undefined) theWidth=956;
    if( theHeight==undefined) theHeight=570;
	var options={width:theWidth,height:theHeight,title:gMessageHolder.IFRAME_TITLE, modal:true,centerMode:"x",noCenter:true,maxButton:false};
	if(refreshWindowWhenClose){
		options.onClose=refreshWindow;
	}
	Alerts.popupIframe(url,options);
	Alerts.resizeIframe(options);
	Alerts.center();
}
function btn_dialog_small(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	showDialog(url,620,480,true);
}
function btn_dialog_medium(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	showDialog(url,880,500,true);
}
function btn_dialog_window(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	dialog_window(url);
}
function redir_window(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	this.location=url;
}
function pop_self(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	this.location=url;
}
function pop_top(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	this.location=url;
}
function pop_parent(url,warning){
	if(warning!=undefined){
		if(!confirm(warning))return;
	}
	this.location=url;
}
function btnreq(url, theWidth, theHeight){
    dialog_window(url,theWidth, theHeight);
}
function refreshWindow(){
	window.location.reload();	
}
function dialog_window(url, theWidth, theHeight, refreshWindowWhenClose){
    /*if(theWidth==null|| theWidth==undefined) theWidth=400;
    if(theHeight==null|| theHeight==undefined) theHeight=200;
    var t="Dialog ";
    try{
    	t=gMessageHolder.IFRAME_TITLE;
    }catch(e){}
	var options={width:theWidth,height:theHeight,title:t,
		 modal:true,centerMode:"xy",noCenter:true,maxButton:false};
	Alerts.popupIframe(url,options);
	Alerts.resizeIframe(options);
	Alerts.center();*/
	if(theWidth==null|| theWidth==undefined) theWidth=400;
    if(theHeight==null|| theHeight==undefined) theHeight=100;
    var t="Dialog ";
    try{
    	t=gMessageHolder.IFRAME_TITLE;
    }catch(e){}
    var working="Processing...";
    try{
    	working=gMessageHolder.LOADING;
    }catch(e){}
    var msg='<center><table border="0" cellpadding="0" cellspacing="0" height="80" width="100%"><tr><td align="center" valign="middle"><br>'+
		working+'</font><br><img src="/html/nds/images/progress.gif"></td></tr></table></center>';
	var option={width: theWidth,height:theHeight,modal:true,centerMode:"none",noCenter: true,title: t,message:msg};
	if(refreshWindowWhenClose){
		option.onClose=refreshWindow;
	}
	var popup = Alerts.fireMessageBox(option);
	var evt=url.toQueryParams();
	Controller.handle( Object.toJSON(evt), function(r){
			try{
				var result= r.evalJSON();
				Alerts.killAlert($(popup));
				if(result.message){
					alert(result.message);
					try{
						// this is for button on object.jsp
					$("message_txt").innerHTML=result.message;
					$("message").style.visibility="visible";
					}catch(e){}
					
				}
				if(result.code==1){
					try{
						pc.refreshGrid();
						return;
					}catch(e){}
					try{
						oc.doRefresh();	
						return;
					}catch(e){}	
					window.location.reload();
				}else if(result.code==2){
					try{
						pc.refreshGrid();
						return;
					}catch(e){}
					try{
						oc.closeDialog();	
						return;
					}catch(e){}
					window.close();	
				}else if(result.code==3){
					try{
						gc.refreshGrid();	
						return;
					}catch(e){}
					try{
						oc.doRefresh();	
						return;
					}catch(e){}	
					window.location.reload();
				}
			}catch(exnb){
				//msgbox(exnb.message);
			}
		});	
}
function popup_window(url,tgt,theWidth,theHeight){
    if(tgt==null|| tgt==undefined) tgt="_blank";
    if(theWidth==null|| theWidth==undefined) theWidth=951;
    if(theHeight==null|| theHeight==undefined) theHeight=570;
	var theTop=(screen.height/2)-(theHeight/2);
	var theLeft=(screen.width/2)-(theWidth/2);
	var features="height="+theHeight+",width="+theWidth+",top="+theTop+",left="+theLeft+",dependent=yes,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,status=yes";
    var newWindow=window.open(url,tgt,features);
    newWindow.focus();
}
/*function popup_window(url,tgt,theWidth,theHeight){
	var dlgw=600,dlgh=570,bPopup=false;
	var body=document.body;
	if(theWidth==null|| theWidth==undefined){
		if(body.clientWidth>dlgw+30){
			theWidth=body.clientWidth>30?body.clientWidth-30:60;
			if(theWidth>951)theWidth=951;
			bPopup=false;
		}else{
			theWidth=951;
			bPopup=true;
		}
	}else{
		if(body.clientWidth>theWidth+30) bPopup=false;
		else bPopup=true;
	}
	if(theHeight==null|| theHeight==undefined){
		if(body.clientHeight>dlgh+60) theHeight=dlgh;
		else {
			theHeight=body.clientHeight>60?body.clientHeight-60:60;
		}
	}
	try{
		var a=Alerts.OPACITY;
	}catch(e){
		bPopup=true;	
	}
	if(bPopup|| tgt=="_blank"){
		old_popup_window(url,tgt,theWidth,theHeight);
	}else{
		//dlg
		dialog_window(url,theWidth, theHeight);
	}
}
*/
function noContextMenu() {
	event.returnValue = false;
	return false;
}

 function opt_(oid){
 	window.location="/html/nds/portal/portal.jsp?table="+oid;
 }
 function opc_(oid){
 	window.location="/html/nds/objext/objects.jsp?category="+encodeURIComponent(oid);
 }

//if(/MSIE/.test(navigator.userAgent))document.attachEvent( "oncontextmenu",noContextMenu );
function void(){}