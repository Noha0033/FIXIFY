import 'package:dio/dio.dart';

class HttpManager{
Dio _dio=Dio();
static HttpManager? _httpManager;
HttpManager._();
static HttpManager get getInstance{
  if(_httpManager ==null)
    _httpManager=HttpManager._();
  return _httpManager!;
}
Future<Response>getRequest({required String url})async{
   return await _dio.get(url);
}
}