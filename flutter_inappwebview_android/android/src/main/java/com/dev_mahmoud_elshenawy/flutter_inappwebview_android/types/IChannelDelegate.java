package com.dev_mahmoud_elshenawy.flutter_inappwebview_android.types;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;

public interface IChannelDelegate extends MethodChannel.MethodCallHandler, Disposable {
  @Nullable
  MethodChannel getChannel();
}
