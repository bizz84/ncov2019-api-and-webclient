import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/dashboard_page_type.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/endpoint.dart';

class DashboardLeftPanel extends StatelessWidget {
  const DashboardLeftPanel(
      {Key key, @required this.selectedPageType, @required this.onPageSelected})
      : super(key: key);
  final DashboardPageType selectedPageType;
  final ValueChanged<DashboardPageType> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DashboardListTile(title: 'Setup'),
        DashboardListTile(
          iconData: Icons.vpn_key,
          title: 'Authorization keys',
          isSelected: selectedPageType == DashboardPageType.authorizationKeys(),
          onPressed: () => onPageSelected(
            DashboardPageType.authorizationKeys(),
          ),
        ),
        DashboardListTile(
          iconData: Icons.lock,
          title: 'Access Tokens',
          isSelected: selectedPageType == DashboardPageType.accessTokens(),
          onPressed: () => onPageSelected(
            DashboardPageType.accessTokens(),
          ),
        ),
        DashboardListTile(title: 'Endpoints'),
        for (var endpoint in Endpoint.values)
          DashboardListTile(
            iconData: Icons.show_chart,
            title: endpoint.name,
            isSelected:
                selectedPageType == DashboardPageType.endpoint(endpoint),
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
    this.iconData,
    @required this.title,
    this.onPressed,
    this.isSelected = false,
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.grey[100] : Colors.white,
      child: ListTile(
        //dense: true,
        leading: iconData != null ? Icon(iconData) : null,
        title: Text(title),
        onTap: onPressed,
      ),
    );
  }
}
