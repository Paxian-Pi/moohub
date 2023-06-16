import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLogin extends StatefulWidget {
  const FacebookLogin({Key? key}) : super(key: key);

  @override
  State<FacebookLogin> createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool? _checking = true;

  _ifUserIsLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    setState(() => _checking = false);

    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() => _userData = userData);
    } else {
      _login();
    }
  }

  _login() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      _accessToken = loginResult.accessToken;
      final userInfo = await FacebookAuth.instance.getUserData();
      _userData = userInfo;
    } else {
      debugPrint('ResultStatus: ${loginResult.status}');
      debugPrint('Message: ${loginResult.message}');
    }
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
  }

  @override
  void initState() {
    super.initState();
    _ifUserIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _checking!
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Welcome'),
                  _userData != null
                      ? Text(
                          '${_userData!['name']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        )
                      : Container(),
                  // _userData != null
                  //     ? Container(
                  //         child: Image.network(
                  //             _userData!\['picture']['data']['url']),
                  //       )
                  //     : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _logOut();
                      Navigator.pop(context);
                    },
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
    );
  }
}
