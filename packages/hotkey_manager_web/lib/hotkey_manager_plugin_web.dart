import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the HotkeyManager plugin.
class HotkeyManagerPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'hotkey_manager',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = HotkeyManagerPlugin();
    pluginInstance._channel = channel;
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  MethodChannel? _channel;

  bool _inited = false;
  Stream<html.MessageEvent>? _stream;

  void _init() {
    if (_stream == null) {
      _stream = html.window.onMessage;
      _stream!.listen(
        (event) {
          if (event.data == null) {
            return;
          }

          Map<String, dynamic> eventData =
              Map<String, dynamic>.from(event.data);
          switch (eventData['eventType']) {
            case 'onKeyDown':
              _channel!.invokeMethod('onKeyDown', eventData['hotKey']);
              break;
            case 'onKeyUp':
              _channel!.invokeMethod('onKeyUp', eventData['hotKey']);
              break;
          }
        },
      );
      _inited = true;
    }
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'register':
        return register(call);
      case 'unregister':
        return unregister(call);
      case 'unregisterAll':
        return unregisterAll(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'hotkey_manager for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<bool> register(MethodCall call) {
    if (!_inited) _init();

    Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
    js.context.callMethod(
      'hotkeyManagerPluginRegister',
      [js.JsObject.jsify(args)],
    );

    return Future.value(true);
  }

  Future<bool> unregister(MethodCall call) {
    if (!_inited) _init();

    Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
    js.context.callMethod(
      'hotkeyManagerPluginUnregister',
      [js.JsObject.jsify(args)],
    );
    return Future.value(true);
  }

  Future<bool> unregisterAll(MethodCall call) {
    if (!_inited) _init();

    js.context.callMethod(
      'hotkeyManagerPluginUnregisterAll',
    );
    return Future.value(true);
  }
}
