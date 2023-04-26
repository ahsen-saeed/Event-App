abstract class ListTypeItem {
  const ListTypeItem();
}

class PaginatedItem extends ListTypeItem {
  bool isShownOnce;

  PaginatedItem({required this.isShownOnce});

  PaginatedItem.initial() : this(isShownOnce: false);
}

class DonePageItem extends ListTypeItem {
  const DonePageItem();
}
