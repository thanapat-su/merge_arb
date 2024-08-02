import 'package:build/build.dart';
import 'package:merge_arb/src/merge_arb_builder.dart';

/// Entry point for builder
Builder mergeArbBuilderFactory(BuilderOptions options) => MergeARBBuilder.builder(options);