/**
 * WARNING! THIS IS A GENERATED FILE, AND WILL BE RE-GENERATED EACH TIME THE
 * AJAXBRIDGE IS RUN.
 *
 * You should keep your javascript code inside this file as light as possible, 
 * and rather keep the body of your Ajax application in separate *.js files. 
 *
 * Do make a backup of your changes, before re-generating this file (AjaxBridge 
 * will display a warning message to you).
 *
 * Please refer to the built-in documentation inside the AjaxBridge application 
 * for help on using this file.
 */
 
 
/**
 * Application "playErrorSound.mxml"
 */

/**
 * The "playErrorSound" javascript namespace. All the functions/variables you
 * have selected under the "playErrorSound.mxml" in the tree will be
 * available as static members of this namespace object.
 */
playErrorSound = {};


/**
 * Listen for the instantiation of the Flex application over the bridge
 */
FABridge.addInitializationCallback("b_playErrorSound", playErrorSoundReady);


/**
 * Hook here all the code that must run as soon as the "playErrorSound" class
 * finishes its instantiation over the bridge.
 *
 * For basic tasks, such as running a Flex method on the click of a javascript
 * button, chances are that both Ajax and Flex may well have loaded before the 
 * user actually clicks the button.
 *
 * However, using the "playErrorSoundReady()" is the safest way, as it will 
 * let Ajax know that involved Flex classes are available for use.
 */
function playErrorSoundReady() {

	// Initialize the "root" object. This represents the actual 
	// "playErrorSound.mxml" flex application.
	b_playErrorSound_root = FABridge["b_playErrorSound"].root();
	

	// Global variables in the "playErrorSound.mxml" application (converted 
	// to getters and setters)

	playErrorSound.getErrorSound = function () {
		return b_playErrorSound_root.getErrorSound();
	};


	// Global functions in the "playErrorSound.mxml" application

}
