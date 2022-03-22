import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  const TextMessageModel(
      {   required String senderName,
        required String sederUID,
        required String recipientName,
        required String recipientUID,
        required String messageType,
        required String message,
        required String messageId,
        required Timestamp time,}
      ) : super(
    senderName:senderName,
    sederUID: sederUID,
    recipientName: recipientName,
    recipientUID: recipientUID,
    messsageType:messageType,
    message:message,
    messageId:messageId,
    time: time,
  );
  factory TextMessageModel.fromSnapShot(DocumentSnapshot snapshot){
    return TextMessageModel(
      senderName: snapshot.get(['senderName']).toString(),
      sederUID: snapshot.get(['sederUID']).toString(),
      recipientName: snapshot.get(['recipientName']).toString(),
      recipientUID: snapshot.get(['recipientUID']).toString(),
      messageType: snapshot.get(['messageType']).toString(),
      message: snapshot.get(['message']).toString(),
      messageId: snapshot.get(['messageId']).toString(),
      time: snapshot.get(['time']),
    );
  }
  Map<String,dynamic> toDocument(){
    return {
      "senderName":senderName,
      "sederUID":sederUID,
      "recipientName":recipientName,
      "recipientUID":recipientUID,
      "messageType":messsageType,
      "message":message,
      "messageId":messageId,
      "time":time,
    };
  }
}