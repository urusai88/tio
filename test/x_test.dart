import 'dart:io';

import 'package:test/test.dart';
import 'package:tio/tio.dart';

void main() {
  test(
    'contentType test',
    () {
      final options = RequestOptions(contentType: 'application/json');
      final resp = Response<dynamic>(
        requestOptions: options,
        headers: Headers.fromMap({
          'content-type': ['application/json;charset=utf-8'],
        }),
      );
      expect(resp.contentType?.mimeType, ContentType.json.mimeType);
      expect(resp.contentType?.primaryType, ContentType.json.primaryType);
      expect(resp.contentType?.subType, ContentType.json.subType);
      expect(resp.contentType?.charset, ContentType.json.charset);
    },
  );
}
