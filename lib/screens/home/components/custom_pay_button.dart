import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:smaergym/screens/home/components/apply_pay_config.dart';

class CustomPayButton extends StatelessWidget {
  const CustomPayButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '10.99',
        status: PaymentItemStatus.final_price,
      )
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          ApplePayButton(
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(defaultApplePay),
            paymentItems: paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: ((result) {
              print(result);
            }),
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
         
        ],
      ),
    );
  }
}
