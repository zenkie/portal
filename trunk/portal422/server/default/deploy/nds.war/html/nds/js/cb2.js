/*----------------------------------------------------------------------------\
|                                Cool Button 2                                |
|-----------------------------------------------------------------------------|
|                          Created by Erik Arvidsson                          |
|                   (http://webfx.eae.net/contact.html#erik)                  |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
|                   Copyright (c) 2001, 2006 Erik Arvidsson                   |
|-----------------------------------------------------------------------------|
| Licensed under the Apache License, Version 2.0 (the "License"); you may not |
| use this file except in compliance with the License.  You may obtain a copy |
| of the License at http://www.apache.org/licenses/LICENSE-2.0                |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| Unless  required  by  applicable law or  agreed  to  in  writing,  software |
| distributed under the License is distributed on an  "AS IS" BASIS,  WITHOUT |
| WARRANTIES OR  CONDITIONS OF ANY KIND,  either express or implied.  See the |
| License  for the  specific language  governing permissions  and limitations |
| under the License.                                                          |
|-----------------------------------------------------------------------------|
| Dependencies: cb2.css             Cool button style declarations            |
|               ieemu.js            Required  for mozilla  support,  provides |
|                                   emulateAttachEvent and extendEventObject. |
|-----------------------------------------------------------------------------|
| 2001-03-17 | First version published.                                       |
| 2006-05-28 | Changed license to Apache Software License 2.0.                |
|-----------------------------------------------------------------------------|
| Created 2001-03-17 | All changes are in the log above. | Updated 2006-05-28 |
\----------------------------------------------------------------------------*/

/* Set up IE Emualtion for Mozilla */
if (window.moz == true && (typeof window.emulateAttachEvent != "function" || typeof window.extendEventObject != "function"))
	alert("Error! IE Emulation file not included.");

if (window.moz) {
	emulateAttachEvent();
	extendEventObject();
}
/* end Mozilla specific emulation initiation */

function createButton(el) {

	addElementEvent(el,"mouseover",createButton.overCoolButton);
	addElementEvent(el,"mouseout",	createButton.outCoolButton);
	addElementEvent(el,"mousedown",	createButton.downCoolButton);
	addElementEvent(el,"mouseup",		createButton.upCoolButton);
	addElementEvent(el,"click",		createButton.clickCoolButton);
	addElementEvent(el,"dblclick",	createButton.clickCoolButton);
	addElementEvent(el,"keypress",	createButton.keypressCoolButton);
	addElementEvent(el,"keyup",		createButton.keyupCoolButton);
	addElementEvent(el,"keydown",		createButton.keydownCoolButton);
	addElementEvent(el,"focus",		createButton.focusCoolButton);
	addElementEvent(el,"blur",		createButton.blurCoolButton);
	
	el.className = "coolButton";
	
	el.setEnabled	= createButton.setEnabled;
	el.getEnabled	= createButton.getEnabled;
	el.setValue		= createButton.setValue;
	el.getValue		= createButton.getValue;
	el.setToggle	= createButton.setToggle;
	el.getToggle	= createButton.getToggle;
	el.setAlwaysUp	= createButton.setAlwaysUp;
	el.getAlwaysUp	= createButton.getAlwaysUp;
	
	el._enabled		= true;
	el._toggle		= false;
	el._value		= false;
	el._alwaysUp	= false;
	
	return el;
}

/**
 * 这里兼容所有版本的ie浏览器的事件绑定
 */
function addElementEvent(element,type,handler){
	if(element==null){return;}
	if(element.addEventListener){
		element.addEventListener(type,handler);
	}else if(element.attachEvent){
		element.attachEvent('on'+type,handler);
	}else{
		element['on'+type] = handler;
	}
}

createButton.LEFT = window.moz ? 0 : 1;

/* event listeners */

createButton.overCoolButton = function (ev) {
    ev = ev || window.event;
    var toEl = createButton.getParentCoolButton(ev.toElement);
    var fromEl = createButton.getParentCoolButton(ev.fromElement);
	if (toEl == fromEl || toEl == null) return;
	
	toEl._over = true;
	
	if (!toEl._enabled) return;
	
	createButton.setClassName(toEl);
};

createButton.outCoolButton = function (ev) {
    ev = ev || window.event;
	var toEl = createButton.getParentCoolButton(ev.toElement);
	var fromEl = createButton.getParentCoolButton(ev.fromElement);
	if (toEl == fromEl || fromEl == null) return;
	
	fromEl._over = false;
	fromEl._down = false;
	
	if (!fromEl._enabled) return;	

	createButton.setClassName(fromEl);
};

createButton.downCoolButton = function (ev) {
    ev = ev || window.event;
    if (ev.button != createButton.LEFT) return;
	
    var el = createButton.getParentCoolButton(ev.srcElement);
	if (el == null) return;
	
	el._down = true;
	
	if (!el._enabled) return;

	createButton.setClassName(el);
};

