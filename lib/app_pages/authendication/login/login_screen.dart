import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/index_utils.dart';
import '../../../app_utils/services/login_service.dart';
import '../../../app_model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AlertService alertService = AlertService();

  final TextEditingController _userCntlr = TextEditingController();
  final TextEditingController _passwordCntlr = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    BoxStorage storage = BoxStorage();
    var logInfo = storage.getLoginInfo();
    if (logInfo != null && logInfo['rememberMe'] == true) {
      setState(() {
        _userCntlr.text = logInfo['username']!;
        _passwordCntlr.text = logInfo['password']!;
        _rememberMe = logInfo['rememberMe'];
      });
    } else {
        _userCntlr.text = '';
        _passwordCntlr.text = '';
        _rememberMe = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dark = RHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(RSizes.overallPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: RSizes.spaceBtwSections),
                    Image(
                      image: AssetImage(
                        dark ? RImages.darkAppLogo : RImages.lightAppLogo,
                      ),
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections),
                    CustomInputField(
                      controller: _userCntlr,
                      labelText: 'Mobile No',
                      hintText: 'Enter your Mobile No',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // allow only numbers
                        LengthLimitingTextInputFormatter(
                          10,
                        ), // limit to 10 digits
                      ],
                      validator: (value) =>
                          RValidator.validatePhoneNumber(value),
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),
                    CustomInputField(
                      controller: _passwordCntlr,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done,
                      validator: (value) => RValidator.validatePassword(value),
                    ),
                    const SizedBox(height: RSizes.spaceBtwInputFields),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text(
                              'Remember me',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color.fromARGB(255, 22, 79, 126),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections),
                    SizedBox(
                      height: RHelperFunctions.buttonHeight(context),
                      width: RHelperFunctions.buttonWidth(context),
                      child: ElevatedButton(
                        onPressed: () => formSubmit(),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> formSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        alertService.showLoading();
        
        // Call the login API
        final loginResponse = await LoginService.login(
          mobileNumber: _userCntlr.text.trim(),
          password: _passwordCntlr.text.trim(),
        );
        
        await handleLoginResponse(loginResponse);
      } on LoginException catch (e) {
        alertService.hideLoading();
        alertService.errorToast(e.message);
      } catch (e) {
        alertService.hideLoading();
        alertService.errorToast('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> handleLoginResponse(LoginResponse loginResponse) async {
    try {
      alertService.hideLoading();
      
      if (loginResponse.isSuccess && loginResponse.userDetails.isNotEmpty) {
        final user = loginResponse.userDetails.first;
        
        // Save user data
        await BoxStorage().saveUserDetails(loginResponse.userDetails.map((u) => u.toJson()).toList());
        await BoxStorage().saveUserToken(user.userToken);
        await BoxStorage().saveUserType(user.userType);
        
        // Handle remember me functionality
        if (_rememberMe) {
          await BoxStorage().saveLoginInfo(
            _userCntlr.text,
            _passwordCntlr.text,
            _rememberMe,
          );
        } else {
          await BoxStorage().deleteLoginInfo();
        }
        
        alertService.successToast(loginResponse.message);
        
        // Navigate based on user type
        _navigateBasedOnUserType(user.userType);
      } else {
        alertService.errorToast(loginResponse.message);
      }
    } catch (e) {
      alertService.errorToast('Error processing login response: ${e.toString()}');
    }
  }

  void _navigateBasedOnUserType(String userType) {
    switch (userType.toUpperCase()) {
      case 'ADMIN':
        Navigator.pushNamedAndRemoveUntil(
          context,
          'adminDashboard',
          (route) => false,
        );
        break;
      case 'ASP':
        Navigator.pushNamedAndRemoveUntil(
          context,
          'aspDashboard',
          (route) => false,
        );
        break;
      case 'MECHANIC':
        Navigator.pushNamedAndRemoveUntil(
          context,
          'mechanicDashboard',
          (route) => false,
        );
        break;
      default:
        alertService.errorToast('Unknown user type: $userType');
        break;
    }
  }
}
