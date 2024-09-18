import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

/// Object specifying creation parameters for creating a [WindowsWebMessageListener].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformWebMessageListenerCreationParams] for
/// more information.
@immutable
class WindowsWebMessageListenerCreationParams
    extends PlatformWebMessageListenerCreationParams {
  /// Creates a new [WindowsWebMessageListenerCreationParams] instance.
  const WindowsWebMessageListenerCreationParams(
      {required this.allowedOriginRules,
      required super.jsObjectName,
      super.onPostMessage});

  /// Creates a [WindowsWebMessageListenerCreationParams] instance based on [PlatformWebMessageListenerCreationParams].
  factory WindowsWebMessageListenerCreationParams.fromPlatformWebMessageListenerCreationParams(
      // Recommended placeholder to prevent being broken by platform interface.
      // ignore: avoid_unused_constructor_parameters
      PlatformWebMessageListenerCreationParams params) {
    return WindowsWebMessageListenerCreationParams(
        allowedOriginRules: params.allowedOriginRules ?? Set.from(["*"]),
        jsObjectName: params.jsObjectName,
        onPostMessage: params.onPostMessage);
  }

  @override
  final Set<String> allowedOriginRules;

  @override
  String toString() {
    return 'MacOSWebMessageListenerCreationParams{jsObjectName: $jsObjectName, allowedOriginRules: $allowedOriginRules, onPostMessage: $onPostMessage}';
  }
}

///{@macro flutter_inappwebview_platform_interface.PlatformWebMessageListener}
class WindowsWebMessageListener extends PlatformWebMessageListener
    with ChannelController {
  /// Constructs a [WindowsWebMessageListener].
  WindowsWebMessageListener(PlatformWebMessageListenerCreationParams params)
      : super.implementation(
          params is WindowsWebMessageListenerCreationParams
              ? params
              : WindowsWebMessageListenerCreationParams
                  .fromPlatformWebMessageListenerCreationParams(params),
        ) {
    assert(!this._macosParams.allowedOriginRules.contains(""),
        "allowedOriginRules cannot contain empty strings");
    channel = MethodChannel(
        'com.dev-mahmoud-elshenawy/flutter_inappwebview_web_message_listener_${_id}_${params.jsObjectName}');
    handler = _handleMethod;
    initMethodCallHandler();
  }

  ///Message Listener ID used internally.
  final String _id = IdGenerator.generate();

  MacOSJavaScriptReplyProxy? _replyProxy;

  WindowsWebMessageListenerCreationParams get _macosParams =>
      params as WindowsWebMessageListenerCreationParams;

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onPostMessage":
        if (_replyProxy == null) {
          _replyProxy = MacOSJavaScriptReplyProxy(
              PlatformJavaScriptReplyProxyCreationParams(
                  webMessageListener: this));
        }
        if (onPostMessage != null) {
          WebMessage? message = call.arguments["message"] != null
              ? WebMessage.fromMap(
                  call.arguments["message"].cast<String, dynamic>())
              : null;
          WebUri? sourceOrigin = call.arguments["sourceOrigin"] != null
              ? WebUri(call.arguments["sourceOrigin"])
              : null;
          bool isMainFrame = call.arguments["isMainFrame"];
          onPostMessage!(message, sourceOrigin, isMainFrame, _replyProxy!);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
    return null;
  }

  @override
  void dispose() {
    disposeChannel();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "jsObjectName": params.jsObjectName,
      "allowedOriginRules": _macosParams.allowedOriginRules.toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return 'MacOSWebMessageListener{id: ${_id}, jsObjectName: ${params.jsObjectName}, allowedOriginRules: ${params.allowedOriginRules}, replyProxy: $_replyProxy}';
  }
}

/// Object specifying creation parameters for creating a [MacOSJavaScriptReplyProxy].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformJavaScriptReplyProxyCreationParams] for
/// more information.
@immutable
class MacOSJavaScriptReplyProxyCreationParams
    extends PlatformJavaScriptReplyProxyCreationParams {
  /// Creates a new [MacOSJavaScriptReplyProxyCreationParams] instance.
  const MacOSJavaScriptReplyProxyCreationParams(
      {required super.webMessageListener});

  /// Creates a [MacOSJavaScriptReplyProxyCreationParams] instance based on [PlatformJavaScriptReplyProxyCreationParams].
  factory MacOSJavaScriptReplyProxyCreationParams.fromPlatformJavaScriptReplyProxyCreationParams(
      // Recommended placeholder to prevent being broken by platform interface.
      // ignore: avoid_unused_constructor_parameters
      PlatformJavaScriptReplyProxyCreationParams params) {
    return MacOSJavaScriptReplyProxyCreationParams(
        webMessageListener: params.webMessageListener);
  }
}

///{@macro flutter_inappwebview_platform_interface.JavaScriptReplyProxy}
class MacOSJavaScriptReplyProxy extends PlatformJavaScriptReplyProxy {
  /// Constructs a [WindowsWebMessageListener].
  MacOSJavaScriptReplyProxy(PlatformJavaScriptReplyProxyCreationParams params)
      : super.implementation(
          params is MacOSJavaScriptReplyProxyCreationParams
              ? params
              : MacOSJavaScriptReplyProxyCreationParams
                  .fromPlatformJavaScriptReplyProxyCreationParams(params),
        );

  WindowsWebMessageListener get _macosWebMessageListener =>
      params.webMessageListener as WindowsWebMessageListener;

  @override
  Future<void> postMessage(WebMessage message) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('message', () => message.toMap());
    await _macosWebMessageListener.channel?.invokeMethod('postMessage', args);
  }

  @override
  String toString() {
    return 'MacOSJavaScriptReplyProxy{}';
  }
}
