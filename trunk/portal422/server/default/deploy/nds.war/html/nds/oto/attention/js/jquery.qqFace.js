var qqSub={
"0": "微笑",
"1": "撇嘴",
"2": "色",
"3": "发呆",
"4": "得意",
"5": "流泪",
"6": "害羞",
"7": "闭嘴",
"8": "睡",
"9": "大哭",
"10": "尴尬",
"11": "发怒",
"12": "调皮",
"13": "呲牙",
"14": "惊讶",
"15": "难过",
"16": "酷",
"17": "冷汗",
"18": "抓狂",
"19": "吐",
"20": "偷笑",
"21": "可爱",
"22": "白眼",
"23": "傲慢",
"24": "饥饿",
"25": "困",
"26": "惊恐",
"27": "流汗",
"28": "憨笑",
"29": "大兵",
"30": "奋斗",
"31": "咒骂",
"32": "疑问",
"33": "嘘",
"34": "晕",
"35": "折磨",
"36": "衰",
"37": "骷髅",
"38": "敲打",
"39": "再见",
"40": "擦汗",
"41": "抠鼻",
"42": "鼓掌",
"43": "糗大了",
"44": "坏笑",
"45": "左哼哼",
"46": "右哼哼",
"47": "哈欠",
"48": "鄙视",
"49": "委屈",
"50": "快哭了",
"51": "阴险",
"52": "亲亲",
"53": "吓",
"54": "可怜",
"55": "菜刀",
"56": "西瓜",
"57": "啤酒",
"58": "篮球",
"59": "乒乓",
"60": "咖啡",
"61": "饭",
"62": "猪头",
"63": "玫瑰",
"64": "凋谢",
"65": "示爱",
"66": "爱心",
"67": "心碎",
"68": "蛋糕",
"69": "闪电",
"70": "炸弹",
"71": "刀",
"72": "足球",
"73": "瓢虫",
"74": "便便",
"75": "月亮",
"76": "太阳",
"77": "礼物",
"78": "拥抱",
"79": "强",
"80": "弱",
"81": "握手",
"82": "胜利",
"83": "抱拳",
"84": "勾引",
"85": "拳头",
"86": "差劲",
"87": "爱你",
"88": "NO",
"89": "OK",
"90": "爱情",
"91": "飞吻",
"92": "跳跳",
"93": "发抖",
"94": "怄火",
"95": "转圈",
"96": "磕头",
"97": "回头",
"98": "跳绳",
"99": "挥手",
"100": "激动",
"101": "街舞",
"102": "献吻",
"103": "左太极",
"104": "右太极"
};
// QQ表情插件
(function($){  
	$.fn.qqFace = function(options){
		var defaults = {
			id : 'facebox',
			path : 'face/',
			assign : 'content',
			tip : 'em_'
		};
		var option = $.extend(defaults, options);
		
		var id = option.id;
		var path = option.path;
		var tip = option.tip;
		
		$(this).click(function(e){
			var strFace, labFace;
			if($('#'+id).length<=0){
				// strFace = '<div id="'+id+'" style="position:fixed;display:none;z-index:1000;" class="qqFace">' +
							  // '<table border="0" cellspacing="0" cellpadding="0"><tr>';
			  strFace = '<div id="'+id+'" style="display:none;z-index:1000;" class="qqFace">' +
							'<table border="0" cellspacing="0" cellpadding="0"><tr>';
				for(var i=0; i<=104; i++){
					labFace = '/'+qqSub[i];
					strFace += '<td><img src="'+path+i+'.gif" onclick="addImg(this)"  data-title="'+qqSub[i]+'" title="/'+qqSub[i]+'"/></td>';
					if( i % 15 == 14) strFace += '</tr><tr>';
				}
				strFace += '</tr></table></div>';
			}
			// $(this).parent().append(strFace);
			$($(".float-p")[0]).parent().append(strFace);
			var offset = $(this).position();
			var top = offset.top + $(this).outerHeight();
			//$('#'+id).css('top',top);
			//$('#'+id).css('left',offset.left);
			$('#'+id).show();
			e.stopPropagation();
		});

		$(document).click(function(){
			$('#'+id).hide();
			$('#'+id).remove();
		});
	};

})(jQuery);
var range;
var selection;

//document.selection ? document.selection : (window.getSelection || document.getSelection)();

