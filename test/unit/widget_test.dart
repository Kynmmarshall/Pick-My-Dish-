import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pick_my_dish/main.dart';
import 'package:pick_my_dish/Screens/splash_screen.dart';
import 'package:pick_my_dish/Screens/home_screen.dart';
import 'package:pick_my_dish/Screens/login_screen.dart';
import 'package:pick_my_dish/Screens/register_screen.dart';
import 'package:pick_my_dish/Screens/recipe_screen.dart';
import 'package:pick_my_dish/Screens/favorite_screen.dart';
import 'package:pick_my_dish/Screens/profile_screen.dart';
import 'package:pick_my_dish/constants.dart';

void main() {
  group('Screen Rendering Tests - Basic', () {
    testWidgets('App builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const PickMyDish());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('SplashScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('HomeScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('LoginScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pump();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('RegisterScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pump();
      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('RecipeScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pump();
      expect(find.byType(RecipesScreen), findsOneWidget);
    });

    testWidgets('FavoriteScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FavoritesScreen()));
      await tester.pump();
      expect(find.byType(FavoritesScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pump();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });

  group('Key UI Elements Tests', () {
    testWidgets('HomeScreen shows welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsAtLeast(1));
    });

    testWidgets('LoginScreen shows app title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text('PICK MY DISH'), findsAtLeast(1));
    });

    testWidgets('RegisterScreen shows register title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsAtLeast(1));
    });

    testWidgets('RecipeScreen shows all recipes title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pumpAndSettle();
      expect(find.text('All Recipes'), findsAtLeast(1));
    });

    testWidgets('FavoriteScreen shows favorite recipes title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FavoritesScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Favorite Recipes'), findsAtLeast(1));
    });
  });

  group('Form Elements Tests', () {
    testWidgets('LoginScreen has email field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      final emailFields = find.byWidgetPredicate((widget) {
        if (widget is TextField) {
          final hint = widget.decoration?.hintText ?? '';
          return hint.toLowerCase().contains('email') || hint.toLowerCase().contains('e-mail');
        }
        return false;
      });

      expect(emailFields, findsAtLeast(1));
    });

    testWidgets('LoginScreen has password field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      final passwordFields = find.byWidgetPredicate((widget) {
        if (widget is TextField) {
          final hint = widget.decoration?.hintText ?? '';
          return widget.obscureText == true || hint.toLowerCase().contains('password');
        }
        return false;
      });

      expect(passwordFields, findsAtLeast(1));
    });

    testWidgets('RegisterScreen has multiple text fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsAtLeast(3));
    });

    testWidgets('ProfileScreen has username field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsAtLeast(1));
    });
  });

  group('Button Tests', () {
    testWidgets('LoginScreen has login button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsAtLeast(1));
    });

    testWidgets('RegisterScreen has register button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsAtLeast(1));
    });

    testWidgets('ProfileScreen has confirm button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsAtLeast(1));
    });
  });

  group('Icon Tests', () {
    testWidgets('RecipeScreen has favorite icons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsAtLeast(1));
      expect(find.byIcon(Icons.favorite_border), findsAtLeast(1));
    });

    testWidgets('Screens have back buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsAtLeast(1));
    });
  });

  group('Layout Tests', () {
    testWidgets('HomeScreen has personalization section', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Personalize Your Recipes'), findsAtLeast(1));
    });

    testWidgets('RecipeScreen has search field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search), findsAtLeast(1));
    });

    testWidgets('HomeScreen shows recipe section', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text("Today's Fresh Recipe"), findsAtLeast(1));
    });
  });

  group('Input Tests', () {
    testWidgets('Can type in login email field', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'test@example.com');
        await tester.pumpAndSettle();
        expect(find.text('test@example.com'), findsAtLeast(1));
      }
    });

    testWidgets('Can type in recipe search', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RecipesScreen()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'pizza');
        await tester.pumpAndSettle();
        expect(find.text('pizza'), findsAtLeast(1));
      }
    });
  });

  group('Constants Test', () {
    test('Text styles are defined', () {
      expect(title, isA<TextStyle>());
      expect(text, isA<TextStyle>());
      expect(mediumtitle, isA<TextStyle>());
    });

    test('Global variables exist', () {
      expect(isPasswordVisible, isA<bool>());
    });
  });
}