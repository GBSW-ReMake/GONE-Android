import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/design_system/gone_theme.dart';
import 'package:gone/core/error/api_error_code.dart';
import 'package:gone/features/auth/application/auth_repository_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/account_role.dart';
import 'auth_widgets.dart';

enum _SignupStep {
  identifier,
  password,
  phone,
  // name,
  profile,
}

extension on _SignupStep {
  String get title => switch (this) {
    _SignupStep.identifier => '아이디를 입력해주세요',
    _SignupStep.password => '비밀번호를 설정해주세요',
    _SignupStep.phone => '전화번호를 입력해주세요',
    // _SignupStep.name => '이름을 입력해주세요',
    _SignupStep.profile => '프로필 사진을 설정해주세요',
  };

  String get description => switch (this) {
    _SignupStep.identifier => '계정 확인을 위해 아이디가 필요해요.',
    _SignupStep.password => '8자 이상, 영문과 숫자를 포함해 입력해주세요.',
    _SignupStep.phone => '서비스 이용을 위해 전화번호 인증이 필요해요.',
    // _SignupStep.name => '특색있는 별명을 지어보세요.',
    _SignupStep.profile => '나중에 언제든지 바꿀 수 있어요.',
  };
}

class _SignupFields {
  final identifier = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  final phone = TextEditingController();
  final verificationCode = TextEditingController();

  // final name = TextEditingController();

  void dispose() {
    for (final controller in [
      identifier,
      password,
      confirmation,
      phone,
      verificationCode,
      // name,
    ]) {
      controller.dispose();
    }
  }
}

class _SignupErrors {
  String? identifier;
  String? password;
  String? confirmation;
  String? phone;
  String? verificationCode;

  // String? name;

