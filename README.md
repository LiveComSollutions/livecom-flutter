This repository contains wrappers and a demo project.

## Installation
Copy ```lib/livecomsdk``` folder to your project.
### iOS
To integrate LiveComSDK using the Xcode-built-in SPM, choose File → Swift Packages → Add Package Dependency. Enter the following url: https://github.com/LiveComSollutions/livecom-ios . In the following step, select LiveComSDKWrapper as the package product and click Finish.

## Initialize SDK
To initialize LiveCom SDK, you need pass SDK Key, Appearence and ShareSettings objects.

SDK Key is a unique identifier of your application that connects to LiveCom service. You can take SDK Key from your account.

With Appearance you can specify your brand's colors.

ShareSettings allow you to set links for sharing videos and products.

Call  this method as soon as possible. Because it needs time to load some data.
```sh 
import LiveComSDK from './native_modules/LiveComSDK'
...
_liveComPlugin.configure(
    "f400270e-92bf-4df1-966c-9f33301095b3",
    "0091FF",
    "#EF5DA8",
    "#0091FF",
    "#00D1FF",
    "https://website.com/{video_id}",
    "https://website.com/{video_id}?p={product_id}"
  );
```
Add the following code to AppDelegate:
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
## Usage
```sh
final _liveComPlugin = LiveComSDK();
```
To present screen with list of streams above current top view controller just call:
```sh 
_liveComPlugin.presentStreams()
```

To present stream screen with specific id call:
```sh 
_liveComPlugin.presentStream(streamId)
```
## Custom Checkout and Product screens
It is possible to display your own screens for product and checkout.
1) Set true in these methods:
```sh
presentStream.setUseCustomProductScreen(true)
presentStream.setUseCustomCheckoutScreen(true)
```
2) Open your screen in LiveComDelegate methods:
``` sh 
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
``` sh 
  void trackConversion(String orderId, int orderAmountInCents, String currency, List<LiveComConversionProduct> products)
```
Example:
``` sh
_liveComPlugin.trackConversion(
    "flutter_test_order_id",
    1300,
    "USD",
    [LiveComConversionProduct("test_sku", "test_name", "stream_id", count)]
);
```