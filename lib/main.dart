import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/data/models/user_model.dart';
import 'feature/presentation/cubit/auth/auth_dart_cubit.dart';
import 'feature/presentation/cubit/communication/communication_dart_cubit.dart';
import 'feature/presentation/cubit/get_device_number/get_device_numbers_dart_cubit.dart';
import 'feature/presentation/cubit/my_chat/my_chat_dart_cubit.dart';
import 'feature/presentation/cubit/phone_auth/phone_auth_dart_cubit.dart';
import 'feature/presentation/cubit/user/user_dart_cubit.dart';
import 'feature/presentation/screens/home_screen.dart';
import 'feature/presentation/screens/welcome_screen.dart';
import 'feature/presentation/widgets/theme/style.dart';
import 'injection_container.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider(
          create: (_) => di.sl<PhoneAuthCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>()..getAllUsers(),
        ),
        BlocProvider<GetDeviceNumbersCubit>(
          create: (_) => di.sl<GetDeviceNumbersCubit>(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => di.sl<CommunicationCubit>(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => di.sl<MyChatCubit>(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter WhatsApp Clone',
        theme: ThemeData(primaryColor: primaryColor),
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserLoaded) {
                        final currentUserInfo = userState.users.firstWhere(
                                (user) => user.uid == authState.uid,
                            orElse: () => const UserModel(isOnline: false, phoneNumber: '', name: '', email: '', uid: '', profileUrl: '', status: '',));
                        return HomeScreen(
                          userInfo: currentUserInfo, key: null,
                        );
                      }
                      return Container();
                    },
                  );
                }
                if (authState is UnAuthenticated) {
                  return const WelcomeScreen();
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }
}