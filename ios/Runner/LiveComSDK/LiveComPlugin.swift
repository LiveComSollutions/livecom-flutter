//
//  LiveComPlugin.swift
//  Runner
//
//  Created by Sakhabaev Egor on 16.05.2023.
//

import Foundation
import Flutter
import LiveComSDK

class LiveComPlugin {

    private let channel: FlutterMethodChannel
    private var useCustomProductScreen: Bool = false
    private var useCustomCheckoutScreen: Bool = false

    init(messenger: FlutterBinaryMessenger) {
         channel = FlutterMethodChannel(
            name: "livecom",
            binaryMessenger: messenger
         )
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "configure":
                guard let params = call.arguments as? [String] else { return }
                guard
                    let sdkKey = params.get(0),
                    let primaryColor = params.get(1),
                    let secondaryColor = params.get(2),
                    let gradientFirstColor = params.get(3),
                    let gradientSecondColor = params.get(4),
                    let videoLinkTemplate = params.get(5),
                    let productLinkTemplate = params.get(6)
                else { return }
                
                self?.configure(
                    sdkKey: sdkKey,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    gradientFirstColor: gradientFirstColor,
                    gradientSecondColor: gradientSecondColor,
                    videoLinkTemplate: videoLinkTemplate,
                    productLinkTemplate: productLinkTemplate
                )
            case "presentStream":
                guard let streamId = call.arguments as? String else { return }
                self?.presentStream(id: streamId)
            case "presentStreams":
                self?.presentStreams()
            case "useCustomProductScreen":
                guard let value = call.arguments as? Bool else { return }
                self?.useCustomProductScreen = value
            case "useCustomCheckoutScreen":
                guard let value = call.arguments as? Bool else { return }
                self?.useCustomCheckoutScreen = value
            case "trackConversion":
                guard let params = call.arguments as? [Any] else { return }
                guard
                    let orderId = params.get(0) as? String,
                    let orderAmountInCents = params.get(1) as? Int,
                    let currency = params.get(2) as? String,
                    let products = params.get(3) as? [[String: Any]]
                else { return }
                self?.trackConversion(
                    orderId: orderId,
                    orderAmountInCents: orderAmountInCents,
                    currency: currency,
                    products: products
                )
            default:
                break
            }
        }
    }
}

// MARK: - LiveCom
extension LiveComPlugin {

    func configure(
        sdkKey: String,
        primaryColor: String,
        secondaryColor: String,
        gradientFirstColor: String,
        gradientSecondColor: String,
        videoLinkTemplate: String,
        productLinkTemplate: String
    ) {
        guard
            let primaryColor = UIColor.init(hex: primaryColor),
            let secondaryColor = UIColor.init(hex: secondaryColor),
            let gradientFirstColor = UIColor.init(hex: gradientFirstColor),
            let gradientSecondColor = UIColor.init(hex: gradientSecondColor)
        else { return }
        let theme = Appearence.AppTheme(
            primary: primaryColor,
            secondary: secondaryColor,
            gradientFirst: gradientFirstColor,
            gradientSecond: gradientSecondColor
        )
        LiveCom.shared.configure(
            sdkKey: sdkKey,
            appearence: .init(theme: theme),
            shareSettings: .init(videoLinkTemplate: videoLinkTemplate, productLinkTemplate: productLinkTemplate),
            delegate: self
        )
    }

    func presentStream(id: String) {
        LiveCom.shared.presentStream(id: id)
    }

    func presentStreams() {
        LiveCom.shared.presentStreams()
    }

    func trackConversion(orderId: String, orderAmountInCents: Int, currency: String, products: [[String: Any]]) {
        let products: [LiveCom.Conversion.Product] = products.compactMap {
            guard
                let sku = $0["sku"] as? String,
                let name = $0["name"] as? String,
                let streamId = $0["stream_id"] as? String,
                let count = $0["count"] as? Int
            else { return nil }
            return .init(
                sku: sku,
                name: name,
                streamId: streamId,
                count: count
            )
        }
        let conversion = LiveCom.Conversion(
            orderId: orderId,
            orderAmountInCents: orderAmountInCents,
            currency: currency,
            products: products
        )
        LiveCom.shared.trackConversion(conversion)
    }
}

// MARK: - LiveComDelegate
extension LiveComPlugin: LiveComDelegate {

    func productDidAddToCart(_ product: LiveCom.Product, inStreamId streamId: String) {
        channel.invokeMethod("onProductAdd", arguments: ["product_sku": product.sku, "stream_id": streamId])
    }

    func productDidDeleteFromCart(_ productSKU: String) {
        channel.invokeMethod("onProductDelete", arguments: productSKU)
    }

    func cartDidChange(products: [LiveCom.Product]) {
        let products = products.map(\.sku)
        channel.invokeMethod("onCartChange", arguments: products)
    }

    func userDidRequestOpenProductScreen(
        for product: LiveCom.Product,
        streamId: String,
        presenting presentingViewController: UIViewController
    ) -> Bool {
        guard useCustomProductScreen else { return false }
        channel.invokeMethod("onRequestOpenProductScreen", arguments: ["product_sku": product.sku, "stream_id": streamId])
        return true
    }

    func userDidRequestOpenCheckoutScreen(products: [LiveCom.Product], presenting presentingViewController: UIViewController) -> Bool {
        guard useCustomCheckoutScreen else { return false }
        let products = products.map(\.sku)
        channel.invokeMethod("onRequestOpenCheckoutScreen", arguments: products)
        return true
    }
}
