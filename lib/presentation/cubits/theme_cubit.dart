import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cybersentry_ai/core/theme/app_theme.dart';

// Events
abstract class ThemeEvent {}

class SetDarkThemeEvent extends ThemeEvent {}

// States
abstract class ThemeState {
  final ThemeData themeData;
  
  ThemeState(this.themeData);
}

class ThemeInitial extends ThemeState {
  ThemeInitial() : super(AppTheme.darkTheme);
}

class DarkThemeState extends ThemeState {
  DarkThemeState() : super(AppTheme.darkTheme);
}

// Cubit
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  void setDarkTheme() {
    emit(DarkThemeState());
  }
}