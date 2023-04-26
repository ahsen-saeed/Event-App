import 'package:equatable/equatable.dart';
import 'package:event_app/data/meta_data.dart';

class HomeScreenBlocState extends Equatable {
  final DataEvent homeEvent;
  final String bottomNetworkText;

  const HomeScreenBlocState._({required this.homeEvent, required this.bottomNetworkText});

  const HomeScreenBlocState.initial() : this._(homeEvent: const Initial(), bottomNetworkText: '');

  HomeScreenBlocState copyWith({DataEvent? homeEvent, String? bottomNetworkText}) =>
      HomeScreenBlocState._(homeEvent: homeEvent ?? this.homeEvent, bottomNetworkText: bottomNetworkText ?? this.bottomNetworkText);

  @override
  List<Object> get props => [homeEvent, bottomNetworkText];

  @override
  bool get stringify => true;
}
