import 'package:url_launcher/url_launcher.dart';


class WhatsAppUtils {
  static Future<void> openWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception(' Could not launch WhatsApp');
    }
  }
}

class UrlUtils {
  static Future<void> openSFApp() async {
    final Uri url = Uri.parse('https://ccsp-egmas.sf-express.com/download/download-hmto.html');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception(' Could not launch SF App');
    }
  }
}