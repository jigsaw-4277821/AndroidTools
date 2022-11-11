package android.widget;

#if (!android && !native && macro)
#error 'extension-androidtools is not supported on your current platform'
#end
import lime.system.JNI;

/**
 * @see https://developer.android.com/reference/android/widget/Toast
 * 
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
#if !debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.system.JNI)
class Toast
{
	public static final LENGTH_SHORT:Int = 0;
	public static final LENGTH_LONG:Int = 1;

	private var constructor:Dynamic;

	public function new():Void
	{
		var constructor_jni:Dynamic = JNI.createStaticMethod('android/widget/Toast', '<init>', '(Landroid/content/Context;)V');
		var mainContext:Dynamic = JNI.createStaticField('org/haxe/extension/Extension', 'mainContext', 'Landroid/content/Context;');
		constructor = constructor_jni(mainContext.get());
	}

	public function cancel():Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'cancel', '()V'), constructor, []);

	public function getDuration():Int
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getDuration', '()I'), constructor, []);

	public function getGravity():Int
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getGravity', '()I'), constructor, []);

	public function getHorizontalMargin():Float
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getHorizontalMargin', '()F'), constructor, []);

	public function getVerticalMargin():Float
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getVerticalMargin', '()F'), constructor, []);

	public function getXOffset():Int
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getXOffset', '()I'), constructor, []);

	public function getYOffset():Int
		return JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'getYOffset', '()I'), constructor, []);

	public static function makeText(text:String, duration:Int):Toast
	{
		var toast_jni:Dynamic = JNI.createStaticMethod('android/widget/Toast', 'makeText', '(Landroid/content/Context;Ljava/lang/String;I)V');
		var mainContext:Dynamic = JNI.createStaticField('org/haxe/extension/Extension', 'mainContext', 'Landroid/content/Context;');

		constructor = makeText_jni(mainContext.get(), text, duration);
		return this;
	}

	public function setDuration(duration:Int):Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'setDuration', '(I)V'), constructor, [duration]);

	public function setGravity(gravity:Int, xOffset:Int, yOffset:Int):Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'setGravity', '(III)V'), constructor, [gravity, xOffset, yOffset]);

	public function setMargin(horizontalMargin:Float, verticalMargin:Float):Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'setMargin', '(FF)V'), constructor, [horizontalMargin, verticalMargin]);

	public function setText(s:String):Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'setText', '(Ljava/lang/CharSequence;)V'), constructor, [s]);

	public function show():Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'show', '()V'), constructor, []);

	public function cancel():Void
		JNI.callMember(JNI.createMemberMethod('android/widget/Toast', 'cancel', '()V'), constructor, []);

	private function getMemberMethod(name:String, sig:String):Dynamic
		return JNI.createMemberMethod('android/widget/Toast', name, sig);
}
