import 'dart:convert';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:analyzer/src/util/file_paths.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tio_openapi_generator/src/builders.dart';
import 'package:tio_openapi_generator/src/generators.dart';

const _checker = TypeChecker.fromRuntime(TioOpenApiClient);

class _AssetReader extends AssetReader {
  _AssetReader({required this.resourceProvider});

  final ResourceProvider resourceProvider;

  @override
  Future<bool> canRead(AssetId id) =>
      Future.value(resourceProvider.getFile(id.path).exists);

  @override
  Stream<AssetId> findAssets(Glob glob) {
    print(123);
    // TODO: implement findAssets
    throw UnimplementedError();
  }

  @override
  Future<List<int>> readAsBytes(AssetId id) =>
      Future.value(resourceProvider.getFile(id.path).readAsBytesSync());

  @override
  Future<String> readAsString(AssetId id, {Encoding encoding = utf8}) =>
      Future.value(resourceProvider.getFile(id.path).readAsStringSync());
}

class _AssetWriter extends AssetWriter {
  _AssetWriter({required this.resourceProvider});

  final ResourceProvider resourceProvider;

  @override
  Future<void> writeAsBytes(AssetId id, List<int> bytes) {
    print(123);
    // TODO: implement writeAsBytes
    throw UnimplementedError();
  }

  @override
  Future<void> writeAsString(AssetId id, String contents,
      {Encoding encoding = utf8}) {
    print(123);
    // TODO: implement writeAsString
    throw UnimplementedError();
  }
}

class _Resolvers extends Resolvers {
  const _Resolvers({required this.analysisContext});

  final AnalysisContext analysisContext;

  @override
  Future<ReleasableResolver> get(BuildStep buildStep) {
    return Future.value(_Resolver(resolvers: this));
  }
}

class _Resolver extends ReleasableResolver {
  _Resolver({required this.resolvers});

  final _Resolvers resolvers;

  @override
  Future<AssetId> assetIdForElement(Element element) {
    // TODO: implement assetIdForElement
    throw UnimplementedError();
  }

  @override
  Future<AstNode?> astNodeFor(Element element, {bool resolve = false}) {
    // TODO: implement astNodeFor
    throw UnimplementedError();
  }

  @override
  Future<CompilationUnit> compilationUnitFor(AssetId assetId,
      {bool allowSyntaxErrors = false}) {
    // TODO: implement compilationUnitFor
    throw UnimplementedError();
  }

  @override
  Future<LibraryElement?> findLibraryByName(String libraryName) {
    // TODO: implement findLibraryByName
    throw UnimplementedError();
  }

  @override
  Future<bool> isLibrary(AssetId assetId) {
    final path =
        p.join(resolvers.analysisContext.contextRoot.root.path, assetId.path);
    final fileResult =
        resolvers.analysisContext.currentSession.getFile(path) as FileResult;

    return Future.value(fileResult.isLibrary);
  }

  @override
  // TODO: implement libraries
  Stream<LibraryElement> get libraries => throw UnimplementedError();

  @override
  Future<LibraryElement> libraryFor(
    AssetId assetId, {
    bool allowSyntaxErrors = false,
  }) async {
    final path =
        p.join(resolvers.analysisContext.contextRoot.root.path, assetId.path);
    final resolvedLibrary = await resolvers.analysisContext.currentSession
        .getResolvedLibrary(path) as ResolvedLibraryResult;

    return resolvedLibrary.element;
  }

  @override
  void release() {
    // TODO: implement release
  }
}

void main() async {
  Logger.root.onRecord.listen(print);

  final resourceProvider = PhysicalResourceProvider(stateLocation: p.current);
  final collection = AnalysisContextCollection(
    includedPaths: [p.current],
    resourceProvider: resourceProvider,
  );
  for (final context in collection.contexts) {
    final contextRoot = context.contextRoot;
    final currentSession = context.currentSession;
    final analyzedFiles = contextRoot.analyzedFiles();
    final dartFilesPaths = analyzedFiles
        .where((e) => isDart(p.context, e))
        .map((e) => p.relative(e, from: context.contextRoot.root.path));
    final pubspecResource = resourceProvider.getFile(pubspecYaml);
    if (!pubspecResource.exists) {
      throw Exception('pubspec.yaml not found');
    }
    final yamlContents = pubspecResource.readAsStringSync();
    final pubspec = Pubspec.parse(yamlContents);

    for (final dartFile in dartFilesPaths) {
      // final libraryResult =
      //     await context.currentSession.getResolvedLibrary(dartFile);
      // if (libraryResult is! ResolvedLibraryResult) {
      //   continue;
      // }

      final builder = TioOpenApiClientBuilder(
        componentsGenerators: const [
          TioOpenApiPathsGenerator(),
        ],
      );

      final inputs = [
        AssetId(pubspec.name, dartFile),
      ];

      final reader = _AssetReader(resourceProvider: resourceProvider);
      final writer = _AssetWriter(resourceProvider: resourceProvider);
      final resolvers = _Resolvers(analysisContext: context);

      await runBuilder(
        builder,
        inputs,
        reader,
        writer,
        resolvers,
        logger: Logger('runBuilder'),
      );

      // final libraryElement = libraryResult.element;
      // final libraryReader = LibraryReader(libraryElement);
      //
      // for (final annotated in libraryReader.annotatedWith(_checker)) {
      //   final annotationReader = annotated.annotation;
      //   final annotation = TioOpenApiClient(
      //     path: annotationReader.read('path').stringValue,
      //   );
      // }
    }
  }
}
