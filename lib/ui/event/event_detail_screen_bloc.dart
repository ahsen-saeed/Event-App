import 'package:event_app/backend/backend_response.dart';
import 'package:event_app/helper/event_favourite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class EventDetailScreenBloc extends Cubit<bool> {
  final EventFavouriteHelper _eventFavouriteHelper = EventFavouriteHelper.instance();
  late final WebViewController webViewController;

  /// Is for when user go back to previous screen he will see the update favourite if the user add or remove the current event from favourite;
  bool isNeedUpdate = false;

  final Event event;

  EventDetailScreenBloc({required this.event}) : super(event.isFavourite) {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params);
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.setBackgroundColor(const Color(0x00000000));
    webViewController.loadRequest(Uri.parse(event.url));
  }

  void handleFavouriteAction() {
    final isFavourite = !state;
    isFavourite ? _eventFavouriteHelper.addFavourite(event.id) : _eventFavouriteHelper.removeFavourite(event.id);
    emit(isFavourite);
  }
}
