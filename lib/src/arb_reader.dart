part of 'merge_arb_builder.dart';

class _ArbReader {
  final String _content;
  final Map<String, dynamic>? _dJson;

  final String assetPath;

  String get locale => _locale!;

  String? get _locale => _localeFromAssetPath ?? _localeFromContent;

  String? get _localeFromContent => _dJson?['@@locale'] as String?;
  final String? _localeFromAssetPath;

  String get contentForMergeARB => _content.substring(1, _content.length - 1).trimRight();

  _ArbReader({required String content, required this.assetPath})
      : _content = content.trim(),
        _localeFromAssetPath = getLocaleFromPath(assetPath),
        _dJson = json.decode(content) {
    assert(
      _dJson != null,
      'File content is not a valid JSON',
    );
    assert(
      _locale != null,
      'Locale could not be determined. Make sure that the locale is specified in the file\'s '
      '\'@@locale\' property or as part of the filename (e.g. file_en.arb)',
    );
    assert(
      !(_localeFromContent != null &&
          _localeFromAssetPath != null &&
          _localeFromContent != _localeFromAssetPath),
      'The locale specified in @@locale and the arb filename do not match',
    );
  }
}

final _localeDetector = RegExp(r'_(([a-zA-Z]{2})(_([a-zA-Z0-9]{2,3}))?)\.arb');

/// Extracts the locale from the path of an arb file
String? getLocaleFromPath(String path) {
  final String filename = path.split('/').last;
  final matches = _localeDetector.allMatches(filename);
  final longestMatch = matches.fold('', (String longest, match) {
    final group = match.group(1) ?? '';
    return group.length > longest.length ? group : longest;
  });
  return longestMatch.isEmpty ? null : longestMatch;
}
