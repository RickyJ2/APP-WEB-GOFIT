abstract class AppEvent {
  const AppEvent();
}

class AppOpened extends AppEvent {
  const AppOpened();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppLogined extends AppEvent {
  const AppLogined();
}

class ChangedSelectedIndex extends AppEvent {
  const ChangedSelectedIndex({required this.selectedIndex});

  final int selectedIndex;
}
