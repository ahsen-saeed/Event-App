import 'package:event_app/extensions/context_extension.dart';
import 'package:event_app/util/app_strings.dart';
import 'package:event_app/util/base_constants.dart';
import 'package:flutter/cupertino.dart';

class NetworkErrorTryAgain extends StatelessWidget {
  final EdgeInsetsDirectional margin;
  final VoidCallback onClick;

  const NetworkErrorTryAgain({required this.margin, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final theme = context.currentConstant;
    return Container(
        width: context.mediaSize.width,
        margin: margin,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppText.LIMITED_NETWORK_CONNECTION,
                  style: TextStyle(color: theme.colorOnSurface, fontFamily: BaseConstant.nunitoSansSemibold, fontSize: 20),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(AppText.LIMITED_NETWORK_CONNECTION_CONTENT,
                  style: TextStyle(color: theme.colorOnSurface, fontFamily: BaseConstant.nunitoSansRegular, fontSize: 15),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              CupertinoButton(
                  onPressed: onClick,
                  child: Text(AppText.TRY_AGAIN,
                      style: TextStyle(color: theme.colorOtherSecondary, fontFamily: BaseConstant.nunitoSansRegular, fontSize: 14)))
            ]));
  }
}
