Menu.prototype.cssFile ="/html/nds/js/menu4/skins/officexp/officexp.css";

var tmp;

// Build context menu
var cMenu = new Menu();

var openItem, openNewWinItem,saveAsItem;

cMenu.add( openItem = new MenuItem( "打开(O)" ) );
openItem.mnemonic = "o";
cMenu.add( openNewWinItem = new MenuItem( "在新窗口中打开(N)") );
openNewWinItem.mnemonic = "n";
cMenu.add( saveAsItem = new MenuItem( "目标另存为(A)...", function(){document.execCommand( "SaveAs" );}) );
saveAsItem.mnemonic = "a";

var backItem, forwardItem, refreshItem;

cMenu.add( backItem = new MenuItem( "后退(B)", function () { window.history.go(-1); }) );
backItem.mnemonic = "b";
cMenu.add( forwardItem = new MenuItem( "前进(O)", function () { window.history.go(1); } ) );
forwardItem.mnemonic = "o";
cMenu.add( refreshItem = new MenuItem( "刷新(R)", function () { document.location.reload(); } ) );
refreshItem.mnemonic = "r";


// edit menu
var eMenu = new Menu()

var undoItem, cutItem, copyItem, pasteItem, deleteItem, selectAllItem;

// undo is broken in IE
// eMenu.add( undoItem = new MenuItem( "Undo", function () { document.execCommand( "Undo" ); }, "images/undo.small.png" ) );
// undoItem.mnemonic = "u";
//
//
// eMenu.add( new MenuSeparator() );


eMenu.add( cutItem = new MenuItem( "剪切(T)", function () { document.execCommand( "Cut" ); } ) );
cutItem.mnemonic = "t";

eMenu.add( copyItem = new MenuItem( "复制(C)", function () { document.execCommand( "Copy" ); }) );
copyItem.mnemonic = "c";

eMenu.add( pasteItem = new MenuItem( "粘贴(P)", function () { document.execCommand( "Paste" ); } ) );
pasteItem.mnemonic = "p";

eMenu.add( deleteItem = new MenuItem( "删除(D)", function () { document.execCommand( "Delete" ); } ) );
deleteItem.mnemonic = "d";


eMenu.add( new MenuSeparator() );


eMenu.add( selectAllItem = new MenuItem( "全选(A)", function () { document.execCommand( "SelectAll" ); } ) );
selectAllItem.mnemonic = "a";




var oldOpenState = null;	// used to only change when needed
var lastKeyCode = 0;

function rememberKeyCode() {
	lastKeyCode = window.event.keyCode;
}

function showContextMenu() {

	var el = window.event.srcElement;

	// check for edit
	var showEditMenu = el != null &&
						(el.tagName == "INPUT" || el.tagName == "TEXTAREA");

	// check for anchor
	while ( el != null && el.tagName != "A" )
		el = el.parentNode;

	var showOpenItems = el != null && el.tagName == "A";

	if ( showOpenItems != oldOpenState ) {
		openItem.visible		= showOpenItems;
		openNewWinItem.visible	= showOpenItems && (el.href.indexOf("(")==-1);
		saveAsItem.visible	= showOpenItems && (el.href.indexOf("(")==-1 && el.href.indexOf("binserv")!=-1 );
		backItem.visible		= !showOpenItems;
		forwardItem.visible		= !showOpenItems;
		refreshItem.visible		= !showOpenItems;
		oldOpenState = showOpenItems;
	}

	if ( showOpenItems ) {
		openItem.action =  el.href;
		openNewWinItem.action ="javascript:popup_window('"+ el.href+"','_blank')";
	}

	// find left and top
	var left, top;

	if ( showEditMenu )
		el = window.event.srcElement;
	else if ( !showOpenItems )
		el = document.documentElement;

	if ( lastKeyCode == 93 ) {	// context menu key
		left = posLib.getScreenLeft( el );
		top = posLib.getScreenTop( el );
	}
	else {
		left = window.event.screenX;
		top = window.event.screenY;
	}

	if ( showEditMenu ) {

		// undo is broken in IE
		// undoItem.disabled =			!document.queryCommandEnabled( "Undo" );
		cutItem.disabled =			!document.queryCommandEnabled( "Cut" );
		copyItem.disabled =			!document.queryCommandEnabled( "Copy" );
		pasteItem.disabled =		!document.queryCommandEnabled( "Paste" );
		deleteItem.disabled =		!document.queryCommandEnabled( "Delete" );
		selectAllItem.disabled =	!document.queryCommandEnabled( "SelectAll" );

		eMenu.invalidate();
		eMenu.show( left, top );
	}
	else {
		cMenu.invalidate();
		cMenu.show( left, top );
	}

	event.returnValue = false;
	lastKeyCode = 0
};
function noContextMenu() {
	event.returnValue = false;
	return false;
}
document.attachEvent( "oncontextmenu",noContextMenu );

