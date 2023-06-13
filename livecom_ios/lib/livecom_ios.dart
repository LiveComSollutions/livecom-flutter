import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:livecom_platform_interface/livecom_conversion_product.dart';
import 'package:livecom_platform_interface/livecom_delegate.dart';
import 'package:livecom_platform_interface/livecom_platform_interface.dart';

/// An implementation of [LivecomIOS] that uses method channels.
class LiveComIOS extends LiveComPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.livecom.ios');

static void registerWith() {
    LiveComPlatform.instance = LiveComIOS._privateConstructor();
  }

  LiveComIOS._privateConstructor();

  static final LiveComIOS shared = LiveComIOS._privateConstructor();

  LiveComDelegate? _delegate;
  bool _useCustomProductScreen = false;
  bool _useCustomCheckoutScreen = false;

  @override
  LiveComDelegate? get delegate => _delegate;

  @override
  set delegate(delegate) {
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

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "onRequestOpenProductScreen":
        String productSKU = methodCall.arguments["product_sku"];
        String streamId = methodCall.arguments["stream_id"];
        delegate?.onRequestOpenProductScreen(productSKU, streamId);
        break;
      case "onRequestOpenCheckoutScreen":
        List<String> productSKUs = List<String>.from(methodCall.arguments);
        delegate?.onRequestOpenCheckoutScreen(productSKUs);
        break;
      case "onProductAdd":
        String productSKU = methodCall.arguments["product_sku"];
        String streamId = methodCall.arguments["stream_id"];
        delegate?.onProductAdd(productSKU, streamId);
        break;
      case "onProductDelete":
        String productSKU = methodCall.arguments;
        delegate?.onProductDelete(productSKU);
        break;
      case "onCartChange":
        List<String> productSKUs = List<String>.from(methodCall.arguments);
        delegate?.onCartChange(productSKUs);
        break;
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
    methodChannel.setMethodCallHandler(invokedMethods);
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
  void trackConversion(String orderId, int orderAmountInCents, String currency, List<LiveComConversionProduct> products) {
    List<Map<String, dynamic>> conversionProducts = [];
    for (var product in products) {
      Map<String, dynamic> productMap = { "sku": product.sku, "name": product.name, "count": product.count, "stream_id": product.streamId };
      conversionProducts.add(productMap);
    }
    methodChannel.invokeMethod("trackConversion", [orderId, orderAmountInCents, currency, conversionProducts]);
  }
}

