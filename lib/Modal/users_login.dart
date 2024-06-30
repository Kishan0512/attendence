class login_user {
  bool status;
  String message;
  String token;
  Data data;

  login_user(
      {required this.status, required this.message, required this.token, required this.data});

  login_user.fromJson(Map<String, dynamic> json)
      :
        status = json['status'] ?? true,
        message = json['message'] ?? "",
        token = json['token'] ?? "",
        data = Data.fromJson(json['data']);


  Map<String, dynamic> toJson(login_user h) {
  return {
    'status' : h.status,
  'message' : h.message,
  'token' : h.token,
  'data' : Data.toJson(h.data)
  };
  }
}

class Data {
  String sId;
  String name;
  String email;
  String password;
  int phone;
  bool isActive;
  int otp;
  String createdAt;
  String updatedAt;
  String employeeCount;
  String companyId;
  String roleId;
  String faceID;
  String image;
  String employeeId;
  String roleName;

  Data({
    required this.sId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.isActive,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
    required this.employeeCount,
    required this.companyId,
    required this.roleId,
    required this.image,
    required this.faceID,
    required this.employeeId,
    required this.roleName
  });

  Data.fromJson(Map<String, dynamic> json)
      :
        sId = json['_id'] ?? "",
        name = json['name'] ?? "",
        email = json['email'] ?? "",
        password = json['password'] ?? "",
        phone = json['phone'] ?? "",
        isActive = json['isActive'] ?? "",
        otp = json['otp'] ?? 0,
        createdAt = json['createdAt'] ?? "",
        image = json['image'] ?? "",
        updatedAt = json['updatedAt'] ?? "",
        employeeCount = json['employeeCount'] ?? "",
        companyId = json['company_id'] ?? "",
        roleId = json['roleId'] ?? "",
        faceID = json['faceId'] ?? "",
  employeeId = json['employeeId'] ?? "",
  roleName = json['roleName'] ?? "";


 static Map<String, dynamic> toJson(Data h) {
    return {
      '_id': h.sId,
      'name': h.name,
      'email': h.email,
      'password': h.password,
      'phone': h.phone,
      'isActive': h.isActive,
      'otp': h.otp,
      'createdAt': h.createdAt,
      'updatedAt': h.updatedAt,
      'employeeCount': h.employeeCount,
      'image': h.image,
      'company_id': h.companyId,
      'roleId': h.roleId,
      'faceId': h.faceID,
      'employeeId': h.employeeId,
      'roleName': h.roleName,
    };
  }
}
