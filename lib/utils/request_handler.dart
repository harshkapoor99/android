import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

void addApiInterceptors(Dio dio) {
  dio.options.connectTimeout = const Duration(seconds: 20);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['contentType'] = 'application/json';
  // logger
  // dio.interceptors.add(
  //   PrettyDioLogger(
  //     requestHeader: true,
  //     requestBody: true,
  //     responseBody: true,
  //     responseHeader: false,
  //     error: true,
  //     compact: true,
  //     maxWidth: 90,
  //   ),
  // );

  // respone handler
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.next(options);
      },
      onResponse: (response, handler) {
        final status = response.data['status'];
        // final status = response.statusCode;
        switch (status) {
          case 401:
            // Box authBox = Hive.box(AppHSC.authBox);
            // authBox.clear();
            // Box userBox = Hive.box(AppHSC.userBox);
            // userBox.clear();
            // AppConstants.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            //   Routes.splash,
            //   (route) => false,
            // );
            break;
          case 302:
          case 400:
          case 403:
          case 404:
            break;
          case 409:
          case 422:
          case 500:
            break;
          default:
            break;
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (error.response == null) {
          switch (error.type) {
            case DioExceptionType.connectionError:
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.badResponse:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.unknown:
              break;
            default:
              break;
          }
        }

        if (error.response != null) {
          // final message = error.response!.data['message'];
          final statusCode = error.response!.statusCode;
          switch (statusCode) {
            case 401:
              // Box authBox = Hive.box(AppHSC.authBox);
              // authBox.clear();
              // Box userBox = Hive.box(AppHSC.userBox);
              // userBox.clear();
              // AppConstants.navigatorKey.currentState?.pushNamedAndRemoveUntil(
              //   Routes.splash,
              //   (route) => false,
              // );
              break;
            case 403:
              break;
            case 404:
              break;
            default:
              break;
          }
        }
        handler.reject(error);
      },
    ),
  );
}
