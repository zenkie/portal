/* * Part from Bindows 2.55, depends on Prototype for browser check
*/ 
var _biInPrototype=false;
function _biExtend(fConstr,fSuperConstr,sName)
{
	_biInPrototype=true;
	var p=fConstr.prototype=new fSuperConstr();
	if(sName)
	{
		p._className=sName;
	}
	p.constructor=fConstr;
	_biInPrototype=false;
	return p;
}
Function.READ=1;
Function.WRITE=2;
Function.READ_WRITE=3;
Function.EMPTY=function()
{
};

Function.prototype.addProperty=function(sName,nReadWrite)
{
	var p=this.prototype;
	nReadWrite=nReadWrite||Function.READ_WRITE;
	var capitalized=(sName.charAt(0).toUpperCase()+sName.substr(1));
	sName="_"+sName;
	if(nReadWrite&Function.READ)
	{
		p["get"+capitalized]=function()
		{
			return this[sName];
		};
	}
	if(nReadWrite&Function.WRITE)
	{
		p["set"+capitalized]=function(v)
		{
			this[sName]=v;
		};
	}
};
function BiObject()
{
}
_p=_biExtend(BiObject,Object,"BiObject");
_p._disposed=false;
_p._id=null;
BiObject.TYPE_FUNCTION="function";
BiObject.TYPE_OBJECT="object";
BiObject.TYPE_STRING="string";
BiObject._hashCodeCounter=1;
BiObject.isEmpty=function(o)
{
	for(var _ in o)return false;
	return true;
};
BiObject.toHashCode=function(o)
{
	if(o.hasOwnProperty("_hashCode"))return o._hashCode;
	return o._hashCode="_"+(BiObject._hashCodeCounter++ ).toString(32);
};
BiObject.addProperty("disposed",Function.READ);
BiObject.addProperty("id",Function.READ_WRITE);
BiObject.addProperty("userData",Function.READ_WRITE);
_p.toHashCode=function()
{
	return BiObject.toHashCode(this);
};
_p.dispose=function()
{
	this._disposed=true;
	delete this._userData;
	delete this._id;
	this.dispose=Function.EMPTY;
};
_p.disposeFields=function(fieldNames)
{
	var fields=fieldNames instanceof Array?fieldNames:arguments;
	var n,o,p;
	for(var i=0;i<fields.length;i++)
	{
		n=fields[i];
		if(this.hasOwnProperty(n))
		{
			o=this[n];
			if(o!=null)
			{
				if(typeof o.dispose==BiObject.TYPE_FUNCTION)
				{
					o.dispose();
				}
				else if(o instanceof Array)
				{
					for(var j=0;j<o.length;j++)
					{
						p=o[j];
						if(p&&typeof p.dispose==BiObject.TYPE_FUNCTION)
						{
							p.dispose();
						}
					}
				}
			}
			delete this[n];
		}
	}
};
_p.toString=function()
{
	if(this._className)return "[object "+this._className+"]";
	return "[object Object]";
};
_p.getProperty=function(sPropertyName)
{
	var getterName="get"+sPropertyName.capitalize();
	if(typeof this[getterName]==BiObject.TYPE_FUNCTION)return this[getterName]();
	throw new Error("No such property, "+sPropertyName);
};
_p.setProperty=function(sPropertyName,oValue)
{
	var setterName="set"+sPropertyName.capitalize();
	if(typeof this[setterName]==BiObject.TYPE_FUNCTION)this[setterName](oValue);
	else throw new Error("No such property, "+sPropertyName);
};
_p.setProperties=function(oProperties)
{
	for(var p in oProperties)this.setProperty(p,oProperties[p]);
};
_p.setAttribute=function(sName,sValue,oParser)
{
	var v,vv;
	if(sValue==String.BOOLEAN_TRUE)v=true;
	else if(sValue==String.BOOLEAN_FALSE)v=false;
	else if((vv=parseFloat(sValue))==sValue)v=vv;
	else v=sValue;
	this.setProperty(sName,v);
};
_p.getAttribute=function(sName)
{
	return String(this.getProperty(sName));
};
_p.addXmlNode=function(oNode,oParser)
{
	if(oNode.nodeType==1)oParser.fromNode(oNode);
};
if(typeof BiObject=="undefined")BiObject=new Function();

