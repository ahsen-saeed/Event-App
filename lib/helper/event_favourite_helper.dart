import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _sharedPreferences;

class EventFavouriteHelper {
  static const String _EVENT_FAVOURITES = 'EventFavouriteHelper.event_favourites';
  static EventFavouriteHelper? _instance;

  EventFavouriteHelper._internal();

  static EventFavouriteHelper instance() {
    _instance ??= EventFavouriteHelper._internal();
    return _instance!;
  }

  static Future<void> initializeEventFavourites() async => _sharedPreferences = await SharedPreferences.getInstance();

  List<String> get favourites => _sharedPreferences?.getStringList(_EVENT_FAVOURITES) ?? <String>[];

  void addFavourite(String eventId) {
    final tempFavourites = favourites.toList();
    if (tempFavourites.contains(eventId)) return;
    tempFavourites.add(eventId);
    _sharedPreferences?.setStringList(_EVENT_FAVOURITES, tempFavourites);
  }

  void removeFavourite(String eventId) {
    final tempFavourites = favourites.toList();
    if (!tempFavourites.contains(eventId)) return;
    tempFavourites.remove(eventId);
    _sharedPreferences?.setStringList(_EVENT_FAVOURITES, tempFavourites);
  }
}
