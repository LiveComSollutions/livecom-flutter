package com.example.livecom.sdk

import android.app.Activity
import com.livecommerceservice.sdk.domain.api.LiveCom
import com.livecommerceservice.sdk.domain.api.LiveComProductInCart
import com.livecommerceservice.sdk.domain.api.SdkEntrance
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.lang.ref.WeakReference

class LiveComPlugin(
    flutterEngine: FlutterEngine,
    scope: CoroutineScope,
    activity: Activity
) {

    private val channel: MethodChannel =
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    private val applicationContext = activity.applicationContext
    private val weakActivity = WeakReference(activity)

    private var useCustomCheckout: Boolean = false
    private var useCustomProduct: Boolean = false

    init {
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
                    productsInCart.flatMap { product ->
                        buildList { repeat(product.count) { add(product.sku) } }
                    }
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
                    val safeActivity = weakActivity.get() ?: return@setMethodCallHandler
                    scope.launch {
                        LiveCom.openSdkScreen(
                            SdkEntrance.OpenVideoList(clearScreensStackUpToVideoList = true),
                            safeActivity
                        )
                    }
                }

                "presentStream" -> {
                    val safeActivity = weakActivity.get() ?: return@setMethodCallHandler
                    scope.launch {
                        LiveCom.openSdkScreen(
                            SdkEntrance.OpenVideo(streamId = call.arguments as String),
                            safeActivity
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