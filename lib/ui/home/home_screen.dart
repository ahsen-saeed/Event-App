import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/backend/backend_response.dart';
import 'package:event_app/data/list_type_item.dart';
import 'package:event_app/data/meta_data.dart';
import 'package:event_app/extensions/context_extension.dart';
import 'package:event_app/extensions/date_time_extension.dart';
import 'package:event_app/ui/common/network_error_try_again.dart';
import 'package:event_app/ui/event/event_detail_screen.dart';
import 'package:event_app/ui/home/home_screen_bloc.dart';
import 'package:event_app/ui/home/home_screen_bloc_state.dart';
import 'package:event_app/util/app_strings.dart';
import 'package:event_app/util/base_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/';

  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final theme = context.currentConstant;
    final bloc = context.read<HomeScreenBloc>();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: theme.colorPrimary,
            title: Text(AppText.EVENTS, style: TextStyle(fontFamily: BaseConstant.nunitoSansSemibold, fontSize: 20, color: theme.colorOnPrimary)),
            actions: [IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart_fill, size: 24, color: theme.colorOnPrimary))]),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: BlocBuilder<HomeScreenBloc, HomeScreenBlocState>(
                  buildWhen: (previous, current) => previous.homeEvent != current.homeEvent,
                  builder: (_, state) {
                    final dataEvent = state.homeEvent;
                    if (dataEvent is Data) {
                      final eventItems = dataEvent.data as List<dynamic>;
                      return ListView.builder(
                          itemBuilder: (_, index) {
                            final item = eventItems[index];
                            if (item is Event) {
                              return _SingleEventItem(
                                  event: item,
                                  onClick: () async {
                                    final result = await Navigator.pushNamed(context, EventDetailScreen.route, arguments: item);
                                    if (result == null || result is! bool && result == false) return;
                                    bloc.refreshEvents();
                                  },
                                  theme: theme,
                                  bloc: bloc);
                            } else if (item is PaginatedItem) {
                              return _PaginatedListItemWidget(paginatedItem: item, onProgressShowing: bloc.requestPaginatedEvents);
                            } else if (item is DonePageItem) {
                              return const _DoneListItemWidget();
                            }
                            return const SizedBox();
                          },
                          itemCount: eventItems.length);
                    } else if (dataEvent is Error) {
                      return NetworkErrorTryAgain(margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 80), onClick: bloc.requestEvents);
                    }
                    return Center(child: CircularProgressIndicator.adaptive(backgroundColor: theme.colorSecondary));
                  })),
          BlocBuilder<HomeScreenBloc, HomeScreenBlocState>(
              buildWhen: (previous, current) => previous.bottomNetworkText != current.bottomNetworkText,
              builder: (_, state) => state.bottomNetworkText.isEmpty
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      width: MediaQuery.of(context).size.width,
                      color: theme.colorError.withOpacity(0.7),
                      alignment: Alignment.center,
                      child: Text(state.bottomNetworkText,
                          style: TextStyle(
                              fontSize: 12, color: theme.colorError, fontFamily: BaseConstant.nunitoSansRegular, letterSpacing: 0.166666667)))),
        ]));
  }
}

class _SingleEventItem extends StatelessWidget {
  final Event event;
  final Function onClick;
  final BaseConstant theme;
  final HomeScreenBloc bloc;

  const _SingleEventItem({required this.event, required this.onClick, required this.theme, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final images = event.images;
    images.sort((firstImage, secondImage) => firstImage.width.compareTo(secondImage.width));
    final image = images.first;

    return InkWell(
        onTap: () => onClick.call(),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CachedNetworkImage(
                      width: 80,
                      height: 60,
                      imageUrl: image.url,
                      imageBuilder: (_, imageProvider) => Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              borderRadius: const BorderRadius.all(Radius.circular(10)))),
                      errorWidget: (_, __, ___) => const SizedBox(),
                      placeholder: (_, __) => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(backgroundColor: theme.colorSecondary, strokeWidth: 3)))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Text(event.name,
                            style: TextStyle(color: theme.colorOnSurface, fontFamily: BaseConstant.nunitoSansRegular, fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text('${AppText.OCCURRED_ON}: ${event.dateTime.humanReadableDatetime}'),
                          StatefulBuilder(builder: (_, stateSetter) {
                            return IconButton(
                                splashRadius: 6,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  final isFavourite = !event.isFavourite;
                                  stateSetter.call(() => event.isFavourite = isFavourite);
                                  isFavourite ? bloc.addFavourite(event.id) : bloc.removeFavourite(event.id);
                                },
                                icon:
                                    Icon(event.isFavourite ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: theme.colorSecondary, size: 24),
                                padding: const EdgeInsets.all(0));
                          })
                        ])
                      ]))
                ])));
  }
}

class _PaginatedListItemWidget extends StatelessWidget {
  final PaginatedItem paginatedItem;
  final VoidCallback onProgressShowing;

  const _PaginatedListItemWidget({required this.paginatedItem, required this.onProgressShowing});

  @override
  Widget build(BuildContext context) {
    final theme = context.currentConstant;

    if (!paginatedItem.isShownOnce) {
      paginatedItem.isShownOnce = true;
      onProgressShowing.call();
    }
    return context.isHaveBottomNotch
        ? Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: theme.colorSecondary, strokeWidth: 3))))
        : Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: theme.colorSecondary, strokeWidth: 3))));
  }
}

class _DoneListItemWidget extends StatelessWidget {
  const _DoneListItemWidget();

  @override
  Widget build(BuildContext context) {
    final theme = context.currentConstant;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            3,
            (index) => Container(
                margin: EdgeInsets.only(top: 10, right: 3, bottom: context.isHaveBottomNotch ? 35 : 10),
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorPrimary))));
  }
}