function BiEvent(sType)
{
	if(_biInPrototype)return;
	BiObject.call(this);
	this._type=sType;
}
_p=_biExtend(BiEvent,BiObject,"BiEvent");
_p._bubbles=false;
_p._propagationStopped=true;
_p._defaultPrevented=false;
BiEvent.addProperty("type",Function.READ);
BiEvent.addProperty("target",Function.READ);
BiEvent.addProperty("currentTarget",Function.READ);
BiEvent.addProperty("bubbles",Function.READ);
_p.stopPropagation=function()
{
	this._propagationStopped=true;
};
BiEvent.addProperty("propagationStopped",Function.READ);
_p.preventDefault=function()
{
	this._defaultPrevented=true;
};
BiEvent.addProperty("defaultPrevented",Function.READ);
_p.dispose=function()
{
	BiObject.prototype.dispose.call(this);
	delete this._target;
	delete this._currentTarget;
	delete this._bubbles;
	delete this._propagationStopped;
	delete this._defaultPrevented;
};
_p.getDefaultPrevented=function()
{
	return this._defaultPrevented;
};

function BiEventTarget()
{
	if(_biInPrototype)return;
	BiObject.call(this);
	this._listeners=
	{
	};
	this._listenersCount=0;
}
_p=_biExtend(BiEventTarget,BiObject,"BiEventTarget");
_p.addEventListener=function(sType,fHandler,oObject)
{
	if(typeof fHandler!=BiObject.TYPE_FUNCTION)throw new Error(this+" addEventListener: "+fHandler+" is not a function ("+ sType+")");
	var ls=this._listeners[sType];
	if(!ls)ls=this._listeners[sType]=
	{
	};
	var key=BiObject.toHashCode(fHandler)+(oObject?BiObject.toHashCode(oObject):String.EMPTY);
	if(!(key in ls))
	{
		this._listenersCount++;
	}
	ls[key]=
	{
		handler:fHandler,object:oObject||this
	};
};
_p.removeEventListener=function(sType,fHandler,oObject)
{
	if(this._disposed||!(sType in this._listeners))return;
	var key=BiObject.toHashCode(fHandler)+(oObject?BiObject.toHashCode(oObject):String.EMPTY);
	if(key in this._listeners[sType])
	{
		--this._listenersCount;
	}
	delete this._listeners[sType][key];
	if(BiObject.isEmpty(this._listeners[sType]))
	{
		delete this._listeners[sType];
	}
};
_p.dispatchEvent=function(e)
{
	if(this._disposed)return;
	if(typeof e==BiObject.TYPE_STRING)
	{
		e=new BiEvent(e);
	}
	e._target=this;
	this._dispatchEvent(e);
	delete e._target;
	return !e._defaultPrevented;
};
_p._dispatchEvent=function(e)
{
	e._currentTarget=this;
	if(this._listenersCount>0)
	{
		var fs=this._listeners[e.getType()];
		if(fs)
		{
			for(var hc in fs)
			{
				var ho=fs[hc];
				ho.handler.call(ho.object,e);
			}
		}
	}
	if(e._bubbles&&!e._propagationStopped&&this._parent&&!this._parent._disposed)
	{
		this._parent._dispatchEvent(e);
	}
	delete e._currentTarget;
};
_p.setAttribute=function(sName,sValue,oParser)
{
	if(sName.substring(0,2)=="on")
	{
		var type=sName.substring(2);
		this.addEventListener(type,new Function("event",sValue),oParser);
	}
	else BiObject.prototype.setAttribute.call(this,sName,sValue,oParser);
};
_p.dispose=function()
{
	if(this._disposed)return;
	BiObject.prototype.dispose.call(this);
	for(var t in this._listeners)delete this._listeners[t];
	delete this._listeners;
	delete this._listenersCount;
};
_p.hasListeners=function(sType)
{
	return this._listenersCount>0&&(sType==null||sType in this._listeners);
};

function BiApplication()
{
	if(_biInPrototype)return;
	if(typeof application=="object")return application;
	application=this;
	BiEventTarget.call(this);
}
var application;
_p=_biExtend(BiApplication,BiEventTarget,"BiApplication");
_p._version="2.55";
BiApplication.prototype.getVersion=function()
{
	return this._version;
};
_p.start=function()
{
	if(Prototype.Browser.IE)window.attachEvent("onunload",this._onunload);
	else window.addEventListener("unload",this._onunload,false);
};

_p._onunload=function()
{
	application.dispose();
};

