import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livecom_android/livecom_android.dart';
import 'package:livecom_platform_interface/livecom_delegate.dart';

final _liveComPlugin = LiveComAndroid.shared;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with LiveComDelegate {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _liveComPlugin.configure(
        "f400270e-92bf-4df1-966c-9f33301095b3",
        "0091FF",
        "#EF5DA8",
        "#0091FF",
        "#00D1FF",
        "https://website.com/{video_id}",
        "https://website.com/{video_id}?p={product_id}"
    );
    _liveComPlugin.delegate = this;
    log("[LiveCom] configure");
    // _liveComPlugin.useCustomProductScreen = true;
    //  _liveComPlugin.useCustomCheckoutScreen = true;
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
