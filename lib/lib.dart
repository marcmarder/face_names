import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<String> getRandomPicUrl() async {
  // get random pic url from api
  String url = "https://100k-faces.glitch.me/random-image-url";
  // make http request
  final request = await HttpClient().getUrl(Uri.parse(url));
  // wait for response
  final response = await request.close();
  // read response as string
  final responseBody = await response.transform(utf8.decoder).join();
  final json = jsonDecode(responseBody);
  // return the url
  return json['url'];
}

Future<Image> getImageFromUrl(String url) async {
  // make http request
  final request = await HttpClient().getUrl(Uri.parse(url));
  // wait for response
  final response = await request.close();
  // read response as bytes
  final bytes = await consolidateHttpClientResponseBytes(response);
  // return the image
  return Image.memory(bytes);
}

Future<String> loadFile(String path) async {
  String data;
  String newPath = path;

  if (kIsWeb) {
    newPath = path.replaceFirst("assets/", "");
  }
  data = await rootBundle.loadString(newPath);

  return data;
}
