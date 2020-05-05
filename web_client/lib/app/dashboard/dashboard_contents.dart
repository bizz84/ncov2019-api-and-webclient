import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/dashboard_left_panel.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/pages/access_tokens_page.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/pages/authorization_keys_page.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/pages/endpoint_page.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/dashboard_page_type.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';

class DashboardContents extends StatefulWidget {
  @override
  _DashboardContentsState createState() => _DashboardContentsState();
}

class _DashboardContentsState extends State<DashboardContents> {
  DashboardPageType _selectedPage = DashboardPageType.authorizationKeys();

  void _selectPage(DashboardPageType page) {
    if (_selectedPage != page) {
      setState(() => _selectedPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 300,
          color: Colors.white,
          child: DashboardLeftPanel(
            selectedPageType: _selectedPage,
            onPageSelected: _selectPage,
          ),
        ),
        Container(
          width: 0.5,
          color: Colors.grey[300],
        ),
        Expanded(
          child: _selectedPage.when(
            authorizationKeys: () => AuthorizationKeysPage(),
            accessTokens: () => AccessTokensPage(),
            endpoint: (endpoint) =>
                EndpointPage(endpoint, key: Key('${endpoint.toString()}')),
          ),
        ),
      ],
    );
  }
}
