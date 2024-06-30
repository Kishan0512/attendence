
class Drawer_model {
  String sId;
  String companyId;
  String roleId;
  String pageId;
  String name;
  String subname;
  bool isMain;
  bool isSub;
  bool select;
  bool insert;
  bool update;
  bool delate;

  Drawer_model(
      {required this.sId,
        required this.companyId,
        required this.roleId,
        required this.pageId,
        required this.name,
        required this.subname,
        required this.isMain,
        required this.isSub,
        required this.select,
        required this.insert,
        required this.update,
        required this.delate});

  Drawer_model.fromJson(Map<String, dynamic> json) :
        sId = json['_id']?? "",
        companyId = json['companyId']?? "",
        roleId = json['roleId']?? "",
        pageId = json['pageId']?? "",
        name = json['name']?? "",
        subname = json['subname']?? "",
        isMain = json['isMain']?? false,
        isSub = json['isSub']?? false,
        select = json['select']?? false,
        insert = json['insert']?? false,
        update = json['update']?? false,
        delate = json['delate']?? false;

  Map<String, dynamic> toJson(Drawer_model h) {
    return {
      '_id' : h.sId,
      'companyId' : h.companyId,
      'roleId' : h.roleId,
      'pageId' : h.pageId,
      'name' : h.name,
      'subname' : h.subname,
      'isMain' : h.isMain,
      'isSub' : h.isSub,
      'select' : h.select,
      'insert' : h.insert,
      'update' : h.update,
      'delate' : h.delate,
    };
  }
}
