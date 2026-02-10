import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/domain/repositories/remote/remote_repository.dart';
import 'package:base_app/domain/repositories/remote/usecases/auth_remote_repository.dart';
import 'package:base_app/domain/repositories/remote/usecases/user_remote_repository.dart';

import '../dio/my_dio.dart';
import 'usecases/auth_endpoints.dart';
import 'usecases/user_endpoints.dart';

class ApiConsumer extends RemoteRepository {
  static final RemoteRepository _instace = ApiConsumer._();
  late MyDio _myDio;

  static RemoteRepository getInstance() => _instace;

  //* usecases
  late AuthEndpoints _authEndpoints;
  late UserEndpoints _userEndpoints;

  ApiConsumer._() {
    _myDio = MyDio(Constants.baseUrlApi);

    //* usecases
    _authEndpoints = AuthEndpoints(_myDio);
    _userEndpoints = UserEndpoints(_myDio);
  }

  @override
  AuthRemoteRepository get auth => _authEndpoints;

  @override
  UserRemoteRepository get user => _userEndpoints;
}
