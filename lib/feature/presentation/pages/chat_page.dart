import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:justmeet/feature/presentation/pages/sub_pages/select_contact_page.dart';
import 'package:justmeet/feature/presentation/pages/sub_pages/single_communication_page.dart';
import 'package:justmeet/feature/presentation/pages/sub_pages/single_item_chat_user_page.dart';

import '../../domain/entities/user_entity.dart';
import '../cubit/my_chat/my_chat_dart_cubit.dart';
import '../widgets/theme/style.dart';



class ChatPage extends StatefulWidget {
  final UserEntity userInfo;

  const ChatPage({required Key? key, required this.userInfo}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: widget.userInfo.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyChatCubit, MyChatState>(
        builder: (_, myChatState) {
          if (myChatState is MyChatLoaded) {
            return _myChatList(myChatState);
          }
          return _loadingWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectContactPage(
                    userInfo: widget.userInfo, key: null,
                  )));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _emptyListDisplayMessageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: greenColor?.withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            Icons.message,
            color: Colors.white.withOpacity(.6),
            size: 40,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Start chat with your friends and family,\n on WhatsApp Clone",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.black.withOpacity(.4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _myChatList(MyChatLoaded myChatData) {
    return myChatData.myChat.isEmpty
        ? _emptyListDisplayMessageWidget()
        : ListView.builder(
      itemCount: myChatData.myChat.length,
      itemBuilder: (_, index) {
        final myChat=myChatData.myChat[index];
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SingleCommunicationPage(
                senderPhoneNumber: myChat.senderPhoneNumber,
                senderUID: widget.userInfo.uid,
                senderName: myChat.senderName,
                recipientUID: myChat.recipientUID,
                recipientPhoneNumber: myChat.recipientPhoneNumber,
                recipientName: myChat.recipientName, key: null,
              ),
            ));
          },
          child: SingleItemChatUserPage(
            name: myChat.recipientName,
            recentSendMessage: myChat.recentTextMessage,
            time: DateFormat('hh:mm a').format(myChat.time.toDate()), key: null,
          ),
        );
      },
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}