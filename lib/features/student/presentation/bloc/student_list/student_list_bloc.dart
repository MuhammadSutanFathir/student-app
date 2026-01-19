import 'package:bloc/bloc.dart';
import 'package:student_app/features/student/domain/usecases/get_students.dart';
import 'student_list_event.dart';
import 'student_list_state.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final GetStudents getStudents;

  StudentListBloc({required this.getStudents}) : super(StudentListInitial()) {
    on<GetStudentsRequested>((event, emit) async {
      emit(StudentListLoading());

      final result = await getStudents();
      result.fold(
        (failure) => emit(StudentListFailure(failure.message)),
        (students) => emit(StudentListLoaded(students)),
      );
    });
  }
}
