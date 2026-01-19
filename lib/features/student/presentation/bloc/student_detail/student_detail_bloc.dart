import 'package:bloc/bloc.dart';
import 'package:student_app/features/student/domain/usecases/get_student_detail.dart';
import 'student_detail_event.dart';
import 'student_detail_state.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final GetStudentDetail getStudentDetail;

  StudentDetailBloc({required this.getStudentDetail})
    : super(StudentDetailInitial()) {
    on<GetStudentDetailRequested>((event, emit) async {
      emit(StudentDetailLoading());

      final result = await getStudentDetail(event.nisn);
      result.fold(
        (failure) => emit(StudentDetailFailure(failure.message)),
        (student) => emit(StudentDetailLoaded(student)),
      );
    });
  }
}
