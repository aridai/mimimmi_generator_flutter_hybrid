import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter_hybrid/platform_view.dart';

/// ミミッミの出力画像
class MimimmiOutput extends StatelessWidget {
  const MimimmiOutput({Key? key}) : super(key: key);

  static const viewType = 'MIMIMMI_OUTPUT';

  static final _element = ImageElement(width: 640, height: 480);

  /// 初期化を行う。
  /// (アプリ起動時に一度のみ行う。)
  static void init() {
    registerViewFactory(viewType, (id) => _element);
  }

  /// 画像のソースを設定する。
  static void setImageSource(String src) {
    _element.src = src;
  }

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: viewType),
    );
  }
}
