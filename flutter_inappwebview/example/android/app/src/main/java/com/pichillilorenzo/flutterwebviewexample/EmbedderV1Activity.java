package com.dev-mahmoud-elshenawy.flutterwebviewexample;

import android.os.Bundle;
import com.dev-mahmoud-elshenawy.flutter_inappwebview_android.InAppWebViewFlutterPlugin;

@SuppressWarnings("deprecation")
public class EmbedderV1Activity extends io.flutter.app.FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    InAppWebViewFlutterPlugin.registerWith(
            registrarFor("com.dev-mahmoud-elshenawy.flutter_inappwebview.InAppWebViewFlutterPlugin"));
  }
}