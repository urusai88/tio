abstract class CoreObject {
  const CoreObject({this.$id, this.$ref});

  final Uri? $id;

  final Uri? $ref;

  bool get isUrn => $id?.isScheme('urn') ?? false;

  bool get isId {
    if ($id == null) {
      return false;
    }
    return !$id!.hasScheme;
  }
}
