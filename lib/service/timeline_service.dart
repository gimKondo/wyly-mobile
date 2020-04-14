import 'package:flutter/material.dart';

import 'functions_service.dart';

/// Provide operation for timeline
class TimelineService {
  factory TimelineService() => _instance;
  TimelineService._internal();
  static final _instance = TimelineService._internal();

  /// Create timeline item
  /// When user "search around", user gets new timeline item.
  Future<dynamic> createItem(BuildContext context) async {
    try {
      final result = await FunctionsService(context)
          .callFunction('searchAround', <String, dynamic>{});
      debugPrint('success to call searchAround. data:[${result.data}]');
      return result.data;
    } on Exception catch (e, stacktrace) {
      debugPrint('fail to call searchAround. ${e.toString()}: $stacktrace');
      return null;
    }
  }
}
