import 'dart:async';
import 'dart:html';

/// ミミッミの画像の提供ロジック
class MimimmiImageProvider {
  static const _url = 'assets/assets/mimimmi.png';

  /// ロード済みのimg要素を提供する。
  Future<ImageElement> provide() async {
    final img = ImageElement()..style.display = 'none';
    final completer = Completer<ImageElement>();

    final onLoadSubscription = img.onLoad.listen(
      (event) => completer.complete(img),
    );
    final onErrorSubscription = img.onError.listen(
      (event) => completer.completeError(event),
    );

    try {
      img.src = _url;
      return await completer.future;
    } finally {
      onLoadSubscription.cancel();
      onErrorSubscription.cancel();
    }
  }
}
