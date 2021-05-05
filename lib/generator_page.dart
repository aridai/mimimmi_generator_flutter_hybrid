import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter_hybrid/generator_page_bloc.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_canvas_updater.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_image_provider.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_output.dart';
import 'package:mimimmi_generator_flutter_hybrid/mimimmi_output_updater.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// ミミッミジェネレータのページ
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GeneratorPageBloc>(
      create: (context) => GeneratorPageBloc(
        MimimmiImageProvider(),
        MimimmiCanvasUpdater(),
        MimimmiOutputUpdater(),
      ),
      dispose: (context, bloc) => bloc.dispose(),
      child: _GeneratorPage(),
    );
  }
}

class _GeneratorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<_GeneratorPage> {
  final _compositeSubscription = CompositeSubscription();
  late final TextEditingController _textController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<GeneratorPageBloc>(context);

    _textController = TextEditingController(
      text: GeneratorPageBloc.initialText,
    );

    bloc.text.listen((text) {
      _textController.value = _textController.value.copyWith(text: text);
    }).addTo(_compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GeneratorPageBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ミミッミジェネレータ')),
      body: SingleChildScrollView(child: _buildBody(bloc)),
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    _textController.dispose();
    super.dispose();
  }

  //  ボディ部を生成する。
  Widget _buildBody(GeneratorPageBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.isProgressIndicatorVisible,
      initialData: true,
      builder: (context, snapshot) {
        final isVisible = snapshot.requireData;
        if (isVisible) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildContent(bloc);
      },
    );
  }

  //  メインコンテンツを生成する。
  Widget _buildContent(GeneratorPageBloc bloc) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MimimmiCanvas(),
            _instructionText,
            _buildTextField(bloc),
            _buildOutputButton(bloc),
            _buildMimimmiOutput(bloc),
          ],
        ),
      ),
    );
  }

  //  テキストフィールドを生成する。
  Widget _buildTextField(GeneratorPageBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _textController,
        minLines: 1,
        maxLines: 3,
        onChanged: (text) => bloc.textSink.add(text),
        decoration: const InputDecoration(hintText: 'ミミッミのセリフ'),
      ),
    );
  }

  //  指示文
  static const _instructionText = Padding(
    padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
    child: Text(
      'ミミッミのセリフを考えよう!',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  //  出力ボタンを生成する。
  Widget _buildOutputButton(GeneratorPageBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => bloc.onOutputRequest(),
        child: const Text('↓ 画像出力 (スマホ用)'),
      ),
    );
  }

  //  ミミッミの出力画像を生成する。
  Widget _buildMimimmiOutput(GeneratorPageBloc bloc) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: StreamBuilder<bool>(
          stream: bloc.isOutputVisible,
          initialData: false,
          builder: (context, snapshot) {
            final isVisible = snapshot.requireData;

            return Visibility(
              visible: isVisible,
              child: const MimimmiOutput(),
            );
          },
        ),
      ),
    );
  }
}
