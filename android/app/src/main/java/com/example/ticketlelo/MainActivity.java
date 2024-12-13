package com.example.ticketlelo;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;
import java.util.Map;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.payment_app/performPayment";
    private MethodChannel.Result resultCallback;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            final Map<String,String> arguments = call.arguments();
                            String Jazz_MerchantID = (String) arguments.get("Jazz_MerchantID");
                            String Jazz_Password = (String) arguments.get("Jazz_Password");
                            String Jazz_IntegritySalt = (String) arguments.get("Jazz_IntegritySalt");
                            String paymentReturnUrl = (String) arguments.get("paymentReturnUrl");
                            String price = (String) arguments.get("price");
                            String description = (String) arguments.get("Description");

                            if (call.method.equals("Print")) {
                                System.out.println("\n\n\n\nHere's the Price Recieved:"+price+"\n\n\n\n");
                                resultCallback=result;

                                Intent i = new Intent(MainActivity.this, PaymentActivity.class);

                                i.putExtra("price", price);
                                i.putExtra("paymentReturnUrl", paymentReturnUrl);
                                i.putExtra("Jazz_IntegritySalt", Jazz_IntegritySalt);
                                i.putExtra("Jazz_Password", Jazz_Password);
                                i.putExtra("Jazz_MerchantID", Jazz_MerchantID);
                                i.putExtra("Description",description);


                                startActivityForResult(i, 0);
                            }
                        }
                );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        // Check that it is the SecondActivity with an OK result
        if (requestCode == 0 && resultCode == RESULT_OK) {
            // Get String data from Intent
            String ResponseCode = data.getStringExtra("pp_ResponseCode");

            System.out.println("DateFn: ResponseCode:" + ResponseCode);
            if(ResponseCode.equals("000")) {
                resultCallback.success("Payment Success");
                Toast.makeText(getApplicationContext(), "Payment Success", Toast.LENGTH_SHORT).show();
            }
            else
            {
                resultCallback.success("PAYMENT_FAILED");
                Toast.makeText(getApplicationContext(), "Payment Failed", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
