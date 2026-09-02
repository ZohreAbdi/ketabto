part of 'locale_bloc.dart';

@immutable
abstract class LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final Locale locale;

  ChangeLocale(this.locale);
}
