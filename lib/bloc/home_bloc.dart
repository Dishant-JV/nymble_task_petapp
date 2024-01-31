import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pet_adopt/preference/shared_preference.dart';

part 'home_event.dart';

part 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<FetchDataEvent>((event, emit) async {
      emit(HomeLoading(isDarkMode: state.isDarkMode)); // Emit loading state
      try {
        bool isExists = await checkIfKeyExists("adoptedPetData");
        List<String> petData = [];
        if (!isExists) {
          setPrefList("adoptedPetData", []);
        } else {
          petData = await getPrefList("adoptedPetData");
        }
        emit(HomeLoaded(itemList: petData,isDarkMode: state.isDarkMode));
      } catch (e) {}
    });

    on<ToggleThemeEvent>((event, emit) {
      emit(HomeLoaded(
          itemList: (state as HomeLoaded).itemList,
          isDarkMode: !state.isDarkMode)); // Toggle dark mode
    });
  }
  void fetchData() {
    add(FetchDataEvent());
  }
  void toggleTheme() {
    add(ToggleThemeEvent());
  }
}

