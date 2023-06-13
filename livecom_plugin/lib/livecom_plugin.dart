// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:livecom_platform_interface/livecom_conversion_product.dart';
import 'package:livecom_platform_interface/livecom_delegate.dart';
import 'package:livecom_platform_interface/livecom_platform_interface.dart';

class LiveComPlugin extends LiveComPlatform {
   

  @override
  LiveComDelegate? get delegate => LiveComPlatform.instance.delegate;

  @override
  set delegate(delegate) {
     LiveComPlatform.instance.delegate = delegate;
  }
  
  @override
  bool get useCustomProductScreen => LiveComPlatform.instance.useCustomProductScreen;

  @override
  set useCustomProductScreen(bool useCustomProductScreen) {
    LiveComPlatform.instance.useCustomProductScreen = useCustomProductScreen;
  }

  @override
  bool get useCustomCheckoutScreen => LiveComPlatform.instance.useCustomCheckoutScreen;

  @override
  set useCustomCheckoutScreen(bool useCustomCheckoutScreen) {
    LiveComPlatform.instance.useCustomCheckoutScreen = useCustomCheckoutScreen;
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
    LiveComPlatform.instance.configure(sdkKey, primaryColor, secondaryColor, gradientFirstColor, gradientSecondColor, videoLinkTemplate, productLinkTemplate);
  } 

  @override
  void presentStreams() {
    LiveComPlatform.instance.presentStreams();
  }

  @override
  void presentStream(String id) {
    LiveComPlatform.instance.presentStream(id);
  }

  @override
  void trackConversion(String orderId, int orderAmountInCents, String currency, List<LiveComConversionProduct> products) {
    LiveComPlatform.instance.trackConversion(orderId, orderAmountInCents, currency, products);
  }
}
