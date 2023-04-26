enum PageIndexerState { initial, ended, paginated }

class PageIndexer {
  int index;
  PageIndexerState indexerState;

  PageIndexer({required this.index, required this.indexerState});

  PageIndexer.initial() : this(index: 1, indexerState: PageIndexerState.initial);

  void inc() => index += 1;

  @override
  String toString() {
    return 'PageIndexer{index: $index, indexerState: $indexerState}';
  }
}
