import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'livecom_delegate.dart';
import 'livecom_platform_interface.dart';

/// An implementation of [LiveComPlatform] that uses method channels.
class MethodChannelLiveCom extends LiveComPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.livecom');
  
  @override
  LiveComDelegate? get delegate => null;

  @override
  bool get useCustomProductScreen => false;

  @override
  set useCustomProductScreen(bool useCustomProductScreen) {
  }

  @override
  bool get useCustomCheckoutScreen => false;

  @override
  set useCustomCheckoutScreen(bool useCustomCheckoutScreen) {
  }
  
  @override
  set delegate(LiveComDelegate? delegate) {
  }
}
