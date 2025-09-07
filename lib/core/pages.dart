enum PAGE {
  splash(path: '/splash', name: 'Splash'),
  login(path: '/login', name: 'Login'),
  bottomNav(path: '/bottomNav', name: 'BottomNav'),
  callScreen( path: '/callScreen',name: 'callScreen',), 
  signup(path: '/signup', name: 'Signup');

  final String path;
  final String name;
  const PAGE({required this.path, required this.name});
}
