
class RegistrationResponseModel {
  RegistrationResponseModel({
    String? remark,
    String? status,
    Message? message,
    Data? data}){

    _remark = remark;
    _status = status;
    _message = message;
    _data = data;

  }

  RegistrationResponseModel.fromJson(dynamic json) {
    _remark  = json['remark'];
    _status  = json['status'].toString();
    _message = json['message'] != null ? Message.fromJson(json['message']): null;
    _data    = json['data'] != null ? Data.fromJson(json['data'])      : null;
  }

  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String?  get remark => _remark;
  String?  get status => _status;
  Message? get message => _message;
  Data?    get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
    String? accessToken,
    User? user,
    String? tokenType}){

    _accessToken = accessToken;
    _user = user;
    _tokenType = tokenType;

  }

  Data.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _user        = json['user'] != null ? User.fromJson(json['user']) : null;
    _tokenType   = json['token_type'];
  }

  String? _accessToken;
  User? _user;
  String? _tokenType;

  String? get accessToken => _accessToken;
  User?   get user => _user;
  String? get tokenType => _tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['token_type'] = _tokenType;
    return map;
  }

}

class User {
  User({
    String? email,
    String? username,
    String? countryCode,
    String? mobile,
    Address? address,
    String?status,
    String? ev,
    String? sv,
    String? kv,
    String? updatedAt,
    String? createdAt,
    int? id}){

    _email = email;
    _username = username;
    _countryCode = countryCode;
    _mobile = mobile;
    _address = address;
    _status = status;
    _ev = ev;
    _sv = sv;
    _kv = kv;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;

  }

  User.fromJson(dynamic json) {

    _email       = json['email'];
    _username    = json['username'];
    _countryCode = json['country_code'].toString();
    _mobile      = json['mobile'].toString();
    _address     = json['address'] == null ? Address.fromJson(json['address']): null;
    _status      = json['status'].toString();
    _ev          = json['ev'].toString();
    _sv          = json['sv'].toString();
    _kv          = json['kv'].toString();
    _updatedAt   = json['updated_at'];
    _createdAt   = json['created_at'];
    _id          = json['id'];

  }

  String? _email;
  String? _username;
  String? _countryCode;
  String? _mobile;
  Address? _address;
  String?   _status;
  String? _ev;
  String? _sv;
  String? _kv;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  String?  get email => _email;
  String?  get username => _username;
  String?  get countryCode => _countryCode;
  String?  get mobile => _mobile;
  Address? get address => _address;
  String?  get status => _status;
  String?  get ev => _ev;
  String?  get sv => _sv;
  String?  get kv => _kv;
  String?  get updatedAt => _updatedAt;
  String?  get createdAt => _createdAt;
  int?     get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['username'] = _username;
    map['country_code'] = _countryCode;
    map['mobile'] = _mobile;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    map['status'] = _status;
    map['ev'] = _ev;
    map['sv'] = _sv;
    map['kv'] = _kv;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}

class Address {
  Address({
    String? address,
    String? state,
    String? zip,
    String? country,
    String? city}){

    _address = address;
    _state = state;
    _zip = zip;
    _country = country;
    _city = city;

  }

  Address.fromJson(dynamic json) {
    _address = json['address'];
    _state = json['state'];
    _zip = json['zip'].toString();
    _country = json['country'];
    _city = json['city'];
  }

  String? _address;
  String? _state;
  String? _zip;
  String? _country;
  String? _city;

  String? get address => _address;
  String? get state => _state;
  String? get zip => _zip;
  String? get country => _country;
  String? get city => _city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['state']   = _state;
    map['zip']     = _zip;
    map['country'] = _country;
    map['city']    = _city;
    return map;
  }

}

class Message {
  Message({
    List<String>? success,
    List<String>? error
  }){
    _success = success;
    _error = error;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ? [json['success'].toString()] : null;
    _error   = json['error']   != null ? [json['error'].toString()]  : null;
  }

  List<String>? _success;
  List<String>? _error;

  List<String>? get success => _success;
  List<String>? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['error'] = _error;
    return map;
  }

}