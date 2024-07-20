import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../cubits/cubits.dart';
import '../../repos/user/user_repo.dart';
import '../../res/resources_export.dart';
import '../../widgets/general/neumorphsim_container.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen(
      {Key? key,
      required this.orderId,
      required this.userId,
      required this.paymentType})
      : super(key: key);

  final String paymentType;
  final int orderId;
  final int userId;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;
  late FToast fToast;

  PaymentWebViewCubit paymentWebViewCubit = PaymentWebViewCubit();

  bool emailCopied = false;
  bool copyingDone = false;

  @override
  void initState() {
    paymentWebViewCubit.getPaymentUrl(
        orderId: widget.orderId,
        userId: widget.userId,
        paymentType: widget.paymentType);

    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphismContainer(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Theme.of(context).colorScheme.lamisColor,
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BlocConsumer<PaymentWebViewCubit, PaymentWebViewState>(
            bloc: paymentWebViewCubit,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is PaymentWebViewLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.lamisColor,
                  ),
                );
              }
              if (state is PaymentWebViewDone) {
                _webViewController = WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // loadingCubit.setLoading(true);
                      },
                      onPageStarted: (String url) {
                        if (url.contains(state.successString)) {
                          Navigator.of(context).popUntil(
                              (Route<dynamic> route) => route.isFirst);
                          return;
                        } else if (url.contains(state.cancelString)) {
                          Navigator.maybePop(context);
                          return;
                        }
                      },
                      onPageFinished: (String url) {
                        if (url.contains(state.successString)) {
                          Navigator.of(context).popUntil(
                              (Route<dynamic> route) => route.isFirst);
                          return;
                        } else if (url.contains(state.cancelString)) {
                          Navigator.maybePop(context);
                          return;
                        }
                      },
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {
                        if (Platform.isAndroid) {
                          if (request.url.contains(state.successString)) {
                            Navigator.of(context).popUntil(
                                (Route<dynamic> route) => route.isFirst);
                            return NavigationDecision.navigate;
                          }
                        }
                        // if (request.url.contains(widget.success)) {
                        //   return NavigationDecision.prevent;
                        // }
                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..loadRequest(
                      Uri.parse(
                        state.paymentUrl,
                      ),
                      headers: {
                        "Content-Type": "application/json",
                        "App-Language": UserRepo().language,
                        "Accept": "application/json",
                        "country-code": UserRepo().country,
                        "Authorization": "Bearer ${UserRepo().token}",
                      });
                return WebViewWidget(controller: _webViewController);
              }
              if (state is PaymentWebViewError) {
                return SizedBox(
                  height: context.resources.dimension.largeContainerSize,
                  width: context.resources.dimension.largeContainerSize,
                  child: const Image(
                    image: AssetImage(
                      "assets/images/offline.png",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void getData() {
    // _webViewController
    //     .evaluateJavascript("document.body.innerText")
    //     .then((data) {
    // var decodedJSON = jsonDecode(data);
    // Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
    //print(data.toString());
    // if (responseJSON["result"] == false) {
    //   Toast.show(responseJSON["message"], context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    //   Navigator.pop(context);
    // } else if (responseJSON["result"] == true) {
    //   Toast.show(responseJSON["message"], context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    //   if (widget.payment_type == "cart_payment") {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return OrderList(from_checkout: true);
    //     }));
    //   } else if (widget.payment_type == "wallet_payment") {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return Wallet(from_recharge: true);
    //     }));
    //   }
    // }
    // });
  }

  // _showEmailToast() {
  //   Widget toast = GestureDetector(
  //     onTap: () {
  //       if (emailCopied) {
  //         Clipboard.setData(const ClipboardData(text: 'o[h9ZRJ&'));
  //         copyingDone = true;
  //       } else {
  //         Clipboard.setData(const ClipboardData(
  //             text: 'sb-qcyd315573233@personal.example.com'));
  //         emailCopied = true;
  //       }
  //
  //       fToast.removeCustomToast();
  //       if (!copyingDone) {
  //         _showEmailToast();
  //       }
  //     },
  //     child: ToastBody(
  //       text: emailCopied
  //           ? "copy paypal test account Password"
  //           : "copy paypal test account email ",
  //       icon: Icons.copy,
  //       bgColor: Theme.of(context).colorScheme.toastBackGround,
  //     ),
  //   );
  //
  //   fToast.showToast(
  //     child: toast,
  //     gravity: ToastGravity.BOTTOM,
  //     toastDuration: const Duration(minutes: 5),
  //   );
  // }

  @override
  void dispose() {
    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }
}
