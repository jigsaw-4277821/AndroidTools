package android;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end
import android.jni.JNICache;

using StringTools;

/**
 * Utility class for handling Android permissions via JNI.
 */
class Permissions
{
	/**
	 * Retrieves the list of permissions granted to the application.
	 *
	 * @return An array of granted permissions.
	 */
	public static function getGrantedPermissions():Array<String>
	{
		final getGrantedPermissionsJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getGrantedPermissions',
			'()[Ljava/lang/String;');

		if (getGrantedPermissionsJNI != null)
			return getGrantedPermissionsJNI();

		return [];
	}

	/**
	 * Requests a specific permission from the user via a dialog.
	 *
	 * @param permissions The permissions to request. This should be in the format ['android.permission.PERMISSION_NAME'].
	 * @param requestCode The request code to associate with this permission request.
	 */
	public static function requestPermissions(permissions:Array<String>, requestCode:Int = 1):Void
	{
		for (i in 0...permissions.length)
		{
			if (!permissions[i].startsWith('android.permission.'))
				permissions[i] = 'android.permission.${permissions[i]}';
		}

		final requestPermissionsJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'requestPermissions', '([Ljava/lang/String;I)V');

		if (requestPermissionsJNI != null)
			requestPermissionsJNI(permissions, requestCode);
	}
}
