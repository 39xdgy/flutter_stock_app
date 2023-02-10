import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:fortune_cookie/services/user.dart';
import 'package:fortune_cookie/widgets/utils.dart';
import 'package:fortune_cookie/models/user.dart' as user_model;

class PersonalDataPage extends StatefulWidget {
  PersonalDataPage({
    super.key,
    required this.userData,
  });
  final user_model.User? userData;

  @override
  _PersonalDataPageState createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;
  String id = "";
  String firstName = "";
  String lastName = "";
  String nickName = "";
  String email = "";
  String phone = "";
  int cookieNumber = 0;
  List<String> resultList = [];
  List<String> favStock = [];
  List<String> strategy = [];

  TextEditingController? emailController;
  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? nickNameController;
  TextEditingController? phoneController;
  ScrollController _scrollController = ScrollController();
  final phoneMask = MaskTextInputFormatter(mask: '+# (###) ###-##-##');

  @override
  void initState() {
    super.initState();
    setState(() {
      //nasty type transform stuff
      email = widget.userData?.toJson()['email'];
      id = widget.userData?.toJson()['id'];
      firstName = widget.userData?.toJson()['first_name'];
      lastName = widget.userData?.toJson()['last_name'];
      nickName = widget.userData?.toJson()['nick_name'];
      phone = widget.userData?.toJson()['phone_number'];
      cookieNumber = widget.userData?.toJson()['cookie_number'];
      if (widget.userData?.toJson()['result_list'].isEmpty) {
        resultList = [];
      } else {
        resultList = widget.userData?.toJson()['result_list'];
      }
      if (widget.userData?.toJson()['fav_stock'].isEmpty) {
        favStock = [];
      } else {
        favStock = widget.userData?.toJson()['fav_stock'];
      }
      if (widget.userData?.toJson()['strategy'].isEmpty) {
        strategy = [];
      } else {
        strategy = widget.userData?.toJson()['strategy'];
      }
    });
    emailController = TextEditingController(text: email);
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    nickNameController = TextEditingController(text: nickName);
    phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    emailController?.dispose();
    firstNameController?.dispose();
    lastNameController?.dispose();
    nickNameController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future done() async {
      UserService userService = UserService();
      await userService
          .updateUser(
        id,
        firstNameController!.text.trim(),
        lastNameController!.text.trim(),
        nickNameController!.text.trim(),
        emailController!.text.trim(),
        phoneController!.text.trim(),
        cookieNumber,
        resultList,
        favStock,
        strategy,
      )
          .then(
        (value) {
          if (value == "error") {
            Utils.showSnackBar("Something went wrong, try again later");
          } else {
            Utils.showSnackBarBlue("Personal data updated successfully");
            Navigator.of(context).pop(true);
          }
        },
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: AppBar(
          backgroundColor: const Color(0xFFE5E5E5),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF1A73E8),
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Personal Data',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Inter',
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: SizedBox(
                width: 62,
                height: 35,
                child: TextButton(
                  onPressed: done,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Done',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Inter',
                      color: const Color(0xFF1A73E8),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/img/avatar/2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF1A73E8),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        'Change Profile Picture',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: firstNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          hintText: 'First Name',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: const Color(0xFF101213),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: lastNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          hintText: 'Last Name',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: const Color(0xFF101213),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                      child: TextFormField(
                        controller: nickNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Nick Name',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          hintText: 'Nick Name',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: const Color(0xFF101213),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                      child: TextFormField(
                        controller: emailController,
                        readOnly: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          hintText: 'Email',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: const Color(0xFF101213),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                      child: TextFormField(
                        controller: phoneController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          hintText: 'Phone Number',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: const Color(0xFF57636C),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF1F4F8),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              20, 24, 0, 24),
                        ),
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: const Color(0xFF101213),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMask],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
