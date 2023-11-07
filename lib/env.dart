import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY_ANON_PUBLIC', obfuscate: true)
  static final String apiKeyAnonPublic = _Env.apiKeyAnonPublic;
  @EnviedField(varName: 'API_KEY_SERVICE_ROLE_SECRET', obfuscate: true)
  static final String apiKeyServiceRoleSecret = _Env.apiKeyServiceRoleSecret;
  @EnviedField(varName: 'SUPABASE_PROJECT_URL', obfuscate: true)
  static final String supabaseProjectUrl = _Env.supabaseProjectUrl;
}
