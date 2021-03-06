import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/Usecase/use_case.dart';
import '../../../../core/error/Faliure.dart';
import '../../domain/entities/login_user.dart';
import '../../domain/usecases/get_facebook_login.dart';
import '../../domain/usecases/get_google_login.dart';
import '../../domain/usecases/get_login.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final GetFacebookLogin getFacebookLogin;
  final GetGoogleLogin getGoogleLogin;
  final GetLogin getLogin;

  LoginScreenBloc(
      {@required this.getFacebookLogin,
      @required this.getGoogleLogin,
      @required this.getLogin});

  @override
  LoginScreenState get initialState => Initial();

  @override
  Stream<LoginScreenState> mapEventToState(
    LoginScreenEvent event,
  ) async* {
    if (event is GetLoginEvent) {
      yield Loading();
      final response = await this.getLogin([event.email, event.password]);
      yield* response.fold(
        (failure) async* {
          if (failure.runtimeType == InvalidInputFaliure) {
            yield InvalidInputError();
          } else if (failure.runtimeType == ServerFaliure) {
            yield ServerError();
          } else if (failure.runtimeType == InternetConnectionFaliure) {
            yield InternetError();
          } else if (failure.runtimeType == UserBlockedFaliure) {
            yield UserBlockedError();
          }
        },
        (user) async* {
          print(user.getEmail);
          print(user.getPassword);
          yield Loaded(loginUser: user);
        },
      );
    } else if (event is GetGoogleLoginEvent) {
      yield Loading();
      final response = await this.getGoogleLogin(NoParams());
      yield* response.fold(
        (failure) async* {
          if (failure.runtimeType == InternetConnectionFaliure) {
            yield InternetError();
          } else if (failure.runtimeType == UserBlockedFaliure) {
            yield UserBlockedError();
          } else {
            yield ServerError();
          }
        },
        (user) async* {
          yield Loaded(loginUser: user); //* Loaded need to come here
        },
      );
    } else if (event is GetFacebookLoginEvent) {
      yield Loading();
      final response = await this.getFacebookLogin(NoParams());
      yield* response.fold(
        (failure) async* {
          if (failure.runtimeType == InternetConnectionFaliure) {
            yield InternetError();
          } else if (failure.runtimeType == UserBlockedFaliure) {
            yield UserBlockedError();
          } else {
            yield ServerError();
          }
        },
        (user) async* {
          yield Loaded(loginUser: user); //* Loaded need to come here
        },
      );
    }
  }
}
