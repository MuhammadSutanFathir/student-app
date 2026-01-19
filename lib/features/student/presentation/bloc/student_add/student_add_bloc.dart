import 'package:bloc/bloc.dart';
import 'package:student_app/features/student/domain/usecases/add_student.dart';
import 'student_add_event.dart';
import 'student_add_state.dart';

class StudentAddBloc extends Bloc<StudentAddEvent, StudentAddState> {
  final AddStudent addStudent;

  StudentAddBloc({required this.addStudent}) : super(StudentAddInitial()) {
    on<AddStudentRequested>((event, emit) async {
      emit(StudentAddLoading());

      final result = await addStudent(event.student);
      result.fold(
        (failure) => emit(StudentAddFailure(failure.message)),
        (_) => emit(StudentAddSuccess()),
      );
    });
  }
}
