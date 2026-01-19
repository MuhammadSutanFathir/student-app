import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_app/features/tema/domain/entities/theme_entity.dart';
import 'package:student_app/features/tema/domain/usecases/get_theme.dart';
import 'package:student_app/features/tema/domain/usecases/set_theme.dart';

part 'tema_event.dart';
part 'tema_state.dart';

class TemaBloc extends Bloc<TemaEvent, TemaState> {
  final GetTheme getThemeUsecase;
  final SaveTheme saveThemeUsecase;

  TemaBloc({required this.getThemeUsecase, required this.saveThemeUsecase})
    : super(TemaInitial()) {
    on<GetThemeEvent>((event, emit) async {
      emit(TemaLoading());

      final result = await getThemeUsecase();

      result.fold(
        (failure) => emit(const ThemeError('Gagal memuat tema')),
        (theme) => emit(TemaLoaded(theme)),
      );
    });
    on<SaveThemeEvent>((event, emit) async {
      emit(TemaLoading());

      final result = await saveThemeUsecase(event.themeEntity);

      result.fold(
        (failure) => emit(const ThemeError('Gagal menyimpan tema')),
        (_) => emit(TemaLoaded(event.themeEntity)),
      );
    });

    on<ResetThemeEvent>((event, emit) async {
      final lightTheme = ThemeEntity(themeType: ThemeType.light);

      await saveThemeUsecase(lightTheme);
      emit(TemaLoaded(lightTheme));
    });
  }
}
