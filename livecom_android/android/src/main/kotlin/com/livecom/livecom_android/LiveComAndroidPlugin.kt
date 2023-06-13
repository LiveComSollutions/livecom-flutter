package com.livecom.livecom_android

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.livecommerceservice.sdk.domain.api.LiveCom
import com.livecommerceservice.sdk.domain.api.LiveComProductInCart
import com.livecommerceservice.sdk.domain.api.SdkEntrance

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.launch

/** LiveComAndroidPlugin */
class LiveComAndroidPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var appContext: Context? = null
  private var currentActivity: Activity? = null
  private var useCustomCheckout: Boolean = false
  private var useCustomProduct: Boolean = false

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    appContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.livecom.android")
    channel.setMethodCallHandler(this)
    registerCallback()
  }

  private fun registerCallback() {
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
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "configure" -> {
        appContext?.let {
          val args = call.arguments as List<String>
          LiveCom.configure(it, args[0], args[1])
        }
      }
      "useCustomProductScreen" -> useCustomProduct = call.arguments as Boolean
      "useCustomCheckoutScreen" -> useCustomCheckout = call.arguments as Boolean
      "presentStreams" -> {
        val safeActivity = currentActivity ?: return

        (safeActivity as? LifecycleOwner)?.lifecycleScope?.launch {
          LiveCom.openSdkScreen(
            SdkEntrance.OpenVideoList(clearScreensStackUpToVideoList = true),
            safeActivity
          )
        }
      }

      "presentStream" -> {
        val safeActivity = currentActivity ?: return
        (safeActivity as? LifecycleOwner)?.lifecycleScope?.launch {
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

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    appContext = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    currentActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivity() {
    currentActivity = null
  }
}
