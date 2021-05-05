import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter_hybrid/platform_view.dart';

/// ミミッミを描画するCanvas
class MimimmiCanvas extends StatelessWidget {
  const MimimmiCanvas({Key? key}) : super(key: key);

  static const viewType = 'MIMIMMI_CANVAS';

  static final _element = CanvasElement(width: 1280, height: 720);

  /// 初期化を行う。
  /// (アプリ起動時に一度のみ行う。)
  static void init() {
    registerViewFactory(viewType, (id) => _element);
  }

  /// 更新描画を行う。
  static void update(ImageElement img, String text) {
    final context = _element.context2D;
    context.clearRect(0, 0, _element.width!, _element.height!);

    //  ミミッミの画像を描画する。
    context.drawImage(img, 0, 0);

    //  ミミッミのセリフを描画する。
    context.fillStyle = '#000000';
    context.font = '48px sans-serif';

    const x = 50.0;
    const y = 520.0;
    const lineHeight = 64;
    final lines = text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final offsetY = lineHeight * i;
      context.fillText(line, x, y + offsetY);
    }
  }

  /// 描画内容を画像データのURLに変換する。
  static String toDataUrl() => _element.toDataUrl();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: viewType),
    );
  }
}
