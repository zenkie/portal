Menu.prototype.cssFile ="/html/nds/js/menu4/skins/officexp/officexp.css";

var tmp;

// Build context menu
var cMenu = new Menu();

var openItem, openNewWinItem,saveAsItem;

cMenu.add( openItem = new MenuItem( "��(O)" ) );
openItem.mnemonic = "o";
cMenu.add( openNewWinItem = new MenuItem( "���´����д�(N)") );
openNewWinItem.mnemonic = "n";
cMenu.add( saveAsItem = new MenuItem( "Ŀ�����Ϊ(A)...", function(){document.execCommand( "SaveAs" );}) );
saveAsItem.mnemonic = "a";

var backItem, forwardItem, refreshItem;

cMenu.add( backItem = new MenuItem( "����(B)", function () { window.history.go(-1); }) );
backItem.mnemonic = "b";
cMenu.add( forwardItem = new MenuItem( "ǰ��(O)", function () { window.history.go(1); } ) );
forwardItem.mnemonic = "o";
cMenu.add( refreshItem = new MenuItem( "ˢ��(R)", function () { document.location.reload(); } ) );
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


eMenu.add( cutItem = new MenuItem( "����(T)", function () { document.execCommand( "Cut" ); } ) );
cutItem.mnemonic = "t";

eMenu.add( copyItem = new MenuItem( "����(C)", function () { document.execCommand( "Copy" ); }) );
copyItem.mnemonic = "c";

eMenu.add( pasteItem = new MenuItem( "ճ��(P)", function () { document.execCommand( "Paste" ); } ) );
pasteItem.mnemonic = "p";

eMenu.add( deleteItem = new MenuItem( "ɾ��(D)", function () { document.execCommand( "Delete" ); } ) );
deleteItem.mnemonic = "d";


eMenu.add( new MenuSeparator() );


eMenu.add( selectAllItem = new MenuItem( "ȫѡ(A)", function () { document.execCommand( "SelectAll" ); } ) );
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

