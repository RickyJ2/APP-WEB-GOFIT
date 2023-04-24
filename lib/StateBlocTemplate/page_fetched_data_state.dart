abstract class PageFetchedDataState {
  const PageFetchedDataState();
}

class InitialPageFetchedDataState extends PageFetchedDataState {
  const InitialPageFetchedDataState();
}

class PageFetchedDataLoading extends PageFetchedDataState {}

class PageFetchedDataSuccess extends PageFetchedDataState {
  final List<Object> pages;

  const PageFetchedDataSuccess(this.pages);
}

class PageFetchedDataFailed extends PageFetchedDataState {
  final String exception;

  const PageFetchedDataFailed(this.exception);
}
