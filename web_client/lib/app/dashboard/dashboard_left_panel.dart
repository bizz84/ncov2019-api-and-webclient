import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/dashboard_page_type.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';

class DashboardLeftPanel extends StatelessWidget {
  const DashboardLeftPanel(
      {Key key, @required this.selectedPageType, @required this.onPageSelected})
      : super(key: key);
  final DashboardPageType selectedPageType;
  final ValueChanged<DashboardPageType> onPageSelected;

  static const Map<Endpoint, String> endpointNames = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'casesSuspected',
    Endpoint.casesConfirmed: 'casesConfirmed',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DashboardListTile(
          title: 'Authorization keys',
          isSelected: selectedPageType == DashboardPageType.authorizationKeys(),
          onPressed: () => onPageSelected(
            DashboardPageType.authorizationKeys(),
          ),
        ),
        DashboardListTile(
          title: 'Access Tokens',
          isSelected: selectedPageType == DashboardPageType.accessTokens(),
          onPressed: () => onPageSelected(
            DashboardPageType.accessTokens(),
          ),
        ),
        DashboardListTile(title: 'Endpoints'),
        for (var endpoint in Endpoint.values)
          DashboardListTile(
            title: endpointNames[endpoint],
            isSelected:
                selectedPageType == DashboardPageType.endpoint(endpoint),
            isNested: true,
            onPressed: () => onPageSelected(
              DashboardPageType.endpoint(endpoint),
            ),
          ),
      ],
    );
  }
}

class DashboardListTile extends StatelessWidget {
  const DashboardListTile({
    Key key,
    @required this.title,
    this.onPressed,
    this.isSelected = false,
    this.isNested = false,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.grey[100] : Colors.white,
      child: ListTile(
        leading: isNested ? Icon(Icons.chevron_right) : null,
        title: Text(title),
        onTap: onPressed,
      ),
    );
  }
}
