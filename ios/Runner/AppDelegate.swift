import UIKit
import Flutter
import LiveComSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var liveComPlugin: LiveComPlugin?

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
}
