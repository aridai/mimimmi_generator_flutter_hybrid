import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_output.dart';

/// ミミッミの出力画像の更新処理
class MimimmiOutputUpdater {
  /// ミミッミの出力画像を更新する。
  void update() {
    final src = MimimmiCanvas.toDataUrl();
    MimimmiOutput.setImageSource(src);
  }
}
