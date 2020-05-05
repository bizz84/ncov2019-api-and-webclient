import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/environment.dart';

class CloudFunctionsService {
  CloudFunctionsService({@required this.cloudFunctions});
  final CloudFunctions cloudFunctions;

  Future<void> regenerateAuthorizationKey(Environment environment) async {
    Map<Environment, String> environmentName = {
      Environment.sandbox: 'sandbox',
      Environment.production: 'production',
    };

    final HttpsCallable callable = cloudFunctions.getHttpsCallable(
      functionName: 'regenerateAuthorizationKey',
    );
    final environmentArg = environmentName[environment];
    print('calling `regenerateAuthorizationKey($environmentArg)`');
    final result = await callable.call({'environment': environmentArg});
    return result.data;
  }
}
