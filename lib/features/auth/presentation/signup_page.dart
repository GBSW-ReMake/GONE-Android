import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/account_role.dart';
import 'auth_widgets.dart';

enum _SignupStep { identifier, password, phone, student, profile }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.role, required this.onBack});

  final AccountRole role;
  final VoidCallback onBack;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  final _phone = TextEditingController();
  final _verificationCode = TextEditingController();
  final _studentNumber = TextEditingController();
  final _name = TextEditingController();
  _SignupStep _step = _SignupStep.identifier;
  String? _error;
  XFile? _profileImage;

  @override
  void dispose() {
    for (final controller in [
      _identifier,
      _password,
      _confirmation,
      _phone,
      _verificationCode,
      _studentNumber,
      _name,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _title => switch (_step) {
    _SignupStep.identifier => '아이디를 입력해주세요',
    _SignupStep.password => '비밀번호를 설정해주세요',
    _SignupStep.phone => '전화번호를 입력해주세요',
    _SignupStep.student => '학번과 이름을 입력해주세요',
    _SignupStep.profile => '프로필 사진을 설정해주세요',
  };

  String get _description => switch (_step) {
    _SignupStep.identifier => 'GONE에서 사용할 아이디를 입력해주세요.',
    _SignupStep.password => '안전한 서비스 이용을 위해 비밀번호를 설정해주세요.',
    _SignupStep.phone => '서비스 이용을 위해 전화번호 인증이 필요해요.',
    _SignupStep.student => '학교 정보를 확인할 수 있도록 입력해주세요.',
    _SignupStep.profile => '사진은 나중에 언제든지 바꿀 수 있어요.',
  };

  void _next() {
    final error = switch (_step) {
      _SignupStep.identifier =>
        _identifier.text.trim().isEmpty ? '아이디를 입력해주세요.' : null,
      _SignupStep.password =>
        _password.text.isEmpty
            ? '비밀번호를 입력해주세요.'
            : (_password.text != _confirmation.text
                  ? '비밀번호가 일치하지 않습니다.'
                  : null),
      _SignupStep.phone =>
        _phone.text.replaceAll(RegExp(r'[^0-9]'), '').length < 10
            ? '전화번호를 입력해주세요.'
            : (_verificationCode.text.trim().isEmpty ? '인증번호를 입력해주세요.' : null),
      _SignupStep.student =>
        _studentNumber.text.trim().isEmpty || _name.text.trim().isEmpty
            ? '학번과 이름을 입력해주세요.'
            : null,
      _SignupStep.profile => null,
    };
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    if (_step == _SignupStep.profile) {
      showServiceNotice(context, '회원가입 서비스 연결 정보를 확인 중입니다. 잠시 후 다시 시도해주세요.');
      return;
    }
    setState(() {
      _error = null;
      _step = _SignupStep.values[_step.index + 1];
    });
  }

  void _back() {
    if (_step == _SignupStep.identifier) {
      widget.onBack();
      return;
    }
    setState(() {
      _error = null;
      _step = _SignupStep.values[_step.index - 1];
    });
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
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: GonePrimaryButton(
          label: _step == _SignupStep.profile ? '시작하기' : '다음',
          onPressed: _next,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GoneBackButton(onPressed: _back, label: '뒤로가기'),
                  const Spacer(),
                  const GoneLogo(width: 88),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 32),
              Semantics(
                label: '회원가입 ${_step.index + 1}단계, 전체 5단계',
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _step.index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 44),
              Text(
                _title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 34),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: _form(context),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) => switch (_step) {
    _SignupStep.identifier => TextField(
      key: const ValueKey('identifier'),
      controller: _identifier,
      autofocus: true,
      decoration: const InputDecoration(
        labelText: '아이디',
        hintText: '아이디를 입력해주세요',
      ),
    ),
    _SignupStep.password => Column(
      key: const ValueKey('password'),
      children: [
        TextField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '비밀번호',
            hintText: '비밀번호를 입력해주세요',
          ),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _confirmation,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '비밀번호 확인',
            hintText: '비밀번호를 다시 입력해주세요',
          ),
        ),
      ],
    ),
    _SignupStep.phone => Column(
      key: const ValueKey('phone'),
      children: [
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: '전화번호',
            hintText: '010-0000-0000',
            suffixIcon: TextButton(
              onPressed: () =>
                  showServiceNotice(context, '인증번호 발송 API 연결 정보를 확인 중입니다.'),
              child: const Text('인증번호 받기'),
            ),
          ),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _verificationCode,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '인증번호',
            hintText: '인증번호를 입력해주세요',
          ),
        ),
      ],
    ),
    _SignupStep.student => Column(
      key: const ValueKey('student'),
      children: [
        TextField(
          controller: _studentNumber,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '학번', hintText: '1101'),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _name,
          autofillHints: const [AutofillHints.name],
          decoration: const InputDecoration(labelText: '이름', hintText: '홍길동'),
        ),
      ],
    ),
    _SignupStep.profile => Center(
      key: const ValueKey('profile'),
      child: Column(
        children: [
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(84),
            child: CircleAvatar(
              radius: 70,
              backgroundImage: _profileImage == null
                  ? null
                  : FileImage(File(_profileImage!.path)),
              child: _profileImage == null
                  ? const Icon(Icons.person_rounded, size: 64)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('프로필 사진 선택'),
          ),
          Text(
            '사진을 선택하지 않아도 괜찮아요',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  };
}
