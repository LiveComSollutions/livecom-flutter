import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:livecom/livecomsdk/livecom_delegate.dart';

import 'livecom_platform_interface.dart';

/// An implementation of [LiveComPlatform] that uses method channels.
class MethodChannelLiveCom extends LiveComPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('livecom');

  LiveComDelegate? _delegate;
  bool _useCustomProductScreen = false;
  bool _useCustomCheckoutScreen = false;

  @override
  LiveComDelegate? get delegate => _delegate;

  @override
  set delegate(LiveComDelegate? delegate) {
    _delegate = delegate;
  }

  @override
  bool get useCustomProductScreen => _useCustomProductScreen;

  @override
  set useCustomProductScreen(bool useCustomProductScreen) {
    _useCustomProductScreen = useCustomProductScreen;
    methodChannel.invokeMethod("useCustomProductScreen", useCustomProductScreen);
  }

  @override
  bool get useCustomCheckoutScreen => _useCustomCheckoutScreen;

  @override
  set useCustomCheckoutScreen(bool useCustomCheckoutScreen) {
    _useCustomCheckoutScreen = useCustomCheckoutScreen;
    methodChannel.invokeMethod("useCustomCheckoutScreen", useCustomCheckoutScreen);
  }

  MethodChannelLiveCom() { 
    methodChannel.setMethodCallHandler(invokedMethods);
  }

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "onRequestOpenProductScreen":
        String productSKU = methodCall.arguments["product_sku"];
        String streamId = methodCall.arguments["stream_id"];
        delegate?.onRequestOpenProductScreen(productSKU, streamId);
      case "onRequestOpenCheckoutScreen":
        List<String> productSKUs = List<String>.from(methodCall.arguments);
        delegate?.onRequestOpenCheckoutScreen(productSKUs);
      case "onProductAdd":
        String productSKU = methodCall.arguments["product_sku"];
        String streamId = methodCall.arguments["stream_id"];
        delegate?.onProductAdd(productSKU, streamId);
      case "onProductDelete":
        String productSKU = methodCall.arguments;
        delegate?.onProductDelete(productSKU);
      case "onCartChange":
        List<String> productSKUs = List<String>.from(methodCall.arguments);
        delegate?.onCartChange(productSKUs);
    }
  }
  
  @override
  void configure(
    String sdkKey,
    String primaryColor,
    String secondaryColor,
    String gradientFirstColor,
    String gradientSecondColor,
    String videoLinkTemplate,
    String productLinkTemplate
  ) {
    methodChannel.invokeMethod(
      "configure", [
        sdkKey,
        primaryColor,
        secondaryColor,
        gradientFirstColor,
        gradientSecondColor,
        videoLinkTemplate,
        productLinkTemplate
       ]
    );
  }

  @override
  void presentStreams() {
    methodChannel.invokeMethod("presentStreams");
  }

  @override
  void presentStream(String id) {
    methodChannel.invokeMethod("presentStream", id);
  }

  @override
  void trackConversion(String orderId, int orderAmountInCents, String currency, List<Map<String, dynamic>> products) {
        methodChannel.invokeMethod("trackConversion", [orderId, orderAmountInCents, currency, products]);
  }
}
