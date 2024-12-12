package android;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end
import android.jni.JNICache;
import android.Permissions;
import haxe.io.Path;
import lime.app.Event;
import lime.math.Rectangle;
import lime.system.JNI;
import lime.utils.Log;
#if sys
import sys.io.Process;
#end

/**
 * A utility class for interacting with native Android functionality via JNI.
 */
class Tools
{
	/**
	 * Prompt the user to install a specific APK file.
	 *
	 * @param path The absolute path to the APK file.
	 */
	public static function installPackage(path:String):Void
	{
		final installPackageJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'installPackage', '(Ljava/lang/String;)Z');

		if (installPackageJNI != null)
		{
			if (!installPackageJNI(path))
				Log.warn('"REQUEST_INSTALL_PACKAGES" permission and "Install apps from external sources" setting must be granted to this app in order to install a '
					+ Path.extension(path).toUpperCase()
					+ ' file.');
		}
	}

	/**
	 * Adds the security flag to the application's window.
	 */
	public static inline function enableAppSecure():Void
	{
		final enableAppSecureJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'enableAppSecure', '()V');

		if (enableAppSecureJNI != null)
			enableAppSecureJNI();
	}

	/**
	 * Clears the security flag from the application's window.
	 */
	public static inline function disableAppSecure():Void
	{
		final disableAppSecureJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'disableAppSecure', '()V');

		if (disableAppSecureJNI != null)
			disableAppSecureJNI();
	}

	/**
	 * Launches an application by its package name.
	 *
	 * @param packageName The package name of the application to launch.
	 * @param requestCode The request code to pass along with the launch request.
	 */
	public static inline function launchPackage(packageName:String, requestCode:Int = 1):Void
	{
		final launchPackageJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'launchPackage', '(Ljava/lang/String;I)V');

		if (launchPackageJNI != null)
			launchPackageJNI(packageName, requestCode);
	}

	/**
	 * Shows an alert dialog with optional positive and negative buttons.
	 *
	 * @param title The title of the alert dialog.
	 * @param message The message content of the alert dialog.
	 * @param positiveButton Optional data for the positive button.
	 * @param negativeButton Optional data for the negative button.
	 */
	public static function showAlertDialog(title:String, message:String, ?positiveButton:ButtonData, ?negativeButton:ButtonData):Void
	{
		if (positiveButton == null)
			positiveButton = {name: null, func: null};

		if (negativeButton == null)
			negativeButton = {name: null, func: null};

		final showAlertDialogJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showAlertDialog',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V');

		if (showAlertDialogJNI != null)
			showAlertDialogJNI(title, message, positiveButton.name, new ButtonListener(positiveButton.func), negativeButton.name,
				new ButtonListener(negativeButton.func));
	}

	#if sys
	/**
	 * Checks if the device is rooted.
	 *
	 * @return `true` if the device is rooted; `false` otherwise.
	 */
	public static function isRooted():Bool
	{
		final exitCode:Null<Int> = new Process('su').exitCode(true);

		if (exitCode != null)
			return exitCode != 255;

		return false;
	}
	#end

	/**
	 * Checks if the device has Dolby Atmos support.
	 *
	 * @return `true` if the device has Dolby Atmos support; `false` otherwise.
	 */
	public static inline function isDolbyAtmos():Bool
	{
		final isDolbyAtmosJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isDolbyAtmos', '()Z');

		if (isDolbyAtmosJNI != null)
			return isDolbyAtmosJNI();

		return false;
	}

	/**
	 * Shows a minimal notification with a title and message.
	 *
	 * @param title The title of the notification.
	 * @param message The message content of the notification.
	 * @param channelID Optional ID of the notification channel.
	 * @param channelName Optional name of the notification channel.
	 * @param ID Optional unique ID for the notification.
	 */
	public static inline function showNotification(title:String, message:String, ?channelID:String = 'unknown_channel',
			?channelName:String = 'Unknown Channel', ?ID:Int = 1):Void
	{
		final showNotificationJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showNotification',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');

		if (showNotificationJNI != null)
			showNotificationJNI(title, message, channelID, channelName, ID);
	}

	/**
	 * Retrieves the dimensions of display cutouts (notches) as an array of rectangles.
	 *
	 * @return An array of `lime.math.Rectangle` objects representing the cutout areas. If there
	 *         are no cutouts or if the device does not support cutouts, an empty array is returned.
	 */
	public static function getCutoutDimensions():Array<Rectangle>
	{
		final getCutoutDimensionsJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getCutoutDimensions',
			'()[Landroid/graphics/Rect;');

		final cutoutRectangles:Array<Dynamic> = getCutoutDimensionsJNI != null ? (getCutoutDimensionsJNI() : Array<Dynamic>) : [];

		if (cutoutRectangles.length == 0)
			return [];

		final rectangles:Array<Rectangle> = [];

		for (rectangle in cutoutRectangles)
		{
			if (rectangle == null)
				continue;

			final top:Int = JNICache.createMemberField('android/graphics/Rect', 'top', 'I').get(rectangle);
			final left:Int = JNICache.createMemberField('android/graphics/Rect', 'left', 'I').get(rectangle);
			final right:Int = JNICache.createMemberField('android/graphics/Rect', 'right', 'I').get(rectangle);
			final bottom:Int = JNICache.createMemberField('android/graphics/Rect', 'bottom', 'I').get(rectangle);

			rectangles.push(new Rectangle(left, top, right - left, bottom - top));
		}

		return rectangles;
	}

	/**
	 * Sets the activity's title.
	 *
	 * @param title The title to set for the activity.
	 * @return `true` if the title was successfully set; `false` otherwise.
	 */
	public static function setActivityTitle(title:String):Bool
	{
		final setActivityTitleJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'setActivityTitle', '(Ljava/lang/String;)Z');

		if (setActivityTitleJNI != null)
			return setActivityTitleJNI(title);

		return false;
	}

	/**
	 * Minimizes the application's window.
	 */
	public static function minimizeWindow():Void
	{
		final minimizeWindowJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'minimizeWindow', '()V');

		if (minimizeWindowJNI != null)
			minimizeWindowJNI();
	}

	/**
	 * Checks if the device is running Android TV.
	 *
	 * @return `true` if the device is running Android TV; `false` otherwise.
	 */
	public static function isAndroidTV():Bool
	{
		final isAndroidTVJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isAndroidTV', '()Z');

		if (isAndroidTVJNI != null)
			return isAndroidTVJNI();

		return false;
	}

	/**
	 * Checks if the device is a tablet.
	 *
	 * @return `true` if the device is a tablet; `false` otherwise.
	 */
	public static function isTablet():Bool
	{
		final isTabletJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isTablet', '()Z');

		if (isTabletJNI != null)
			return isTabletJNI();

		return false;
	}

	/**
	 * Checks if the device is a Chromebook.
	 *
	 * @return `true` if the device is a Chromebook; `false` otherwise.
	 */
	public static function isChromebook():Bool
	{
		final isChromebookJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isChromebook', '()Z');

		if (isChromebookJNI != null)
			return isChromebookJNI();

		return false;
	}

	/**
	 * Checks if the device is running in DeX Mode.
	 *
	 * @return `true` if the device is running in DeX Mode; `false` otherwise.
	 */
	public static function isDeXMode():Bool
	{
		final isDeXModeJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isDeXMode', '()Z');

		if (isDeXModeJNI != null)
			return isDeXModeJNI();

		return false;
	}
}

/**
 * Data structure for defining button properties in an alert dialog.
 */
@:noCompletion
private typedef ButtonData =
{
	name:String,
	func:Void->Void
}

/**
 * Listener class for handling button click events in an alert dialog.
 */
@:noCompletion
private class ButtonListener #if (lime >= "8.0.0") implements JNISafety #end
{
	private var onClickEvent:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * Creates a new button listener with a specified callback function.
	 *
	 * @param clickCallback The function to execute when the button is clicked.
	 */
	public function new(clickCallback:Void->Void):Void
	{
		if (clickCallback != null)
			onClickEvent.add(clickCallback);
	}

	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onClick():Void
	{
		onClickEvent.dispatch();
	}
}
