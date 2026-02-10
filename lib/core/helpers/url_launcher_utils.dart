import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  /*
  Add this to your AndroidManifest.xml
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="tel" />
        </intent>
  */
  static Future<bool> call(String phone) async {
    try {
      return await launchUrl(
        Uri(scheme: "tel", path: phone),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    return false;
  }

  /*
  Add this to your AndroidManifest.xml
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="sms" />
        </intent>
  */
  static Future<bool> sms(String phone) async {
    try {
      return await launchUrl(
        Uri(scheme: "sms", path: phone),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    return false;
  }

  /*
  Add this to your AndroidManifest.xml
        <intent>
            <action android:name="android.intent.action.SEND" />
            <data android:mimeType="*\/\*" /> //Quitar los '\' en el manifest
        </intent>
  */
  static Future<bool> email(String email, [String? subject]) async {
    try {
      return await launchUrl(
        Uri(
          scheme: "mailto",
          path: email,
          query:
              subject != null
                  ? "subject==${Uri.encodeComponent(subject)}"
                  : null,
        ),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    return false;
  }
}
