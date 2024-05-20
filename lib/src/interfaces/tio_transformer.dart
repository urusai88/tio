import 'dart:typed_data';

import '../../tio.dart';
import '../typedefs.dart';

abstract interface class TioTransformer<E> {
  TioResponse<T, E> transformOne<T>(Response<JSON> resp);

  TioResponse<List<T>, E> transformMany<T>(Response<List<dynamic>> resp);

  TioResponse<void, E> transformEmpty(Response<dynamic> resp);

  E transformError(Response<dynamic> resp);

  TioResponse<String, E> transformString(Response<String> resp);

  TioResponse<Uint8List, E> transformBytes(Response<Uint8List> resp);

  TioResponse<ResponseBody, E> transformStream(Response<ResponseBody> resp);
}