_p.dispose=function()
{
	if(this._disposed)return;
	this.dispatchEvent("dispose");
	if(Prototype.Browser.IE)window.detachEvent("onunload",this._onunload);
	else window.removeEventListener("unload",this._onunload,false);
	//this.disposeFields("_adfPath","_systemRootPath","_themeManager","_window","_loadStatus","_resourceLoader","_adf","_inactivityTimeout","_uri","_uriParams");
	BiEventTarget.prototype.dispose.call(this);
	application=null;
};
_p.setAttribute=function(sName,sValue,oParser)
{
	switch(sName)
	{
		case "defaultPackages":
		{
			this.setProperty(sName,sValue.split(/\s*,\s*/));
			break;
		}
		default:BiEventTarget.prototype.setAttribute.apply(this,arguments);
	}
};

application = new BiApplication();

//------------------------------------------------
// 关闭窗口的通用组件 放在这里的原因是，考虑到几乎所有页面都会引用application.js 这样便于宏观控制窗口关闭
//------------------------------------------------
; (function (env) {
    if (env.Alerts) {
        return;
    }
    var jQuery = env.jQuery;
    var ArtUtils = env.Alerts = env.ArtUtils = {};

    ArtUtils.killAlert = function (inArtElement) {
        this.close(inArtElement);
    }

    /**
     * 名称：关闭窗口 可以兼容关闭一下场景的窗口： 
     *    1.关闭使用art弹出不包含iframe的弹出窗口,
     *    2.关闭art弹出窗口(包含iframe) 例如:iframe的contentWindow中的ArtUtils.close(document.body)
     *    3.关闭window.open的新窗口
     *    推荐用法：如果是直接绑定元素上的点击事件：例如:<input type="button" onclick="ArtUtils.close(this)" value="取消" />
     *    ArtUtils.close(推荐使用就近的元素);
     *    如果弹出的内容不是iframe或者不是window.open 请必须如此调用 ArtUtils.close(位于弹窗内的元素);
     * @param inArtElement 位于窗口中的元素 如果没有传递参数 则默认值为调用close所在的window
     */
    ArtUtils.close = function (inArtElement) {
        if (arguments.length == 0) {
            inArtElement = window;
        }
        var inTarget = jQuery(inArtElement);
        inTarget = inTargetRender(inTarget);
        var modal = inTarget.parents("[data-portal-art-modal]:eq(0)");
        if (modal.length > 0) {
            closeWithoutIframeArtModal(inTarget);
        } else {
            closeWithIframeArtModal(inTarget);
        }
    }
    /**
     * 名称：关闭包含iframe的弹出窗口
     */
    function closeWithIframeArtModal(inTarget) {
        var element = inTarget[0];
        if (element) {
            var nw = getElementWindow(element);
            //如果是浏览器新建窗口页
            if (nw.opener) {
                nw.close();
            } else if (nw.parent) {
                //如果是art弹窗
                var ifr = getIframeByWindow(nw);
                ifr && closeWithoutIframeArtModal(nw.parent.jQuery(ifr));
            } else {
                closeWithoutIframeArtModal(inTarget);
            }
        }
    }
    /**
     * 名称：关闭不包含iframe的弹出窗口
     */
    function closeWithoutIframeArtModal(inTarget) {
        var container = inTarget.is("[data-portal-art-modal],body,document") ? inTarget : inTarget.parent();
        var closeTarget = jQuery('<input data-art-dismiss="art" type="button" style="display:none;"></div>');
        container.append(closeTarget);
        closeTarget.click();//这里通过调用关闭代理进行关闭窗口 代理委托事件详情见于artDialog的deletes函数
        closeTarget.remove();
    }
    /**
     * 名称：处理inTarget
     */
    function inTargetRender(inTarget) {
        var orignObj = inTarget[0];
        if (orignObj.document) {
            inTarget = jQuery(orignObj.document.body);
        }
        if (orignObj.body) {
            inTarget = jQuery(orignObj.body);
        }
        return inTarget;
    }
    /**
    * 名称：获取指定元素的window
    */
    function getElementWindow(element) {
        var doc = element.ownerDocument;
        var nw = doc.defaultView || doc.parentWindow;
        return nw;
    }
    /**
     * 名称：获取指定window的frameElement
     */
    function getIframeByWindow(nw) {
        try {
            return nw.frameElement;
        } catch (ex) {
            return null;
        }
    }

})(window);
