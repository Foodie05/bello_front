@JS()
library js_interop;

import 'dart:js_interop';

@JS('window.open')
external void open(String url, String target);