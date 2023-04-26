import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/extensions/context_extension.dart';
import 'package:event_app/extensions/date_time_extension.dart';
import 'package:event_app/ui/event/event_detail_screen_bloc.dart';
import 'package:event_app/util/base_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventDetailScreen extends StatelessWidget {
  static const String route = 'event_detail_screen_route';

  const EventDetailScreen();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EventDetailScreenBloc>();
    final theme = context.currentConstant;
    final images = bloc.event.images;
    images.sort((firstImage, secondImage) => firstImage.width.compareTo(secondImage.width));
    final image = images.last;
    final size = context.mediaSize;

    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, bloc.isNeedUpdate);
            return false;
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
            width: size.width,
            height: 200,
            child: Stack(alignment: Alignment.topLeft, children: [
              CachedNetworkImage(
                  width: size.width,
                  height: 200,
                  fit: BoxFit.fill,
                  imageUrl: image.url,
                  errorWidget: (_, __, ___) => const SizedBox(),
                  placeholder: (_, __) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                          width: 20, height: 20, child: CircularProgressIndicator.adaptive(backgroundColor: theme.colorSecondary, strokeWidth: 3)))),
              Positioned(
                  top: context.statusBarHeight,
                  left: 3,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context, bloc.isNeedUpdate), icon: const BackButtonIcon(), color: theme.colorOnSurface)),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      onPressed: bloc.handleFavouriteAction,
                      icon: BlocBuilder<EventDetailScreenBloc, bool>(
                          builder: (_, isFavourite) => Icon(isFavourite ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 30))))
            ])),
      Padding(
            padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
            child: Text(bloc.event.name, style: TextStyle(color: theme.colorOnSurface, fontFamily: BaseConstant.nunitoSansBold, fontSize: 20))),
      Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(bloc.event.dateTime.humanReadableDatetime,
                style: TextStyle(color: theme.colorOnSurface, fontFamily: BaseConstant.nunitoSansRegular, fontSize: 13))),
      Expanded(child: WebViewWidget(controller: bloc.webViewController))
    ]),
        ));
  }
}
