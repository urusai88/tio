import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import '../generators.dart';
import '../utils.dart';

final emitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
final formatter = DartFormatter();

const _prefix = r'$dir$/$file$';
const _placeholder = r'$suffix$';
const _inputPattern = '$_prefix.dart';
const _outputPattern = '$_prefix.$_placeholder.dart';
const _checker = TypeChecker.fromRuntime(TioOpenApiClient);

class TioOpenApiClientCommandBuilder {
  TioOpenApiClientCommandBuilder({required this.componentsGenerators});

  final List<TioOpenApiBaseComponentsGenerator> componentsGenerators;

  static String _computeEnding(String suffix) =>
      '$_placeholder.dart'.replaceFirst(_placeholder, suffix);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    print(311);
    final resolver = buildStep.resolver;
    final assetId = buildStep.inputId;

    if (!await resolver.isLibrary(assetId)) {
      return;
    }

    final library = await resolver.libraryFor(assetId);
    final libraryReader = LibraryReader(library);
    for (final annotated in libraryReader.annotatedWith(_checker)) {
      final annotation = TioOpenApiClient(
        path: annotated.annotation.read('path').stringValue,
      );
      final config = loadOpenApi(annotation.path);

      for (final generator in componentsGenerators) {
        final strings = await (await generator.generate(
          libraryReader: libraryReader,
          annotation: annotation,
          config: config,
        ))
            .toList();
        var contents = strings.join('\n');
        if (contents.isEmpty) {
          continue;
        }
        contents = formatter.format(contents);

        final outputId = buildStep.allowedOutputs.firstWhere(
          (e) => e.path.endsWith(_computeEnding(generator.suffix)),
        );

        await buildStep.writeAsString(outputId, contents);
      }
    }
  }
}
