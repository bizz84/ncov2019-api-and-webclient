import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';

class API {
  static const String host =
      'us-central1-covid19-codewithandrea-dev-api.cloudfunctions.net';

  static Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        path: 'generateAccessToken',
      );

  static Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: '${_paths[endpoint]}',
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'casesSuspected',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
