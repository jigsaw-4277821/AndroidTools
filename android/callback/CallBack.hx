package android.callback;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end
import android.jni.JNICache;
import haxe.Json;
import lime.app.Event;
import lime.system.JNI;

using StringTools;

/**
 * Utility class to manage callbacks from native code using JNI.
 * This class provides initialization methods and events for handling
 * activity results and permissions results from native code.
 */
class CallBack
{
	/**
	 * Event triggered when an activity result is received.
	 * Handlers should expect a dynamic argument.
	 */
	public static var onActivityResult:Event<Dynamic->Void>;

	/**
	 * Event triggered when a permissions result is received.
	 * Handlers should expect a dynamic argument.
	 */
	public static var onRequestPermissionsResult:Event<Dynamic->Void>;

	@:noCompletion
	private static var initialized:Bool = false;

	/**
	 * Initializes the callback handling mechanism.
	 * This method should be called once before using any callback events.
	 */
	public static function init():Void
	{
		if (initialized)
			return;

		onActivityResult = new Event<Dynamic->Void>();
		onRequestPermissionsResult = new Event<Dynamic->Void>();

		JNICache.createStaticMethod('org/haxe/extension/Tools', 'initCallBack', '(Lorg/haxe/lime/HaxeObject;)V')(new CallBackHandler());

		initialized = true;
	}
}

/**
 * Internal class to handle native callback events.
 */
@:keep
@:noCompletion
private class CallBackHandler #if (lime >= "8.0.0") implements JNISafety #end
{
	public function new():Void {}

	/**
	 * Handles the activity result callback from native code.
	 *
	 * @param content The JSON string containing the activity result data.
	 */
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onActivityResult(content:String):Void
	{
		if (CallBack.onActivityResult != null)
			CallBack.onActivityResult.dispatch(Json.parse(content.trim()));
	}

	/**
	 * Handles the permissions result callback from native code.
	 *
	 * @param content The JSON string containing the permissions result data.
	 */
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onRequestPermissionsResult(content:String):Void
	{
		if (CallBack.onRequestPermissionsResult != null)
			CallBack.onRequestPermissionsResult.dispatch(Json.parse(content.trim()));
	}
}
