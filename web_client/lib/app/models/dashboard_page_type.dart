import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';

// Generate with `flutter pub run build_runner build`
part 'dashboard_page_type.freezed.dart';

@freezed
abstract class DashboardPageType with _$DashboardPageType {
  const factory DashboardPageType.authorizationKeys() = AuthorizationKeys;
  const factory DashboardPageType.accessTokens() = AccessTokens;
  const factory DashboardPageType.endpoint(Endpoint endpoint) = AnEndpoint;
}
