part of "my_dio.dart";

//* cambiar esto para false para que no se muestre el error en el dio
const bool showDioError = true;

class CustomInterceptors extends Interceptor {
  // static final _header = {"content-type": "application/json; charset=utf-8"};
  final String? _token;
  final List<RequestOptions> requests = [];

  CustomInterceptors([this._token]);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    CustomPrint.call('REQUEST[${options.method}] => PATH: ${options.path}');

    //* agrega el request a la lista de requests
    if (Constants.isDev && showDioError) {
      requests.add(options);
    }

    //* agrega el token a la header si existe
    if (_token != null && _token.isNotEmpty) {
      options.headers.addAll({'authorization': "Bearer $_token"});
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    CustomPrint.call(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    //* remove el request de la lista de requests
    if (Constants.isDev && showDioError) {
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
    if (Constants.isDev && showDioError) {
      RequestOptions? request;
      if (requests.isNotEmpty) {
        try {
          request = removeRequest(err.requestOptions.path);
        } catch (_) {}
      }

      if (MyApp.context != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showModalBottomSheet(
            context: MyApp.context!,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            builder: (_) => ErrorDioDescription(request: request, err: err),
          );
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
