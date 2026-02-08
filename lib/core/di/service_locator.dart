import 'package:get_it/get_it.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';
import 'package:cocos_mobile_application/core/services/social_connection_service.dart';
import 'package:cocos_mobile_application/core/services/ai_caption_service.dart';
import 'package:cocos_mobile_application/core/services/facebook_auth_service.dart';
import 'package:cocos_mobile_application/core/services/facebook_api_service.dart';
import 'package:cocos_mobile_application/core/services/instagram_api_service.dart';
import 'package:cocos_mobile_application/core/services/location_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<SocialConnectionService>(
    () => SocialConnectionService(),
  );
  getIt.registerLazySingleton<AICaptionService>(() => AICaptionService());
  getIt.registerLazySingleton<FacebookAuthService>(() => FacebookAuthService());
  getIt.registerLazySingleton<FacebookApiService>(() => FacebookApiService());
  getIt.registerLazySingleton<InstagramApiService>(() => InstagramApiService());
  getIt.registerLazySingleton<LocationService>(() => LocationService());
}
