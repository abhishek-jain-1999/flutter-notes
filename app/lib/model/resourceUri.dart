import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class ResourceUri {
  static String _normalized(String url) {
    if (url.isEmpty) return "";
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "http://" + url;
    }
    if (!url.endsWith('/')) {
      url = url + '/';
    }
    return url;
  }

  static Future<Uri> getBaseUri() async {
    var prefs = await SharedPreferences.getInstance();
    String? sharedPrefsBaseUrl = prefs.getString(Constants.DATABASE_BASE_URL);
    if (sharedPrefsBaseUrl != null && sharedPrefsBaseUrl.isNotEmpty) {
      return Uri.parse(_normalized(sharedPrefsBaseUrl));
    }
    const String envBaseUrl = String.fromEnvironment('DB_BASE_URL',
        defaultValue: 'http://localhost:3000/');
    prefs.setString(Constants.DATABASE_BASE_URL, envBaseUrl);
    return Uri.parse(_normalized(envBaseUrl));
  }

  static Future<Uri> getAppendedUri(String append) async {
    Uri baseUri = await getBaseUri();
    return Uri.parse(_normalized(baseUri.toString() + append));
  }
}
