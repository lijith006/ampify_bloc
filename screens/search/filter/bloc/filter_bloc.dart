// import 'package:ampify_bloc/screens/search/filter/bloc/filter_event.dart';
// import 'package:ampify_bloc/screens/search/filter/bloc/filter_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FilterBloc extends Bloc<FilterEvent, FilterState> {
//   FilterBloc() : super(FilterInitial()) {
//     on<ApplyFilter>(_onApplyFilter);
//   }

//   void _onApplyFilter(ApplyFilter event, Emitter<FilterState> emit) async {
//     emit(FilterLoading());
//     try {
//       emit(FilterLoaded(event.filter));
//     } catch (e) {
//       emit(FilterError(e.toString()));
//     }
//   }
// }
//-----------------------------------------------------------------------
