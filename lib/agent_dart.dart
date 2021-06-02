
import 'dart:async';

import 'package:flutter/services.dart';

class AgentDart {
  static const MethodChannel _channel = MethodChannel('agent_dart');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
