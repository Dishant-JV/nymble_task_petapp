part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  final bool isDarkMode;

  HomeState({required this.isDarkMode});
}

class HomeLoading extends HomeState {
  HomeLoading({bool isDarkMode = false}) : super(isDarkMode: isDarkMode);
}

class HomeLoaded extends HomeState {
  final List<String> itemList;

  HomeLoaded({required this.itemList, required bool isDarkMode})
      : super(isDarkMode: isDarkMode);
}
