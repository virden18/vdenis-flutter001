import 'package:dart_mappable/dart_mappable.dart';

part 'login_response.mapper.dart';

@MappableClass()
class LoginResponse with LoginResponseMappable {
  @MappableField(key: 'session_token')
  final String sessionToken;

  const LoginResponse({required this.sessionToken});
}
