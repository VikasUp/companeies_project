import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:companeies_project/modal/model.dart';
import 'package:companeies_project/webservices/webservice.dart';
import 'package:equatable/equatable.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _service = WebServices();
  ProfileBloc() : super(ProfileInitial()) {
    on<ButtonClicked>((event, emit) => _callApi(event, emit));
  }

  _callApi(ButtonClicked event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    var response = await _service.callProfileApi();
    if (response == null) {
      emit(ProfileError('Error'));
    } else {
      var body = jsonDecode(response.body);
      print('body- $body');
      var moviesResponse = Movie.fromJson(body);
      emit(ProfileSuccess(moviesResponse));
    }
  }
}
