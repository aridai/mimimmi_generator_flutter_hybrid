import 'dart:html';

import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas_updater.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_image_provider.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_output_updater.dart';
import 'package:rxdart/rxdart.dart';

/// ミミッミジェネレータのページのBLoC
class GeneratorPageBloc {
  GeneratorPageBloc(
    this._imageProvider,
    this._canvasUpdater,
    this._outputUpdater,
  ) {
    _text.listen(_update);
    _load();
  }

  /// ミミッミのセリフの初期値
  static const initialText = 'にぇにぇ';

  final MimimmiImageProvider _imageProvider;
  final MimimmiCanvasUpdater _canvasUpdater;
  final MimimmiOutputUpdater _outputUpdater;

  final _img = BehaviorSubject<ImageElement?>.seeded(null);
  final _text = BehaviorSubject.seeded(initialText);
  final _isOutputVisible = BehaviorSubject.seeded(false);

  /// ProgressIndicatorの可視性
  Stream<bool> get isProgressIndicatorVisible => _img.map((img) => img == null);

  /// ミミッミのセリフ
  Stream<String> get text => _text.stream;

  /// ミミッミのセリフのSink
  Sink<String> get textSink => _text.sink;

  /// ミミッミの出力画像の可視性
  Stream<bool> get isOutputVisible => _isOutputVisible;

  /// 画像出力が要求されたとき。
  void onOutputRequest() {
    if (!_isOutputVisible.requireValue) _isOutputVisible.add(true);
    _outputUpdater.update();
  }

  /// 終了処理を行う。
  void dispose() {
    _img.close();
    _text.close();
    _isOutputVisible.close();
  }

  //  読み込みを行う。
  Future<void> _load() async {
    final img = await _imageProvider.provide();
    _img.add(img);
    _text.add(_text.requireValue);
  }

  //  更新を掛ける。
  void _update(String text) {
    final img = _img.value;
    if (img != null) _canvasUpdater.update(img, text);
  }
}
