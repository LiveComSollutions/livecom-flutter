This repository contains wrappers and a demo project.

## Installation
Copy ```lib/livecomsdk```, ```ios/Runner/LiveComSDK```, ```android/app/src/main/kotlin/com/example/livecom/sdk``` folders to your project. Do not
forget change package for LiveComPlugin android class after copy.
### iOS
To integrate LiveComSDK using the Xcode-built-in SPM, choose File → Swift Packages → Add Package Dependency. Enter the following url: https://github.com/LiveComSollutions/livecom-ios . In the following step, select LiveComSDKWrapper as the package product and click Finish.

### Android
To integrate LiveComSDK follow document: https://github.com/LiveComSollutions/livecom-android-documentation/blob/main/how_to_install.md
Add this dependencies to build.gradle files inside android folder of your flutter project (both inside ```app``` and ```src``` directories).
Create LiveComPlugin instance inside MainActivity.configureFlutterEngine() method. You will need coroutines dependency also (check build.gradle file dependencies section)

## Initialize SDK
To initialize LiveCom SDK, you need pass:
iOS: SDK Key, Appearence and ShareSettings objects.
Android: SDK Key, your web domain, that will be used to generate links for sharing video and product 

SDK Key is a unique identifier of your application that connects to LiveCom service. You can take SDK Key from your account.

With Appearance you can specify your brand's colors. In order to customize colors on Android please read [this](https://github.com/LiveComSollutions/livecom-android-documentation/blob/main/style_customization.md) document.

ShareSettings allow you to set links for sharing videos and products.

Call the method below as soon as possible. Because it needs time to load some data.
```sh 
import LiveComSDK from './native_modules/LiveComSDK'
...
if (Platform.isAndroid) {
    _liveComPlugin.configureAndroid(
      "e2d97b7e-9a65-4edd-a820-67cd91f8973d",
      "website.com"
    );
} else {
    _liveComPlugin.configureIOS(
        "f400270e-92bf-4df1-966c-9f33301095b3",
        "0091FF",
        "#EF5DA8",
        "#0091FF",
        "#00D1FF",
        "https://website.com/{video_id}",
        "https://website.com/{video_id}?p={product_id}"
    );
}
```
Add the following code to AppDelegate (iOS only):
```
override func application(
    _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    liveComPlugin = LiveComPlugin(messenger: controller.binaryMessenger)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
    let handled = LiveCom.shared.continue(userActivity: userActivity)
    return handled
}
```
Add the following code to MainActivity (Android only):
```kotlin
private var liveComPlugin: LiveComPlugin? = null

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    liveComPlugin = LiveComPlugin(flutterEngine, lifecycleScope, this)
}
```
## Usage
```dart
final _liveComPlugin = LiveComSDK();
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
