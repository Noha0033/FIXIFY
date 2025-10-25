import 'package:dio/dio.dart';

class NetworkExceptionManager{

   static validateException(DioException exception){
    switch(exception.type){
      case DioExceptionType.connectionTimeout:return "انتهت مدة الاتصال";break;
      case DioExceptionType.badCertificate:return "الاتصال المحدد غير امن";break;
      case DioExceptionType.badResponse:return "لم يتم الاتصال ";break;
      default:return "server error";


    }
  }

}