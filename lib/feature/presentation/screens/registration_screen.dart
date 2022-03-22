import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../cubit/auth/auth_dart_cubit.dart';
import '../cubit/phone_auth/phone_auth_dart_cubit.dart';
import '../cubit/user/user_dart_cubit.dart';
import '../pages/phone_varification_page.dart';
import '../pages/set_initial_profile_page.dart';
import '../widgets/theme/style.dart';
import 'home_screen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode("92");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;
  String _phoneNumber="";

  final TextEditingController _phoneAuthController = TextEditingController();

  @override
  void dispose() {
    _phoneAuthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, phoneAuthState) {
          if (phoneAuthState is PhoneAuthSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (phoneAuthState is PhoneAuthFailure){
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Something is wrong"),
                    Icon(Icons.error_outline)
                  ],
                ),
              ),
            ));
          }
        },
        builder: (context, phoneAuthState) {
          if (phoneAuthState is PhoneAuthSmsCodeReceived) {
            return PhoneVerificationPage(
              phoneNumber: _phoneNumber, key: null,
            );
          }
          if (phoneAuthState is PhoneAuthProfileInfo) {
            return SetInitialProfileWidget(
              phoneNumber: _phoneNumber, key: null,
            );
          }
          if (phoneAuthState is PhoneAuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (phoneAuthState is PhoneAuthSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      if (userState is UserLoaded) {
                        final currentUserInfo = userState.users.firstWhere(
                                (user) => user.uid == authState.uid,
                            orElse: () => const UserModel(name: "", email:"", phoneNumber:"", isOnline:true, uid:"", status: "", profileUrl:""));
                        return HomeScreen(
                          userInfo: currentUserInfo, key: null,
                        );
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              },
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(""),
                Text(
                  "Verify your phone number",
                  style: TextStyle(
                      fontSize: 18,
                      color: greenColor,
                      fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "WhatsApp Clone will send and SMS message (carrier charges may apply) to verify your phone number. Enter your country code and phone number:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: _openFilteredCountryPickerDialog,
              title: _buildDialogItem(_selectedFilteredDialogCountry),
            ),
            Row(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            width: 1.50,
                            color: Colors.green,
                          ))),
                  width: 80,
                  height: 42,
                  alignment: Alignment.center,
                  child: Text(_selectedFilteredDialogCountry.phoneCode),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _phoneAuthController,
                      decoration: const InputDecoration(hintText: "Phone Number"),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: greenColor,
                  onPressed: _submitVerifyPhoneNumber,
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openFilteredCountryPickerDialog() {
    showDialog(
        context: context,
        builder: (_) => Theme(
          data: Theme.of(context).copyWith(
            primaryColor: primaryColor,
          ),
          child: CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colors.black,
            searchInputDecoration: const InputDecoration(
              hintText: "Search",
            ),
            isSearchable: true,
            title: const Text("Select your phone code"),
            onValuePicked: (Country country) {
              setState(() {
                _selectedFilteredDialogCountry = country;
                _countryCode = country.phoneCode;
              });
            },
            itemBuilder: _buildDialogItem,
          ),
        ));
  }

  Widget _buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.green, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(
            height: 8.0,
          ),
          Text("+${country.phoneCode}"),
          const SizedBox(
            height: 8.0,
          ),
          Text(country.name),
          const Spacer(),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  void _submitVerifyPhoneNumber() {
    if (_phoneAuthController.text.isNotEmpty) {
      _phoneNumber="+$_countryCode${_phoneAuthController.text}";
      BlocProvider.of<PhoneAuthCubit>(context).submitVerifyPhoneNumber(
        phoneNumber: _phoneNumber,
      );
    }
  }
}