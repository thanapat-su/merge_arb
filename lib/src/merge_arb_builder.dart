import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

class MergeARBBuilder implements Builder {
  final BuilderOptions options;
  final List<String> supportedLocales;
  final String inputFolder;
  final String outputFolder;

  MergeARBBuilder(this.options)
      : supportedLocales = List<String>.from(options.config['supported_locales'] ?? []),
        inputFolder = options.config['input_folder'] ?? '',
        outputFolder = options.config['output_folder'] ?? '';

  static MergeARBBuilder builder(BuilderOptions options) {
    print('--------> Hello!!!');
    print('option: ${options.config}');
    return MergeARBBuilder(options);
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    for (int i = 0; i < supportedLocales.length; i++) {
      StringBuffer mergedContent = StringBuffer();
      final assets = buildStep.findAssets(Glob('$inputFolder/${supportedLocales[i]}/*.arb'));
      await for (AssetId asset in assets) {
        String content = (await buildStep.readAsString(asset)).trim();

        if (content.startsWith('{') && content.endsWith('}')) {
          content = content.substring(1, content.length - 1).trimRight();
        }

        mergedContent.writeln('$content,');
      }
      await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, '$outputFolder/app_${supportedLocales[i]}.merged.arb'),
        '{\n${mergedContent.toString().rightStrip(',')}\n}',
      );
    }
  }



  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$package$': [
        '$outputFolder/app_en.merged.arb',
        '$outputFolder/app_th.merged.arb',
      ],
    };
  }
}

extension on String {
  /// The string without any trailing whitespace and optional [character]
  String rightStrip([String? character]) {
    final String trimmed = trimRight();

    if (character != null && trimmed.endsWith(character)) {
      return trimmed.substring(0, trimmed.length - 1);
    }

    return trimmed;
  }
}
