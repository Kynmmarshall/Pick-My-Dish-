// In the _login() method, after successful login:

if (response != null && response['user'] != null) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  
  // Use the actual user data from API
  userProvider.setUser(User.fromJson(response['user']));
  
  // Store the user ID
  if (response['user']['id'] != null) {
    userProvider.setUserId(response['user']['id']);
  }

  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }
}