createButton.upCoolButton = function (ev) {
    ev = ev || window.event;
    if (ev.button != createButton.LEFT) return;
	
    var el = createButton.getParentCoolButton(ev.srcElement);
	if (el == null) return;
	
	el._down = false;
	
	if (!el._enabled) return;
	
	if (el._toggle)
		el.setValue(!el._value);
	else
		createButton.setClassName(el);
};

createButton.clickCoolButton = function (ev) {
    ev = ev || window.event;
    var el = createButton.getParentCoolButton(ev.srcElement);
	el.onaction = el.getAttribute("onaction");
	if (el == null || !el._enabled || el.onaction == "" || el.onaction == null) return;
	
	if (typeof el.onaction == "string")
		el.onaction = new Function ("event", el.onaction);
	
	el.onaction(ev);
};

createButton.keypressCoolButton = function (ev) {
    ev = ev || window.event;
    var el = createButton.getParentCoolButton(ev.srcElement);
    if (el == null || !el._enabled || ev.keyCode != 13) return;
	
	el.setValue(!el._value);
	
	if (el.onaction == null) return;
	
	if (typeof el.onaction == "string")
		el.onaction = new Function ("event", el.onaction);
	
	el.onaction(ev);
};

createButton.keydownCoolButton = function (ev) {
    ev = ev || window.event;
    var el = createButton.getParentCoolButton(ev.srcElement);
    if (el == null || !el._enabled || ev.keyCode != 32) return;
	createButton.downCoolButton();
};

createButton.keyupCoolButton = function (ev) {
    ev = ev || window.event;
    var el = createButton.getParentCoolButton(ev.srcElement);
    if (el == null || !el._enabled || ev.keyCode != 32) return;
	createButton.upCoolButton();
	
	//el.setValue(!el._value);	// is handled in upCoolButton()
	
	if (el.onaction == null) return;
	
	if (typeof el.onaction == "string")
		el.onaction = new Function ("event", el.onaction);
	
	el.onaction(ev);
};

createButton.focusCoolButton = function (ev) {
    ev = ev || window.event;
	var el = createButton.getParentCoolButton(ev.srcElement);
	if (el == null || !el._enabled) return;
	createButton.setClassName(el);
};

createButton.blurCoolButton = function (ev) {
    ev = ev || window.event;
    var el = createButton.getParentCoolButton(ev.srcElement);
	if (el == null) return;
	
	createButton.setClassName(el)
};

createButton.getParentCoolButton = function (el) {
	if (el == null) return null;
	try{
		if (/coolButton/.test(el.className))
			return el;
		return createButton.getParentCoolButton(el.parentNode);
	}catch(ex){
		return null;
	}
};

/* end event listeners */

createButton.setClassName = function (el) {
	var over = el._over;
	var down = el._down;
	var focused;
	try {
		focused = (el == document.activeElement && el.tabIndex > 0);
	}
	catch (exc) {
		focused = false;
	}
	
	if (!el._enabled) {
		if (el._value)
			el.className = "coolButtonActiveDisabled";
		else
			el.className = el._alwaysUp ? "coolButtonUpDisabled" : "coolButtonDisabled";
	}
	else {
		if (el._value) {
			if (over || down || focused)
				el.className = "coolButtonActiveHover";
			else
				el.className = "coolButtonActive";
		}
		else {
			if (down)
				el.className = "coolButtonActiveHover";
			else if (over || el._alwaysUp || focused)
				el.className = "coolButtonHover";
			else
				el.className = "coolButton";
		}
	}
};

createButton.setEnabled = function (b) {
	if (this._enabled != b) {
		this._enabled = b;
		createButton.setClassName(this, false, false);
		if (!window.moz) {
			if (b)
				this.innerHTML = this.firstChild.firstChild.innerHTML;
			else
				this.innerHTML = "<span class='coolButtonDisabledContainer'><span class='coolButtonDisabledContainer'>" + this.innerHTML + "</span></span>";
		}
	}
};

createButton.getEnabled = function () {
	return this._enabled;
};

createButton.setValue = function (v, bDontTriggerOnChange) {
	if (this._toggle && this._value != v) {
		this._value = v;
		createButton.setClassName(this, false, false);
		
		this.onchange = this.getAttribute("onchange");
		
		if (this.onchange == null || this.onchange == "" || bDontTriggerOnChange) return;
		
		if (typeof this.onchange == "string")
			this.onchange = new Function("", this.onchange);

		this.onchange();
	}
};

createButton.getValue = function () {
	return this._value;
};

createButton.setToggle = function (t) {
	if (this._toggle != t) {
		this._toggle = t;
		if (!t) this.setValue(false);
	}
};

createButton.getToggle = function () {
	return this._toggle;
};

createButton.setAlwaysUp = function (up) {
	if (this._alwaysUp != up) {
		this._alwaysUp = up;
		createButton.setClassName(this, false, false);
	}
};

createButton.getAlwaysUp = function () {
	return this._alwaysUp;
};