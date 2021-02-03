import 'package:firebaseUnitTests/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements FirebaseAuth {}

void main() {
  final MockAuth mockFirebaseAuth = MockAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() {});
  tearDown(() {});

  test('create account', () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(email: "michał12@mail.com", password: "123456789"))
        .thenAnswer((realInvocation) => null);

    expect(await auth.createAccount(email: "michał12@mail.com", password: "123456789"), "Succes");
  });

  test("create account error", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(email: "michał12@mail.com", password: "123456789"))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(message: "Something went wrong", code: "500"));

    expect(await auth.createAccount(email: "michał12@mail.com", password: "123456789"), "Something went wrong");
  });

  test('login user', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(email: "tomek@mail.com", password: "123456789"))
        .thenAnswer((realInvocation) => null);
    expect(await auth.login(email: "tomek@mail.com", password: "123456789"), "Sucess");
  });

  test('login user error', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(email: "tomek@mail.com", password: "123456789"))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(message: "Something went wrong", code: "500"));

    expect(await auth.login(email: "tomek@mail.com", password: "123456789"), "Something went wrong");
  });

  test('logout', () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Sucess");
  });
}
