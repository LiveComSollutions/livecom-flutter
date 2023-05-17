import 'dart:io';

import 'package:flutter/material.dart';
import 'package:livecom/livecomsdk/livecom.dart';
import 'package:livecom/livecomsdk/livecom_conversion_product.dart';
import 'package:livecom/livecomsdk/livecom_delegate.dart';

final _liveComPlugin = LiveComSDK();

Future<void> main() async {
  const MyApp app = MyApp();
  runApp(app);

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
  // _liveComPlugin.useCustomProductScreen = true;
  // __liveComPlugin.useCustomCheckoutScreen = true
  _liveComPlugin.delegate = app;
  _liveComPlugin.trackConversion("flutter_test_order_id", 1300, "USD", [LiveComConversionProduct("test_sku", "test_name", "qQMqXx2wy", 2)]);
}

class MyApp extends StatelessWidget with LiveComDelegate {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
    print("[LiveCom] onCartChange productSKUs: " + productSKUs.join(", "));
  }
  
  @override
  void onProductAdd(String sku, String streamId) {
    print("[LiveCom] onProductAdd sku: " + sku + " stream_id: " + streamId);
  }
  
  @override
  void onProductDelete(String productSKU) {
    print("[LiveCom] onProductDelete sku: " + productSKU);
  }
  
  @override
  void onRequestOpenCheckoutScreen(List<String> productSKUs) {
    print("[LiveCom] onRequestOpenCheckoutScreen productSKUs: " + productSKUs.join(", "));
  }
  
  @override
  void onRequestOpenProductScreen(String sku, String streamId) {
    print("[LiveCom] onRequestOpenProductScreen sku: " + sku + " stream_id: " + streamId);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String streamId = "qQMqXx2wy";
  final TextEditingController _textFieldController =
      TextEditingController(text: "qQMqXx2wy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  _liveComPlugin.presentStreams();
                },
                child: Text("Show video list")
            ),
            TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Enter stream id'),
                          content: TextField(
                            onChanged: (value) { streamId = value; },
                            controller: _textFieldController,
                            decoration: InputDecoration(hintText: "stream id"),
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
                child: Text("Show video")
            ),
            TextButton(
              onPressed: () {
                _liveComPlugin.presentStreams();
                _liveComPlugin.presentStream(streamId);
            },
             child: Text("Show list and video")
            ),
          ],
        ),
      ),
    );
  }
}