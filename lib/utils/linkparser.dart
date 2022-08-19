import 'package:ice_live_viewer/utils/douyuparser.dart';

class LinkParser {
  /// Parses a link and returns its id.
  String getRoomId(String url) {
    String path = url.split("/").last;
    if (url.contains('topic')) {
      RegExpMatch? match = RegExp(r'[?&]rid=([^&#]+)').firstMatch(url);
      String? key = match?.group(1);
      return key!;
    } else {
      for (var i = 0; i < path.length; i++) {
        if (path[i] == "?") {
          return path.substring(0, i);
        }
      }
    }
    return path;
  }

  /// Parses a link and standardizes it.
  Future<String> formatUrl(String url) async {
    String roomId = getRoomId(url);
    if (url.contains("huya")) {
      return "https://m.huya.com/$roomId";
    } else if (url.contains("bilibili")) {
      return "https://live.bilibili.com/$roomId";
    } else if (url.contains("douyu")) {
      Douyu dyroom = Douyu(roomId);
      roomId = await dyroom.verifyLink();
      return "https://m.douyu.com/$roomId";
    } else {
      return '';
    }
  }

  /// Parses a link and checks its type.
  String checkType(String url) {
    if (url.contains("huya")) {
      return "huya";
    } else if (url.contains("bilibili")) {
      return "bilibili";
    } else if (url.contains("douyu")) {
      return "douyu";
    } else {
      return 'Unable to parse type!';
    }
  }
}
