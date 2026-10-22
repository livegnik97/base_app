part of "my_dio.dart";

class CustomInterceptors extends Interceptor {
  // static final _header = {"content-type": "application/json; charset=utf-8"};
  final List<RequestOptions> requests = [];

  String? token;
  String? language;
  String? infoDevice;

  CustomInterceptors();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    CustomPrint.call('REQUEST[${options.method}] => PATH: ${options.path}');
    if (options.queryParameters.isNotEmpty) {
      CustomPrint.call(
        'REQUEST[${options.method}] => QUERY: ${options.queryParameters}',
      );
    }

    //* agrega el request a la lista de requests
    if (Constants.isDev && Constants.showDioError) {
      requests.add(options);
    }

    //* agrega el token a la header si existe
    if (token != null && token!.isNotEmpty) {
      options.headers.addAll({'authorization': "Bearer $token"});
    }

    //* agrega el infoDevice a la header si existe
    if (infoDevice != null && infoDevice!.isNotEmpty) {
      options.headers.addAll({'user-agent': infoDevice});
    }

    //* agrega el language a la header si existe
    if (language != null && language!.isNotEmpty) {
      options.headers.addAll({'language': language});
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    CustomPrint.call(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    // CustomPrint.call(
    //   'RESPONSE DATA => ${response.data.toString()}',
    // );

    // CustomPrint.call('RESPONSE => DATA: ${response.data}');

    //* remove el request de la lista de requests
    if (Constants.isDev && Constants.showDioError) {
      if (requests.isNotEmpty) {
        try {
          removeRequest(response.requestOptions.path);
        } catch (_) {}
      }
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) {
    CustomPrint.call(
      'ERROR[${err.response?.statusCode}] => DATA: ${err.response?.data}',
    );
    // CustomPrint.call('ERROR[${err.response?.statusCode}] => DATA: ${err.requestOptions.data}');

    //* elimina el request de la lista de requests y lo muestra en el modal
    if (Constants.isDev && Constants.showDioError) {
      RequestOptions? request;
      if (requests.isNotEmpty) {
        try {
          request = removeRequest(err.requestOptions.path);
        } catch (_) {}
      }

      if (MyApp.context != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          try {
            showModalBottomSheet(
              context: MyApp.context!,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              builder: (_) => ErrorDioDescription(request: request, err: err),
            );
          } catch (_) {}
        });
      }
    }

    super.onError(err, handler);
    return Future(() => err);
  }

  RequestOptions? removeRequest(String path) {
    try {
      final index = requests.indexWhere((element) => element.path == path);
      if (index >= 0) {
        final request = requests[index];
        requests.removeAt(index);
        return request;
      }
    } catch (_) {}
    return null;
  }
}
