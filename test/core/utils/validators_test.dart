import 'package:cocatrel/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testa a validação de campos de nome', () {
    test(
        'A validação deve retornar uma texto quando for inserido um nome inválido',
        () {
      expect(nameValidator(''), 'Insira seu nome');
      expect(nameValidator('teste'), 'Insira um nome válido');
      expect(nameValidator(' teste'), 'Insira um nome válido');
      expect(nameValidator('teste '), 'Insira um nome válido');
      expect(nameValidator('teste da silv4'), 'Insira um nome válido');
    });

    test(
        'A validação deve retornar uma null quando for inserido um nome válido',
        () {
      expect(nameValidator('teste da silva'), null);
      expect(nameValidator('teste da silva '), null);
      expect(nameValidator(' teste da silva'), null);
      expect(nameValidator(' teste da silva '), null);
    });
  });

  group('Testa a validação de campos de matrícula', () {
    test(
        'A validação deve retornar uma texto quando for inserido uma matrícula inválida',
        () {
      expect(registrationValidator(''), 'Insira uma matrícula');
      expect(registrationValidator('123A'), 'Insira uma matrícula válida');
      expect(registrationValidator('123a'), 'Insira uma matrícula válida');
      expect(registrationValidator('123#'), 'Insira uma matrícula válida');
    });

    test(
        'A validação deve retornar um null quando for inserido uma matrícula válida',
        () {
      expect(registrationValidator('1234'), null);
      expect(registrationValidator('0000'), null);
      expect(registrationValidator('1111'), null);
      expect(registrationValidator('9999'), null);
      expect(registrationValidator('12345678'), null);
    });
  });

  group('Testa a validação de campos de senha', () {
    test(
        'A validação deve retornar uma texto quando for inserido uma senha inválida',
        () {
      expect(passwordValidator(''), 'Insira uma senha');
      expect(passwordValidator('1'),
          'Insira uma senha com pelo menos 3 caracteres');
      expect(passwordValidator('12'),
          'Insira uma senha com pelo menos 3 caracteres');
    });

    test(
        'A validação deve retornar um null quando for inserido uma matrícula válida',
        () {
      expect(passwordValidator('123456'), null);
      expect(passwordValidator('2313@!3'), null);
      expect(passwordValidator('000000'), null);
      expect(passwordValidator('123 '), null);
      expect(passwordValidator('123A'), null);
      expect(passwordValidator('123a'), null);
      expect(passwordValidator('123#'), null);
    });
  });

  group('Testa a validação de campos de nova senha', () {
    test('A validação deve retornar uma texto quando a nova senha for inválida',
        () {
      expect(newPasswordValidator('', '123456'), 'Insira uma senha');
      expect(newPasswordValidator('12', '123456'),
          'Insira uma senha com pelo menos 3 caracteres');
    });

    test(
        'A validação deve retornar uma texto quando a nova senha for igual a nova senha',
        () {
      expect(newPasswordValidator('123456', '123456'),
          'A nova senha não pode ser igual a antiga');
      expect(newPasswordValidator('102030', '102030'),
          'A nova senha não pode ser igual a antiga');
    });

    test(
        'A validação deve retornar um null quando for inserido uma matrícula válida',
        () {
      expect(newPasswordValidator('123456', '102030'), null);
      expect(newPasswordValidator('123456', '123457'), null);
      expect(newPasswordValidator('123321', '123322'), null);
    });
  });

  group('Testa a validação de campos de confirmação de senha', () {
    test(
        'A validação deve retornar um texto quando a confirmação de senha não é igual a nova senha',
        () {
      expect(confirmPasswordValidator('1234567', '0000000'),
          'As senhas não são iguais');
    });

    test(
        'A validação deve retornar null quando a confirmação de senha é igual a nova senha',
        () {
      expect(confirmPasswordValidator('102030', '102030'), null);
    });
  });

  group('Testa as validações de campos de telefone', () {
    test(
      'A validação deve retornar uma String  quando for inserido um telefone inválido',
      () {
        expect(phoneValidator('(86) 99999-000'), 'Insira um telefone válido');
        expect(phoneValidator('(86) 99990000'), 'Insira um telefone válido');
        expect(phoneValidator('999990000'), 'Insira um telefone válido');
      },
    );
    test(
      'A validação deve retornar um null quando for inserido um telefone válido',
      () {
        expect(phoneValidator('(86) 99999-0000'), null);
        expect(phoneValidator('(86)999990000'), null);
        expect(phoneValidator('(86)99999-0000'), null);
      },
    );
  });
}
