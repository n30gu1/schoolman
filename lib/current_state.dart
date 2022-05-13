import 'package:equatable/equatable.dart';

class CurrentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends CurrentState {}

class DoneState extends CurrentState {
  final List? result;

  DoneState({this.result});

  @override
  List<Object?> get props => [result];
}

class ErrorState extends CurrentState {
  final String error;

  ErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
