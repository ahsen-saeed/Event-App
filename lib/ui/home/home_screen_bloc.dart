import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_app/backend/backend_response.dart';
import 'package:event_app/backend/shared_web_service.dart';
import 'package:event_app/data/exception.dart';
import 'package:event_app/data/list_type_item.dart';
import 'package:event_app/data/meta_data.dart';
import 'package:event_app/data/page_indexer.dart';
import 'package:event_app/helper/event_favourite_helper.dart';
import 'package:event_app/ui/home/home_screen_bloc_state.dart';
import 'package:event_app/util/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBloc extends Cubit<HomeScreenBlocState> {
  static const int _PAGE_SIZE = 20;

  final Connectivity _connectivity = Connectivity();
  final EventFavouriteHelper _eventFavouriteHelper = EventFavouriteHelper.instance();
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final PageIndexer _pageIndexer = PageIndexer.initial();
  final List<Event> _events = <Event>[];

  StreamSubscription? _connectivityStreamSubscription;

  Future<bool> get _isNetworkConnected async => (await _connectivity.checkConnectivity()) != ConnectivityResult.none;

  HomeScreenBloc() : super(const HomeScreenBlocState.initial()) {
    requestEvents();

    _connectivityStreamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) return;

      if (state.bottomNetworkText.isEmpty) return;
      final lastHomeEventData = state.homeEvent;
      if (lastHomeEventData is! Data) return;

      final eventItems = lastHomeEventData.data as List<dynamic>;
      if (eventItems.isNotEmpty && eventItems.last is! DonePageItem && eventItems.last is! PaginatedItem) {
        eventItems.add(PaginatedItem(isShownOnce: true));
        emit(state.copyWith(homeEvent: Data(data: eventItems), bottomNetworkText: ''));
        requestPaginatedEvents();
      }
    });
  }

  Future<void> requestEvents() async {
    emit(state.copyWith(homeEvent: const Loading()));
    try {
      final events = await _sharedWebService.events(_pageIndexer.index);
      if (events.length >= _PAGE_SIZE) {
        _pageIndexer.inc();
        _pageIndexer.indexerState = PageIndexerState.paginated;
      } else {
        _pageIndexer.indexerState = PageIndexerState.ended;
      }
      populateEventWithFavourites(events);
      _events.addAll(events);

      final List<dynamic> eventItems = List.from(events);
      _pageIndexer.indexerState == PageIndexerState.paginated ? eventItems.add(PaginatedItem.initial()) : eventItems.add(const DonePageItem());
      emit(state.copyWith(homeEvent: Data(data: eventItems)));
    } catch (_) {
      emit(state.copyWith(homeEvent: const Error(exception: NoInternetConnectException())));
    }
  }

  Future<void> requestPaginatedEvents() async {
    try {
      final pageIndex = _pageIndexer.index;
      final events = await _sharedWebService.events(pageIndex);
      if (events.length >= _PAGE_SIZE) {
        _pageIndexer.inc();
        _pageIndexer.indexerState = PageIndexerState.paginated;
      } else {
        _pageIndexer.indexerState = PageIndexerState.ended;
      }
      populateEventWithFavourites(events);
      _events.addAll(events);

      final List<dynamic> eventItems = List.from(_events);
      _pageIndexer.indexerState == PageIndexerState.paginated ? eventItems.add(PaginatedItem.initial()) : eventItems.add(const DonePageItem());
      emit(state.copyWith(homeEvent: Data(data: eventItems)));
    } catch (_) {
      if (await _isNetworkConnected) {
        requestPaginatedEvents();
        return;
      }
      final lastEventData = state.homeEvent;
      if (lastEventData is! Data) return;
      final eventItems = lastEventData.data as List<dynamic>;
      eventItems.removeLast();
      emit(state.copyWith(homeEvent: Data(data: eventItems), bottomNetworkText: AppText.UNABLE_TO_CONNECT_WITH_EVENT));
    }
  }

  void addFavourite(String eventId) {
    _eventFavouriteHelper.addFavourite(eventId);

    // ignore: avoid_function_literals_in_foreach_calls
    _events.forEach((element) {
      if (element.id == eventId) element.isFavourite = true;
    });
  }

  Future<void> removeFavourite(String eventId) async {
    _eventFavouriteHelper.removeFavourite(eventId);

    // ignore: avoid_function_literals_in_foreach_calls
    _events.forEach((element) {
      if (element.id == eventId) element.isFavourite = false;
    });
  }

  void populateEventWithFavourites(List<Event> events) {
    final favouriteIds = _eventFavouriteHelper.favourites;

    // ignore: avoid_function_literals_in_foreach_calls
    events.forEach((element) {
      element.isFavourite = favouriteIds.contains(element.id);
    });
  }

  void refreshEvents() {
    final lastEventData = state.homeEvent;
    if (lastEventData is! Data) return;
    final allEventItems = lastEventData.data as List<dynamic>;

    Object? lastEventItem;
    if (allEventItems.last is! Event) {
      lastEventItem = allEventItems.last;
    }

    final tempEventItems = allEventItems.whereType<Event>().toList();
    populateEventWithFavourites(tempEventItems);
    final List<dynamic> eventItems = List.from(tempEventItems);

    if (lastEventItem != null) eventItems.add(lastEventItem);

    emit(state.copyWith(homeEvent: Data(data: eventItems)));
  }

  @override
  Future<void> close() {
    _connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
