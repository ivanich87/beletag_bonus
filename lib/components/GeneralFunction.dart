
import 'package:url_launcher/url_launcher.dart';

makingPhoneCall(phone, tip) async {
  var url = Uri.parse("tel:$phone");

  if (tip==2) {
    url = Uri.parse("sms:$phone");
  };
  if (tip==3) {
    url = Uri.parse("mailto:$phone?subject=News&body=New%20plugin");
  };
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  };
}

