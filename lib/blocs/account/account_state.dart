part of 'account_bloc.dart';

class AccountState extends Equatable{
  final Session session;

  const AccountState({
    required this.session,
  });

  AccountState copyWith({
    Session? session,
  }) => AccountState(
    session: session ?? this.session,
  );

  @override
  List<Object> get props => [session];
}
