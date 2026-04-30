part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class OnUpdateSession extends AccountEvent {
  final Session session;
  const OnUpdateSession(this.session);
}
