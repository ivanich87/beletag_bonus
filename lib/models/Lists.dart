class UserInfo {
  String login;
  String password;

  //Event({required this.name, required this.location, required this.dt});

  UserInfo({
    required this.login,
    required this.password,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}


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
    actionName = json['actionName'] ?? 'actionName';
    actionComment = json['actionComment'] ?? 'actionComment';
    bonus = json['bonus'] ?? 0;
    dtBegin = DateTime.tryParse(json['dtBegin']) ?? DateTime(2023);
    dtEnd = DateTime.tryParse(json['dtEnd']) ?? DateTime(2023);
  }
}

class ShopsList {
  late int id;
  late String name;
  late String address;
  late int level;
  late String name_tc;
  late int brand_id;
  late String brand_name;
  late String brand_logo;
  late int region_id;
  late String region_name;

  ShopsList(this.id, this.name, this.address, this.level, this.name_tc, this.brand_id, this.brand_name, this.brand_logo, this.region_id, this.region_name);

  ShopsList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? 'name';
    address = json['address'] ?? 'address';
    level = json['level'] ?? 0;
    name_tc = json['name_tc'] ?? 'name_tc';
    brand_id = json['brand_id'] ?? 0;
    brand_name = json['brand_name'] ?? 'brand_name';
    brand_logo = json['brand_logo'] ?? '';
    region_id = json['region_id'] ?? 0;
    region_name = json['region_name'] ?? 'region_name';
  }
}


class AboutList {
  late int id;
  late String name;
  late String txt;

  AboutList(this.id, this.name, this.txt);

  AboutList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? 'name';
    txt = json['txt'] ?? 'txt';
  }
}