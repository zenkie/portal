var cm=null;
var createmenu=Class.create();

createmenu.prototype={
	initialize: function() {
		application.addEventListener("CREATE_MENU", this._onCreateMenu, this);
	},
	cratemenu:function(){
		var evt={};
		evt.command="nds.weixin.ext.TestCreateMenuCommand";
		evt.callbackEvent="CREATE_MENU";
		var menu=jQuery("#menus").val();
		menu=eval('('+menu+')');
		var param={"domain":jQuery("#domin").val(),"menu":menu};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	_onCreateMenu:function(e){
		var data=e.getUserData();
        alert(data.message);
	},
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				//art.dialog.tips(result.message);
				alert(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	}
}

createmenu.main = function(){ cm=new createmenu();};
jQuery(document).ready(createmenu.main);