function addImg(obj){
		if(jQuery.isEmptyObject(range)){
			jQuery("#txtReplyWords").html(jQuery("#txtReplyWords").html()+'<img data-title="'+jQuery(obj).attr("data-title")+'" src="'+obj.src+'">');
			jQuery("#spnCnt").text(mbStringLength());
			return;
		}
		if (!window.getSelection){
			document.getElementById('txtReplyWords').focus();
			selection= window.getSelection ? window.getSelection() : document.selection;
			range= selection.createRange ? selection.createRange() : selection.getRangeAt(0);
			range.pasteHTML('<img data-title="'+jQuery(obj).attr("data-title")+'" src="'+obj.src+'">');
			range.collapse(false);
			range.select();
		}else{
			document.getElementById('txtReplyWords').focus();
			range.collapse(false);
			var hasR = range.createContextualFragment('<img data-title="'+jQuery(obj).attr("data-title")+'" src="'+obj.src+'">');
			var hasR_lastChild = hasR.lastChild;
			while (hasR_lastChild && hasR_lastChild.nodeName.toLowerCase() == "br" && hasR_lastChild.previousSibling && hasR_lastChild.previousSibling.nodeName.toLowerCase() == "br") {
			var e = hasR_lastChild;
			hasR_lastChild = hasR_lastChild.previousSibling;
			hasR.removeChild(e)
			}                                
			range.insertNode(hasR);
			if (hasR_lastChild) {
			range.setEndAfter(hasR_lastChild);
			range.setStartAfter(hasR_lastChild)
			}
			selection.removeAllRanges();
			selection.addRange(range)
		}
		jQuery("#spnCnt").text(mbStringLength());
		
	//$("#show").html($("#show").html()+'');
}
jQuery.extend({ 
unselectContents: function(){ 
	if(window.getSelection) 
		window.getSelection().removeAllRanges(); 
	else if(document.selection) 
		document.selection.empty(); 
	} 
}); 
jQuery.fn.extend({ 
	selectContents: function(){ 
		$(this).each(function(i){ 
			var node = this; 
			var selection, range, doc, win; 
			if ((doc = node.ownerDocument) && (win = doc.defaultView) && typeof win.getSelection != 'undefined' && typeof doc.createRange != 'undefined' && (selection = window.getSelection()) && typeof selection.removeAllRanges != 'undefined'){ 
				range = doc.createRange(); 
				range.selectNode(node); 
				if(i == 0){ 
					selection.removeAllRanges(); 
				} 
				selection.addRange(range); 
			} else if (document.body && typeof document.body.createTextRange != 'undefined' && (range = document.body.createTextRange())){ 
				range.moveToElementText(node); 
				range.select(); 
			} 
		}); 
	}, 

	setCaret: function(){ 
		if(!$.browser.msie) return; 
		var initSetCaret = function(){ 
			var textObj = $(this).get(0); 
			textObj.caretPos = document.selection.createRange().duplicate(); 
		}; 
		$(this).click(initSetCaret).select(initSetCaret).keyup(initSetCaret); 
	}, 

	insertAtCaret: function(textFeildValue){ 
		var textObj = $(this).get(0); 
		if(document.all && textObj.createTextRange && textObj.caretPos){ 
			var caretPos=textObj.caretPos; 
			caretPos.text = caretPos.text.charAt(caretPos.text.length-1) == '' ? 
			textFeildValue+'' : textFeildValue; 
		} else if(textObj.setSelectionRange){ 
			var rangeStart=textObj.selectionStart; 
			var rangeEnd=textObj.selectionEnd; 
			var tempStr1=textObj.value.substring(0,rangeStart); 
			var tempStr2=textObj.value.substring(rangeEnd); 
			textObj.value=tempStr1+textFeildValue+tempStr2; 
			textObj.focus(); 
			var len=textFeildValue.length; 
			textObj.setSelectionRange(rangeStart+len,rangeStart+len); 
			textObj.blur(); 
		}else{ 
			textObj.value+=textFeildValue; 
		} 
	} 
});


function insertHtmlToRange(domNode, inputTarget) {
        if(domNode == null || inputTarget == null){
            return;
        }
        var sel = null;
        var rang = null;
        if( window.getSelection() ){
            sel = window.getSelection();
            rang = sel.rangeCount > 0 ? sel.getRangeAt(0) : null;
            if (rang === null) {
                var message = "无法插入内容";
                $.tipsWindown({content:'text:' + message, singleButton:true});
                return;
            }
            rang.deleteContents();
            // 如果选择的对象是输入框时执行操作
            if (sel.focusNode === inputTarget.innerHTML
                    || sel.focusNode.parentElement === inputTarget
                    || sel.focusNode === inputTarget) {
                rang.insertNode(domNode);
            } else {
                var tipMessage = "无法插入内容，请检查焦点是否在输入框中";
                $.tipsWindown({content:'text:' + tipMessage, singleButton:true});
                return;
            }
            //光标移动至末尾
            if (document.implementation && document.implementation.hasFeature && document.implementation.hasFeature("Range", "2.0")) {
                var tempRange = document.createRange();
                var chatmessage = inputTarget;
                var position = rang.endOffset;
                tempRange.selectNodeContents(chatmessage);
                tempRange.setStart(rang.endContainer, rang.endOffset);
                tempRange.setEnd(rang.endContainer, rang.endOffset);
                sel.removeAllRanges();
                sel.addRange(tempRange);
            }
        }else{//ie9 以下版本
            textRange = document.selection.createRange();
            if (textRange === null) {
                var message = "无法插入内容";
                $.tipsWindown({content:'text:' + message, singleButton:true});
                return;
            }
            //插入 dom节点
            textRange.collapse(false)
            textRange.pasteHTML(domNode.outerHTML); 
            textRange.select();
        }
    }