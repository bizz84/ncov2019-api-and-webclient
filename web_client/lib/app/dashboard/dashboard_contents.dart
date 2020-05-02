import 'package:flutter/material.dart';
import 'package:ncov2019_codewithandrea_web_client/app/dashboard/dashboard_left_panel.dart';
import 'package:ncov2019_codewithandrea_web_client/app/models/dashboard_page_type.dart';

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
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.yellow,
            child: DashboardLeftPanel(
              selectedPageType: _selectedPage,
              onPageSelected: _selectPage,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
      ],
    );
  }
}
