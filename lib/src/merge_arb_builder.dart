import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'dart:convert';

part 'arb_reader.dart';

/// Builder that merges multiple arb files into a single arb file per locale
class MergeARBBuilder implements Builder {
  final BuilderOptions options;
  final List<String> supportedLocales;
  final String inputPath;
  final String outputFolder;

  /// Constructor
  MergeARBBuilder(this.options)
      : supportedLocales = List<String>.from(options.config['supported_locales'] ?? []),
        inputPath = options.config['input_path'] ?? '',
        outputFolder = options.config['output_folder'] ?? '';

  static MergeARBBuilder builder(BuilderOptions options) {
    return MergeARBBuilder(options);
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    Map<String, StringBuffer> mergedContents = {};
    final assets = buildStep.findAssets(Glob(inputPath));
    await for (AssetId asset in assets) {
      String content = (await buildStep.readAsString(asset));

      _ArbReader arbReader = _ArbReader(content: content, assetPath: asset.path);
      String locale = arbReader.locale;
      if (!mergedContents.containsKey(locale)) {
        mergedContents[locale] = StringBuffer()..writeln('  "@@locale": "$locale",');
      }
      mergedContents[locale]?.writeln('${arbReader.contentForMergeARB},');
    }
    for (String locale in supportedLocales) {
      if (!mergedContents.containsKey(locale)) {
        throw Exception('No arb files found for locale $locale');
      }
      await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, '$outputFolder/app_$locale.merged.arb'),
        '{\n${mergedContents[locale].toString().rightStrip(',')}\n}',
      );
    }
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'lib/$lib$': supportedLocales.map((l) => '$outputFolder/app_$l.merged.arb').toList(),
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
