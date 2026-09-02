import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'locale_event.dart';
part 'locale_state.dart';


class LocaleBloc
    extends Bloc<LocaleEvent, LocaleState> {

  LocaleBloc()
      : super(LocaleState(const Locale('en'))) {

    on<ChangeLocale>((event, emit) {
      emit(LocaleState(event.locale));
    });
  }
}