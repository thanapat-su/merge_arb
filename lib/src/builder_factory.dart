import 'package:build/build.dart';
import 'package:merge_arb/src/merge_arb_builder.dart';

Builder mergeArbBuilderFactory(BuilderOptions options) => MergeARBBuilder.builder(options);