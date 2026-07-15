import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens the DPO hosted payment page in an in-app WebView and reports the
/// outcome by popping with a String: 'success', 'cancel', or 'closed'.
class DpoWebviewScreen extends StatefulWidget {
  final String url;
  const DpoWebviewScreen({super.key, required this.url});

  @override
  State<DpoWebviewScreen> createState() => _DpoWebviewScreenState();
}

class _DpoWebviewScreenState extends State<DpoWebviewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final decision = _handleUrl(request.url);
            return decision;
          },
          onPageStarted: (url) {
            _handleUrl(url);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// Detect the backend/frontend return URLs and finish accordingly.
  NavigationDecision _handleUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('payment-success')) {
      _finish('success');
      return NavigationDecision.prevent;
    }
    if (lower.contains('payment-cancel')) {
      _finish('cancel');
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void _finish(String result) {
    if (_done) return;
    _done = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish('closed');
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(AppStrings.paymentOption.tr),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finish('closed'),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
