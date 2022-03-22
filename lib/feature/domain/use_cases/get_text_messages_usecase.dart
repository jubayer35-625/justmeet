
import 'package:justmeet/feature/domain/repositories/firebase_repository.dart';

import '../entities/text_message_entity.dart';

class GetTextMessagesUseCase{
  final FirebaseRepository repository;

  GetTextMessagesUseCase({required this.repository});

  Stream<List<TextMessageEntity>> call(String channelId){
    return repository.getMessages(channelId);
  }
}