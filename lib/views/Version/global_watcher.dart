import 'package:flutter/material.dart';
import 'package:nupura_cars/providers/VersionProvider/version_provider.dart';
import 'package:nupura_cars/views/Version/upgrade_dialog.dart';
import 'package:provider/provider.dart';


class UpgradeWatcher extends StatelessWidget {
  final Widget child;

  const UpgradeWatcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<VersionProvider>(
      builder: (context, versionProvider, _) {
        if (versionProvider.shouldShowDialog) {
          // Show dialog after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            versionProvider.markDialogShown();
            showUpgradeDialog(
              context: context,
              currentVersion: versionProvider.currentVersion,
              storeVersion: versionProvider.storeVersion,
            );
          });
        }
        return child;
      },
    );
  }
}
