import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TrainAppView extends StatefulWidget {
  final String url;
  const TrainAppView({super.key,required this.url});

  @override
  State<TrainAppView> createState() => _TrainAppViewState();
}

class _TrainAppViewState extends State<TrainAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("التدريب"),
        foregroundColor: Colors.white,
      ),
      body: InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
      
    ),
    );
  }
}