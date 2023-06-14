This repository contains wrappers and a demo project.

## Installation
Run this command:
With Flutter:
```$ flutter pub add livecom_plugin```
This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):
```dependencies:
  livecom_plugin: ^1.1.1
  ```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:
```import 'package:livecom_plugin/livecom_plugin.dart'; ```

## Initialize SDK
To initialize LiveCom SDK, you need pass:
SDK Key, Appearence (primaryColor, secondaryColor, gradientFirstColor, gradientSecondColor) and ShareSettings(videoLinkTemplate, productLinkTemplate). 

SDK Key is a unique identifier of your application that connects to LiveCom service. You can take SDK Key from your account.

With Appearance you can specify your brand's colors. In order to customize colors on Android please read [this](https://github.com/LiveComSollutions/livecom-android-documentation/blob/main/style_customization.md) document.

ShareSettings allow you to set links for sharing videos and products.

Call the method below as soon as possible. Because it needs time to load some data.
```sh 
String? liveComSDKKey;
if (Platform.isAndroid) {
  liveComSDKKey = "e2d97b7e-9a65-4edd-a820-67cd91f8973d";
} else if (Platform.isIOS) {
  liveComSDKKey = "f400270e-92bf-4df1-966c-9f33301095b3";
}
if (liveComSDKKey != null) {
  _liveComPlugin.configure(
    liveComSDKKey,
    "0091FF",
    "#EF5DA8",
    "#0091FF",
    "#00D1FF",
    "https://website.com/{video_id}",
    "https://website.com/{video_id}?p={product_id}"
);
```
## Usage
```dart
final _liveComPlugin = LiveComPlugin();
```
To present screen with list of streams above current top view controller just call:
```dart
_liveComPlugin.presentStreams()
```

To present stream screen with specific id call:
```dart
_liveComPlugin.presentStream(streamId)
```
## Custom Checkout and Product screens
It is possible to display your own screens for product and checkout.
1) Set true in these methods:
```dart
_liveComPlugin.useCustomProductScreen = true
_liveComPlugin.useCustomCheckoutScreen = true
```

2) Open your screen in LiveComDelegate methods:
```dart
@override
  void onRequestOpenCheckoutScreen(List<String> productSKUs) {
    print("[LiveCom] onRequestOpenCheckoutScreen productSKUs: " + productSKUs.join(", "));
 }
  
 @override
 void onRequestOpenProductScreen(String sku, String streamId) {
   print("[LiveCom] onRequestOpenProductScreen sku: " + sku + " stream_id: " + streamId);
}
```
3) Don't forget to call ```trackConversion``` when user made order with your custom checkout screen:
```dart
  void trackConversion(String orderId, int orderAmountInCents, String currency, List<LiveComConversionProduct> products);
```
Example:
```dart
_liveComPlugin.trackConversion(
    "flutter_test_order_id",
    1300,
    "USD",
    [LiveComConversionProduct("test_sku", "test_name", "stream_id", count)]
);
```
