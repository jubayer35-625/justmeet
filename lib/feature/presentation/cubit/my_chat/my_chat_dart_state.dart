part of 'my_chat_dart_cubit.dart';


abstract class MyChatState extends Equatable {
  const MyChatState();
}

class MyChatInitial extends MyChatState {
  @override
  List<Object> get props => [];
}
class MyChatLoaded extends MyChatState {
  final List<MyChatEntity> myChat;

  const MyChatLoaded({required this.myChat});
  @override
  List<Object> get props => [myChat];
}