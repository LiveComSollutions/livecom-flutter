import 'package:livecom/livecomsdk/livecom_delegate.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'livecom_method_channel.dart';

abstract class LiveComPlatform extends PlatformInterface {
  /// Constructs a LivecomPlatform.
  LiveComPlatform() : super(token: _token);

  static final Object _token = Object();

  static LiveComPlatform _instance = MethodChannelLiveCom();

  /// The default instance of [LiveComPlatform] to use.
  ///
  /// Defaults to [MethodChannelLivecom].
  static LiveComPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LiveComPlatform] when
  /// they register themselves.
  static set instance(LiveComPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  LiveComDelegate? get delegate;
  set delegate(LiveComDelegate? delegate);

  bool get useCustomProductScreen;
  set useCustomProductScreen(bool useCustomProductScreen);

  bool get useCustomCheckoutScreen;
  set useCustomCheckoutScreen(bool useCustomCheckoutScreen);

  void configure(
    String sdkKey,
    String primaryColor,
    String secondaryColor,
    String gradientFirstColor,
    String gradientSecondColor,
    String videoLinkTemplate,
    String productLinkTemplate
  ) {
    throw UnimplementedError('configure() has not been implemented.');
  }

  void presentStreams() { 
    throw UnimplementedError('presentStreams() has not been implemented.');
  }

  void presentStream(String id) { 
    throw UnimplementedError('presentStream(String id) has not been implemented.');
  }

  void trackConversion(String orderId, int orderAmountInCents, String currency, List<Map<String, dynamic>> products) { 
    throw UnimplementedError('presentStream(String id) has not been implemented.');
  }
}
