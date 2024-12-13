import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:ticketlelo/services/payment/product_model.dart';

class PaymentService
{
  String paymentStatus = "pending";
  ProductModel productModel = ProductModel("Product 1", "100");
  String integritySalt= "INTEGRITY_SALT_HERE";
  String merchantID= "MERCHANT_ID_HERE";
  String merchantPassword = "MERCHANT_PASSWORD_HERE";
  String transactionUrl= "SANDBOX_LINK_HERE";

  static final PaymentService _shared=PaymentService._sharedInstance();
  PaymentService._sharedInstance();

  factory PaymentService()=>_shared;

static const platform = MethodChannel('com.payment_app/performPayment');

Future<bool> pay(int ticketPrice, String ticketDescription) async {
  String price=ticketPrice.toString();
  developer.log('price is $ticketPrice and $price');


    Map<String,String> data ={
      "price":price,
      "Jazz_MerchantID":"MERCHANT_ID_HERE",
      "Jazz_Password":"PASSWORD_HERE",
      "Jazz_IntegritySalt":"INTEGRITY_SALT_HERE",
      "paymentReturnUrl":"SANDBOX_LINK_HERE",
      "Description":ticketDescription,

    };
    String value="";

    try {
      value = await platform.invokeMethod("Print", data);
      if(value=='Payment Success')
       {
         return true;
       }
      else
       {
         return false;
       }
    } catch (e) {
      developer.log(e.toString());
      return false;
    }

    developer.log(value.toString());
  }




}







