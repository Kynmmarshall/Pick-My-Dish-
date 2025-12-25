// In the _buildSideMenu() method, update the logout section:

// Find the logout menu item and update it to:
_buildMenuItem(Icons.logout, "Logout", () {
  _confirmLogout();
}),

// Add these methods to the _HomeScreenState class:

void _confirmLogout() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Logout', style: title),
      content: Text('Are you sure you want to logout?', style: text),
      backgroundColor: Colors.black,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: text.copyWith(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            _logout(); // Perform logout
          },
          child: Text('Logout', style: text.copyWith(color: Colors.red)),
        ),
      ],
    ),
  );
}

void _logout() async {
  // 1. Clear all user data from provider
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
  
  // Clear API token
  ApiService.clearAuthToken();
  
  // Clear providers
  userProvider.logout();
  recipeProvider.logout();
  
  // 2. Navigate to login (clear navigation stack)
  if (mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }
}
