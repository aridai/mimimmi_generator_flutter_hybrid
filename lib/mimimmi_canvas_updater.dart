import 'dart:html';

import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas.dart';

/// ミミッミのキャンバスの更新ロジック
class MimimmiCanvasUpdater {
  /// キャンバスを更新する。
  void update(ImageElement img, String text) {
    MimimmiCanvas.update(img, text);
  }
}