  void clear() {
    identifier = null;
    password = null;
    confirmation = null;
    phone = null;
    verificationCode = null;
    // name = null;
  }
}

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key, required this.role, required this.onBack});

  final AccountRole role;
  final VoidCallback onBack;

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _fields = _SignupFields();
  final _errors = _SignupErrors();

  _SignupStep _step = _SignupStep.identifier;
  XFile? _profileImage;
  String _verificationTicket = '';

  @override
  void dispose() {
    _fields.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final isValid = await _validateStep();
    if (!isValid) {
      setState(() {});
      return;
    }

    if (_step == _SignupStep.profile) {
      await ref.read(authRepositoryProvider).signup(
        _fields.identifier.text,
        _fields.password.text,
        _fields.phone.text,
          _verificationTicket
      );
      showServiceNotice(context, '회원가입 서비스 연결 정보를 확인 중입니다. 잠시 후 다시 시도해주세요.');
      return;
    }

    setState(() {
      _errors.clear();
      _step = _SignupStep.values[_step.index + 1];
    });
  }

  void _back() {
    if (_step == _SignupStep.identifier) {
      widget.onBack();
      return;
    }
    setState(() {
      _errors.clear();
      _step = _SignupStep.values[_step.index - 1];
    });
  }

  Future<bool> _validateStep() => switch (_step) {
    _SignupStep.identifier => _validateIdentifier(),
    _SignupStep.password => _validatePassword(),
    _SignupStep.phone => _validatePhone(),
    // _SignupStep.name => _validateName(),
    _SignupStep.profile => Future.value(true),
  };

  Future<bool> _validateIdentifier() async {
    final value = _fields.identifier.text;
    if (value.trim().isEmpty) {
      _errors.identifier = '아이디를 입력해주세요.';
      return false;
    }

    final result = await ref
        .read(authRepositoryProvider)
        .loginIdCheck(value);

    if(result == ApiErrorCode.common001) {
      _errors.identifier = '아이디는 영문, 숫자로만 4자 이상 20자 이하로 입력해주세요';
      return false;
    }

    if (result != null) {
      _errors.identifier = result.message;
      return false;
    }

    return true;
  }

  Future<bool> _validatePassword() async {
    if (_fields.password.text.isEmpty) {
      _errors.password = '비밀번호를 입력해주세요.';
      return false;
    }

    _errors.confirmation = _fields.password.text != _fields.confirmation.text
        ? '비밀번호가 일치하지 않습니다.'
        : null;

    return _errors.confirmation == null;
  }

  Future<bool> _validatePhone() async {
    if (_fields.verificationCode.text.trim().isEmpty) {
      _errors.verificationCode = '인증번호를 입력해주세요.';
      return false;
    }

    // TODO 인증 번호 부분은 나중에 다시
    // final result = await ref
    //     .read(authRepositoryProvider)
    //     .verifyPhoneCode(_fields.phone.text, _fields.verificationCode.text);
    // if (!result['success']) {
    //   _errors.verificationCode =
    //       '인증번호가 일치하지 않습니다. (남은 시도 횟수: ${result['data']['maxFailCount'] - result['data']['currentFailCount']})';
    //   return false;
    // }
    // _verificationTicket = result['data']['ticket'];
    return true;
  }

  // 회원가입시 이름 필드 불필요
  // Future<bool> _validateName() async {
  //   _errors.name = _fields.name.text.trim().isEmpty ? '이름을 입력해주세요.' : null;
  //   return _errors.name == null;
  // }

  Future<void> _sendVerificationCode() async {
    final digits = _fields.phone.text.replaceAll(RegExp(r'[^0-9]'), '');
    String? error;

    if (_fields.phone.text.contains('-')) {
      error = '휴대폰 번호는 하이픈 없이 01012345678 형식으로 입력해주세요.';
    } else if (digits.length != 11) {
      error = '올바른 전화번호를 입력해주세요.';
    }

    setState(() => _errors.phone = error);
    if (error != null) return;

    final result = await ref.read(authRepositoryProvider).sendPhoneCode(_fields.phone.text);

    // if (result != null) {
    //   _errors.identifier = result.message;
    //   return false;
    // }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (!mounted || image == null) return;
    setState(() => _profileImage = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: GonePrimaryButton(
          label: _step == _SignupStep.profile ? '시작하기' : '다음',
          onPressed: _next,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GoneBackButton(onPressed: _back, label: '뒤로가기'),
                  ),
                  GoneLogo(width: 80),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 35, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressBar(),
                    const SizedBox(height: 34),
                    Text(
                      _step.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _step.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GoneColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 34),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: _buildStepForm(),
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

  Widget _buildProgressBar() {
    return Semantics(
      label: '회원가입 ${_step.index + 1}단계, 전체 5단계',
      child: Row(
        spacing: 8,
        children: List.generate(
          4,
          (index) => Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: index <= _step.index
                    ? GoneColors.primary
                    : GoneColors.gray100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepForm() => switch (_step) {
    _SignupStep.identifier => _identifierForm(),
    _SignupStep.password => _passwordForm(),
    _SignupStep.phone => _phoneForm(),
    // _SignupStep.name => _nameForm(),
    _SignupStep.profile => _profileForm(),
  };

  Widget _identifierForm() => TextField(
    key: const ValueKey('identifier'),
    controller: _fields.identifier,
    autofocus: true,
    decoration: _fieldDecoration(
      label: '아이디',
      hint: '아이디를 입력해주세요',
      error: _errors.identifier,
    ),
  );

  Widget _passwordForm() => Column(
    key: const ValueKey('password'),
    children: [
      TextField(
        controller: _fields.password,
        obscureText: true,
        decoration: _fieldDecoration(
          label: '비밀번호',
          hint: '비밀번호를 입력해주세요',
          error: _errors.password,
        ),
      ),
      const SizedBox(height: 28),
      TextField(
        controller: _fields.confirmation,
        obscureText: true,
        decoration: _fieldDecoration(
          label: '비밀번호 확인',
          hint: '비밀번호를 다시 입력해주세요',
          error: _errors.confirmation,
        ),
      ),
    ],
  );

  Widget _phoneForm() => Column(
    key: const ValueKey('phone'),
    children: [
      TextField(
        controller: _fields.phone,
        keyboardType: TextInputType.phone,
        decoration: _fieldDecoration(
          label: '전화번호',
          hint: '01012341234',
          error: _errors.phone,
          suffixIcon: _sendCodeButton(),
        ),
      ),
      const SizedBox(height: 28),
      TextField(
        controller: _fields.verificationCode,
        keyboardType: TextInputType.number,
        decoration: _fieldDecoration(
          label: '인증번호',
          hint: '인증번호를 입력해주세요',
          error: _errors.verificationCode,
        ),
      ),
    ],
  );

  Widget _sendCodeButton() => UnconstrainedBox(
    child: TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: GoneColors.primary),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: _sendVerificationCode,
      child: Text(
        '인증번호 받기',
        style: TextStyle(color: GoneColors.primary, fontSize: 10),
      ),
    ),
  );

  // Widget _nameForm() => TextField(
  //   key: const ValueKey('name'),
  //   controller: _fields.name,
  //   autofillHints: const [AutofillHints.name],
  //   decoration: _fieldDecoration(label: '이름', hint: '홍길동', error: _errors.name),
  // );

  Widget _profileForm() => Center(
    key: const ValueKey('profile'),
    child: Column(
      children: [
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(84),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: GoneColors.gray100,
                backgroundImage: _profileImage == null
                    ? null
                    : FileImage(File(_profileImage!.path)),
                child: _profileImage == null
                    ? const Icon(Icons.person_rounded, size: 64, color: GoneColors.gray500,)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: GoneColors.primary,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18,),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '사진을 선택하지 않아도 괜찮아요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: GoneColors.textSecondary
          ),
        ),
      ],
    ),
  );

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    String? error,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        color: GoneColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: GoneColors.gray500),
      errorText: error,
      suffixIcon: suffixIcon,
    );
  }
}
