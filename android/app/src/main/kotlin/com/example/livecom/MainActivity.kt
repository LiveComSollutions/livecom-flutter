package com.example.livecom

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.lifecycle.lifecycleScope
import com.livecommerceservice.sdk.domain.api.LiveCom
import com.livecommerceservice.sdk.domain.api.LiveComProductInCart
import com.livecommerceservice.sdk.domain.api.SdkEntrance
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {

    private lateinit var channel: MethodChannel
    private var useCustomCheckout: Boolean = false
    private var useCustomProduct: Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        LiveCom.callback = object : LiveCom.Callback {
            override fun openCheckoutInsideSdk(productsInCart: List<LiveComProductInCart>): Boolean {
                if (useCustomCheckout) {
                    channel.invokeMethod(
                        "onRequestOpenCheckoutScreen",
                        productsInCart.map { it.sku }
                    )
                }
                return !useCustomCheckout
            }

            override fun openProductCardInsideSdk(productSku: String, streamId: String): Boolean {
                if (useCustomProduct) {
                    channel.invokeMethod(
                        "onRequestOpenProductScreen",
                        mapOf(
                            "product_sku" to productSku,
                            "stream_id" to streamId
                        )
                    )
                }
                return !useCustomProduct
            }

            override fun productsInCartChanged(productsInCart: List<LiveComProductInCart>) {
                channel.invokeMethod(
                    "onCartChange",
                    productsInCart.map { it.sku }
                )
            }

            override fun productAddedToCart(product: LiveComProductInCart) {
                channel.invokeMethod(
                    "onProductAdd",
                    mapOf(
                        "product_sku" to product.sku,
                        "stream_id" to product.streamId
                    )
                )
            }

            override fun productRemovedFromCart(product: LiveComProductInCart) {
                channel.invokeMethod(
                    "onProductDelete",
                    product.sku
                )
            }
        }
        channel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "useCustomProductScreen" -> useCustomProduct = call.arguments as Boolean
                "useCustomCheckoutScreen" -> useCustomCheckout = call.arguments as Boolean
                "configure" -> {
                    val args = call.arguments as List<String>
                    LiveCom.configure(applicationContext, args[0], args[1])
                }
                "presentStreams" -> {
                    lifecycleScope.launch {
                        LiveCom.openSdkScreen(
                            SdkEntrance.OpenVideoList(clearScreensStackUpToVideoList = true),
                            this@MainActivity
                        )
                    }
                }
                "presentStream" -> {
                    lifecycleScope.launch {
                        LiveCom.openSdkScreen(
                            SdkEntrance.OpenVideo(streamId = call.arguments as String),
                            this@MainActivity
                        )
                    }
                }
                "trackConversion" -> {
                    val args = call.arguments as List<Any>
                    val orderId = args[0] as String
                    val orderAmountInCents = args[1] as Int
                    val currency = args[2] as String
                    val products = args[3] as List<HashMap<String, Any>>

                    LiveCom.trackConversion(
                        orderId,
                        orderAmountInCents = orderAmountInCents.toLong(),
                        currency,
                        products.map { fieldsMap ->
                            LiveComProductInCart(
                                sku = fieldsMap["sku"] as String,
                                count = fieldsMap["count"] as Int,
                                name = fieldsMap["name"] as String,
                                streamId = fieldsMap["stream_id"] as String
                            )
                        }
                    )
                }
            }
        }
    }

    companion object {
        private const val CHANNEL = "livecom"
    }
}
