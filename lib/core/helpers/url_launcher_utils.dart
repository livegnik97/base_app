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
          query: subject != null
              ? "subject=${Uri.encodeComponent(subject)}"
              : null,
        ),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    return false;
  }

  static Future<bool> whatsapp(String phone) async {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return false;
    return openUrl('https://wa.me/$digits');
  }

  static Future<bool> telegram(String phone) async {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return false;
    return openUrl('tg://resolve?phone=$digits');
  }

  static Future<bool> openUrl(String url) async {
    try {
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    return false;
  }

  static String getIcon(String url) {
    return "https://icons.duckduckgo.com/ip3/${url.replaceAll("http://", "").replaceAll("https://", "")}.ico";
  }
}
