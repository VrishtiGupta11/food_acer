import 'package:flutter/material.dart';
import 'package:food_acer/Util/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentPage extends StatefulWidget {
  double amount;
  RazorpayPaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': widget.amount,
      'name': 'Foodie',
      'description': 'Food Order',
      'prefill': {'contact': Util.appUser!.phoneNumber, 'email': Util.appUser!.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void onPaymentSuccess(PaymentSuccessResponse response) {
    // var id = response.orderId;
    Navigator.pop(context, 1);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context, 0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context, 2);
  }

  @override
  Widget build(BuildContext context) {
    openCheckout();
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
