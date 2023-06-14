import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:livecom_plugin/livecom_plugin.dart';
import 'package:livecom_platform_interface/livecom_delegate.dart';
// import 'package:livecom_platform_interface/livecom_conversion_product.dart';

final _liveComPlugin = LiveComPlugin();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with LiveComDelegate {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    }
    _liveComPlugin.delegate = this;
    // Set useCustomProductScreen true if you want to open your own product screen. onRequestOpenProductScreen will be called
    // _liveComPlugin.useCustomProductScreen = true;

    // Set useCustomCheckoutScreen true if you want to open your own checkout screen. onRequestOpenCheckoutScreen will be called
    //  _liveComPlugin.useCustomCheckoutScreen = true;

    // Call trackConversion method after paid order if you use your own checkout.
    // _liveComPlugin.trackConversion("flutter_test_order_id", 1300, "USD", [LiveComConversionProduct("test_sku", "test_name", "qQMqXx2wy", 2)]);

    return MaterialApp(
      title: 'LiveCom Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter screen'),
    );
  }

  @override
  void onCartChange(List<String> productSKUs) {
    log("[LiveCom] onCartChange productSKUs: ${productSKUs.join(", ")}");
  }
  
  @override
  void onProductAdd(String sku, String streamId) {
    log("[LiveCom] onProductAdd sku: $sku stream_id: $streamId");
  }
  
  @override
  void onProductDelete(String productSKU) {
    log("[LiveCom] onProductDelete sku: $productSKU");
  }
  
  @override
  void onRequestOpenCheckoutScreen(List<String> productSKUs) {
    log("[LiveCom] onRequestOpenCheckoutScreen productSKUs: ${productSKUs.join(", ")}");
  }
  
  @override
  void onRequestOpenProductScreen(String sku, String streamId) {
    log("[LiveCom] onRequestOpenProductScreen sku: $sku stream_id: $streamId");
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  String streamId = "qQMqXx2wy";
  final TextEditingController _textFieldController =
      TextEditingController(text: "qQMqXx2wy");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  _liveComPlugin.presentStreams();
                },
                child: const Text("Show video list")
            ),
            TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Enter stream id'),
                          content: TextField(
                            onChanged: (value) { streamId = value; },
                            controller: _textFieldController,
                            decoration: const InputDecoration(hintText: "stream id"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'OK');
                                _liveComPlugin.presentStream(streamId);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        )),
                child: const Text("Show video")
            ),
            TextButton(
              onPressed: () {
                _liveComPlugin.presentStreams();
                _liveComPlugin.presentStream(streamId);
            },
             child: const Text("Show list and video")
            ),
          ],
        ),
      ),
      ),
    );
  }
}
