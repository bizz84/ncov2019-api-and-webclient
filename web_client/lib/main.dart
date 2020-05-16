import 'package:auth_widget_builder/auth_widget_builder.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth_service/firebase_auth_service.dart';
import 'package:google_sign_in_service/google_sign_in_service.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/api_dashboard.dart';
import 'package:ncov2019_codewithandrea_web_client/app/sign_in/sign_in_page.dart';
import 'package:ncov2019_codewithandrea_web_client/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/services/cloud_functions_service.dart';
import 'package:provider/provider.dart';
import 'package:ncov2019_codewithandrea_web_client/services/firestore_database.dart';

void main() => runApp(MyApp(
      authServiceBuilder: (_) => FirebaseAuthService(),
      googleSignInServiceBuilder: (_) => GoogleSignInService(),
      databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
    ));

class MyApp extends StatelessWidget {
  const MyApp(
      {Key key,
      this.authServiceBuilder,
      this.googleSignInServiceBuilder,
      this.databaseBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final GoogleSignInService Function(BuildContext context)
      googleSignInServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
        Provider<GoogleSignInService>(
          create: googleSignInServiceBuilder,
        ),
        Provider<CloudFunctionsService>(
          create: (_) =>
              CloudFunctionsService(cloudFunctions: CloudFunctions.instance),
        ),
      ],
      child: AuthWidgetBuilder(
        userProvidersBuilder: (_, user) => [
          Provider<User>.value(value: user),
          Provider<FirestoreDatabase>(
            create: (_) => FirestoreDatabase(uid: user.uid),
          ),
        ],
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            debugShowCheckedModeBanner: false,
            home: AuthWidget(
              userSnapshot: userSnapshot,
              nonSignedInBuilder: (_) => SignInPageBuilder(),
              signedInBuilder: (_) => APIDashboard(),
            ),
            onGenerateRoute: Router.onGenerateRoute,
          );
        },
      ),

      // child: AuthWidgetBuilder(
      //   databaseBuilder: databaseBuilder,
      //   builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
      //     return MaterialApp(
      //       theme: ThemeData(primarySwatch: Colors.indigo),
      //       debugShowCheckedModeBanner: false,
      //       home: AuthWidget(userSnapshot: userSnapshot),
      //       onGenerateRoute: Router.onGenerateRoute,
      //     );
      //   },
      // ),
    );
  }
}
