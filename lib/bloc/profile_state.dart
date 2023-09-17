part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Movie model;
  ProfileSuccess(this.model);
}

class ProfileError extends ProfileState {
  final String msg;

  ProfileError(this.msg);
}
