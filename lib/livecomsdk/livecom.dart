import 'package:livecom/livecomsdk/livecom_conversion_product.dart';
import 'package:livecom/livecomsdk/livecom_delegate.dart';

import 'livecom_platform_interface.dart';

class LiveComSDK {

  LiveComDelegate? get delegate {
    return LiveComPlatform.instance.delegate;
  }

  set delegate(LiveComDelegate? value) {
    LiveComPlatform.instance.delegate = value;
  }

  bool get useCustomProductScreen {
    return LiveComPlatform.instance.useCustomProductScreen;
  }

  set useCustomProductScreen(bool value) {
    LiveComPlatform.instance.useCustomProductScreen = value;
  }

  bool get useCustomCheckoutScreen {
    return LiveComPlatform.instance.useCustomCheckoutScreen;
  }

  set useCustomCheckoutScreen(bool value) {
    LiveComPlatform.instance.useCustomCheckoutScreen = value;
  }
  
  void configure(
    String sdkKey,
    String primaryColor,
    String secondaryColor,
    String gradientFirstColor,
    String gradientSecondColor,
    String videoLinkTemplate,
    String productLinkTemplate
  ) {
    LiveComPlatform.instance.configure(sdkKey, primaryColor, secondaryColor, gradientFirstColor, gradientSecondColor, videoLinkTemplate, productLinkTemplate);
  }

  void presentStreams() {
    LiveComPlatform.instance.presentStreams();
  }

  void presentStream(String id) {
    LiveComPlatform.instance.presentStream(id);
  }

  void trackConversion(String orderId, int orderAmountInCents, String currency, List<LiveComConversionProduct> products) {
    List<Map<String, dynamic>> conversionProducts = [];
    products.forEach((product) {
      Map<String, dynamic> productMap = { "sku": product.sku, "name": product.name, "count": product.count, "stream_id": product.streamId };
      conversionProducts.add(productMap);
    });
    LiveComPlatform.instance.trackConversion(orderId, orderAmountInCents, currency, conversionProducts);
  }
}
