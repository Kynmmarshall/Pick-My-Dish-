// Import Flutter material design library
import 'package:flutter/material.dart';

/// Global flag used to toggle password visibility
/// (e.g., show/hide password in a TextField)
bool isPasswordVisible = false;

/// Default size for icons used across the application
const double iconSize = 40;

/// Text style for main titles (e.g., app name, main headings)
const title = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 37,
);

/// Text style for medium-sized titles
/// (e.g., section headings, card titles)
const mediumtitle = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 23,
);

/// Text style for footer text
/// (e.g., bottom navigation text or labels)
const footer = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 22,
);

/// Text style for clickable footer elements
/// (e.g., links such as “Sign up” or “Forgot password”)
const footerClickable = TextStyle(
  color: Colors.orange,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 22,
);

/// General-purpose text style for body text
/// (e.g., descriptions, instructions)
const text = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

/// Text style for displaying calorie information
/// (e.g., recipe calorie count)
const caloriesText = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.white,
  fontSize: 14,
);

/// Text style for recipe categories
/// Uses orange color to visually highlight categories
const categoryText = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.orange,
  fontSize: 16,
);

/// Text style for placeholder text inside input fields
/// Uses semi-transparent white color for subtle appearance
const placeHolder = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Color.fromARGB(193, 255, 255, 255),
  fontSize: 20,
);


