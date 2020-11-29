import 'package:flutter/material.dart';
import 'package:uaaccesos/pages/qrcode.dart';
import 'package:uaaccesos/pages/record.dart';

class TabNavigationItem {
  final Widget page;

  TabNavigationItem({
    @required this.page,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(page: QrCodePage()),
        TabNavigationItem(page: RecordPage()),
      ];
}
