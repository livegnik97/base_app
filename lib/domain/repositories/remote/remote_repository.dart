import 'usecases/auth_remote_repository.dart';
import 'usecases/user_remote_repository.dart';

abstract class RemoteRepository {
  AuthRemoteRepository get auth;
  UserRemoteRepository get user;
}
