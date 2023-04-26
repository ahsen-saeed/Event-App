import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:event_app/backend/backend_response.dart';
import 'package:flutter/foundation.dart';

class SharedWebService {
  static const String _BASE_URL = 'https://app.ticketmaster.com/discovery/v2/';
  static const String _API_KEY = 'jAluwH1oO5zvalsfQOD5S7KCeNVuDjhu';

  final HttpClient _client = HttpClient();
  final Duration _timeoutDuration = const Duration(seconds: 40);

  static SharedWebService? _instance;

  SharedWebService._();

  static SharedWebService instance() {
    _instance ??= SharedWebService._();
    return _instance!;
  }

  Future<HttpClientResponse> _responseFrom(Future<HttpClientRequest> Function(Uri) toCall, {required Uri uri, Map<String, String>? headers}) =>
      toCall(uri).then((request) {
        if (headers != null) headers.forEach((key, value) => request.headers.add(key, value));
        return request.close();
      }).timeout(_timeoutDuration);

  Future<HttpClientResponse> _get(Uri uri, [Map<String, String>? headers]) => _responseFrom(_client.getUrl, uri: uri, headers: headers);

  Future<List<Event>> events(int pageNumber) async {
    final uri = Uri.parse('${_BASE_URL}events?size=20&page=$pageNumber&apikey=$_API_KEY');
    final response = await _get(uri);

    List<Event> parseEvents(dynamic responseBody) {
      final Map<String, dynamic> embeddedMap = responseBody.containsKey('_embedded') ? responseBody['_embedded'] : {};
      return embeddedMap.containsKey('events') ? (embeddedMap['events'] as List<dynamic>).map((e) => Event.fromJson(e)).toList() : <Event>[];
    }

    return compute(parseEvents, json.decode(await response.transform(utf8.decoder).join()));
  }
}
