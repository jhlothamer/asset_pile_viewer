import 'package:assetPileViewer/data/asset_pile_viewer_db_schema.dart';
import 'package:assetPileViewer/features/folder_view/folder_view_page.dart';
import 'package:assetPileViewer/features/unsupported_db_version/unsupported_db_version_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRoutes {
  static const String _routeNotFoundRoute = 'NOTFOUND';
  static const application = '/application';

  static final Map<String, Widget Function(BuildContext context, WidgetRef ref)>
      _routes = {
    '/': (_, ref) {
      if (dbSchemaVersionUnsupported) {
        return const UnsupportedDbVersionPage();
      }
      return const FolderViewPage();
    },
    application: (_, __) {
      return const FolderViewPage();
    },
    _routeNotFoundRoute: (_, __) {
      return const Placeholder();
    }
  };

  static MaterialPageRoute onGenerateRoute(
      RouteSettings settings, WidgetRef ref) {
    if (!_routes.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: (context) => _routes[_routeNotFoundRoute]!(context, ref));
    }
    return MaterialPageRoute(
        builder: (context) => _routes[settings.name]!(context, ref));
  }
}
