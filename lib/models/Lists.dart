class PurchaseList {
  late String id;
  late String number;
  late DateTime dt;
  late String shopName;
  late String shopAddress;
  late num summa;

  PurchaseList(this.id, this.number, this.dt, this.shopName, this.shopAddress, this.summa);

  PurchaseList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '0';
    number = json['number'] ?? 'no number';
    dt = DateTime.tryParse(json['dt']) ?? DateTime(2023);
    number = json['number'] ?? 'Пусто';
    shopName = json['shopName'] ?? 'Магазин';
    shopAddress = json['shopAddress'] ?? 'Адрес';
    summa = json['summa'] ?? 0;
  }
}

class ItemTovarList {
  late String name;
  late String subName;
  late int kol;
  late num priceBase;
  late num price;
  late num summa;

  ItemTovarList(this.name, this.subName, this.kol, this.priceBase, this.price, this.summa);

  ItemTovarList.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'Articul';
    subName = json['subName'] ?? '';
    kol = json['kol'] ?? 0;
    priceBase = json['priceBase'] ?? 0;
    price = json['price'] ?? 0;
    summa = json['summa'] ?? 0;
  }
}

class ItemBonusList {
  late String actionName;
  late String actionComment;
  late num bonus;
  late DateTime dtBegin;
  late DateTime dtEnd;

  ItemBonusList(this.actionName, this.actionComment, this.bonus, this.dtBegin, this.dtEnd);

  ItemBonusList.fromJson(Map<String, dynamic> json) {
    actionName = json['actionName'] ?? 'Articul';
    actionComment = json['subName'] ?? '';
    bonus = json['bonus'] ?? 0;
    dtBegin = json['dtBegin'] ?? 0;
    dtEnd = json['dtEnd'] ?? 0;
  }
}