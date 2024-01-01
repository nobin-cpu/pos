import '../auth/sign_up_model/registration_response_model.dart';

class GeneralSettingResponseModel {
  GeneralSettingResponseModel({
      String? remark, 
      String? status, 
      Message? message, 
      Data? data}){

    _remark = remark;
    _status = status;
    _message = message;
    _data = data;

}

  GeneralSettingResponseModel.fromJson(dynamic json) {
    _remark = json['remark'].toString();
    _status = json['status'].toString();
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

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
      GeneralSetting? generalSetting,}){
    _generalSetting = generalSetting;
}

  Data.fromJson(dynamic json) {
    _generalSetting = json['general_setting'] != null ? GeneralSetting.fromJson(json['general_setting']) : null;
  }
  GeneralSetting? _generalSetting;

  GeneralSetting? get generalSetting => _generalSetting;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_generalSetting != null) {
      map['general_setting'] = _generalSetting?.toJson();
    }
    return map;
  }

}

class GeneralSetting {
  GeneralSetting({
      int? id, 
      String? siteName, 
      String? otpVerification, 
      String? otpExpiration, 
      String? curText, 
      String? curSym, 
      String? emailFrom, 
      String? qrCodeTemplate, 
      String? emailTemplate, 
      String? smsBody, 
      String? firebaseTemplate, 
      String? smsFrom, 
      String? baseColor, 
      MailConfig? mailConfig, 
      SmsConfig? smsConfig, 
      FirebaseConfig? firebaseConfig, 
      GlobalShortcodes? globalShortcodes, 
      String? fiatCurrencyApi, 
      String? cryptoCurrencyApi, 
      CronRun? cronRun, 
      String? kv, 
      String? ev, 
      String? en, 
      String? sv, 
      String? sn, 
      String? pn, 
      String? detectActivity, 
      String? enableLanguage, 
      String? forceSsl, 
      String? maintenanceMode, 
      String? securePassword, 
      String? agree, 
      String? multiLanguage, 
      String? registration, 
      String? activeTemplate, 
      String? systemInfo, 
      dynamic createdAt,
      String? updatedAt}){

    _id = id;
    _siteName = siteName;
    _otpVerification = otpVerification;
    _otpExpiration = otpExpiration;
    _curText = curText;
    _curSym = curSym;
    _emailFrom = emailFrom;
    _qrCodeTemplate = qrCodeTemplate;
    _emailTemplate = emailTemplate;
    _smsBody = smsBody;
    _firebaseTemplate = firebaseTemplate;
    _smsFrom = smsFrom;
    _baseColor = baseColor;
    _mailConfig = mailConfig;
    _smsConfig = smsConfig;
    _firebaseConfig = firebaseConfig;
    _globalShortcodes = globalShortcodes;
    _fiatCurrencyApi = fiatCurrencyApi;
    _cryptoCurrencyApi = cryptoCurrencyApi;
    _cronRun = cronRun;
    _kv = kv;
    _ev = ev;
    _en = en;
    _sv = sv;
    _sn = sn;
    _pn = pn;
    _detectActivity = detectActivity;
    _enableLanguage = enableLanguage;
    _forceSsl = forceSsl;
    _maintenanceMode = maintenanceMode;
    _securePassword = securePassword;
    _agree = agree;
    _multiLanguage = multiLanguage;
    _registration = registration;
    _activeTemplate = activeTemplate;
    _systemInfo = systemInfo;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  GeneralSetting.fromJson(dynamic json) {
    _id = json['id'];
    _siteName = json['site_name'];
    _otpVerification = json['otp_verification'].toString();
    _otpExpiration = json['otp_expiration'].toString();
    _curText = json['cur_text'];
    _curSym = json['cur_sym'];
    _emailFrom = json['email_from'];
    _qrCodeTemplate = json['qr_code_template'];
    _emailTemplate = json['email_template'];
    _smsBody = json['sms_body'];
    _firebaseTemplate = json['firebase_template'];
    _smsFrom = json['sms_from'];
    _baseColor = json['base_color'];
    _mailConfig = json['mail_config'] != null ? MailConfig.fromJson(json['mail_config']) : null;
    _smsConfig = json['sms_config'] != null ? SmsConfig.fromJson(json['sms_config']) : null;
    _firebaseConfig = json['firebase_config'] != null ? FirebaseConfig.fromJson(json['firebase_config']) : null;
    _globalShortcodes = json['global_shortcodes'] != null ? GlobalShortcodes.fromJson(json['global_shortcodes']) : null;
    _fiatCurrencyApi = json['fiat_currency_api'];
    _cryptoCurrencyApi = json['crypto_currency_api'];
    _cronRun = json['cron_run'] != null ? CronRun.fromJson(json['cron_run']) : null;
    _kv = json['kv'].toString();
    _ev = json['ev'].toString();
    _en = json['en'].toString();
    _sv = json['sv'].toString();
    _sn = json['sn'].toString();
    _pn = json['pn'].toString();
    _detectActivity = json['detect_activity'].toString();
    _enableLanguage = json['enable_language'].toString();
    _forceSsl = json['force_ssl'].toString();
    _maintenanceMode = json['maintenance_mode'].toString();
    _securePassword = json['secure_password'].toString();
    _agree = json['agree'].toString();
    _multiLanguage = json['multi_language'].toString();
    _registration = json['registration'].toString();
    _activeTemplate = json['active_template'];
    _systemInfo = json['system_info'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  String? _siteName;
  String? _otpVerification;
  String? _otpExpiration;
  String? _curText;
  String? _curSym;
  String? _emailFrom;
  String? _qrCodeTemplate;
  String? _emailTemplate;
  String? _smsBody;
  String? _firebaseTemplate;
  String? _smsFrom;
  String? _baseColor;
  MailConfig? _mailConfig;
  SmsConfig? _smsConfig;
  FirebaseConfig? _firebaseConfig;
  GlobalShortcodes? _globalShortcodes;
  String? _fiatCurrencyApi;
  String? _cryptoCurrencyApi;
  CronRun? _cronRun;
  String? _kv;
  String? _ev;
  String? _en;
  String? _sv;
  String? _sn;
  String? _pn;
  String? _detectActivity;
  String? _enableLanguage;
  String? _forceSsl;
  String? _maintenanceMode;
  String? _securePassword;
  String? _agree;
  String? _multiLanguage;
  String? _registration;
  String? _activeTemplate;
  String? _systemInfo;
  dynamic _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get siteName => _siteName;
  String? get otpVerification => _otpVerification;
  String? get otpExpiration => _otpExpiration;
  String? get curText => _curText;
  String? get curSym => _curSym;
  String? get emailFrom => _emailFrom;
  String? get qrCodeTemplate => _qrCodeTemplate;
  String? get emailTemplate => _emailTemplate;
  String? get smsBody => _smsBody;
  String? get firebaseTemplate => _firebaseTemplate;
  String? get smsFrom => _smsFrom;
  String? get baseColor => _baseColor;
  MailConfig? get mailConfig => _mailConfig;
  SmsConfig? get smsConfig => _smsConfig;
  FirebaseConfig? get firebaseConfig => _firebaseConfig;
  GlobalShortcodes? get globalShortcodes => _globalShortcodes;
  String? get fiatCurrencyApi => _fiatCurrencyApi;
  String? get cryptoCurrencyApi => _cryptoCurrencyApi;
  CronRun? get cronRun => _cronRun;
  String? get kv => _kv;
  String? get ev => _ev;
  String? get en => _en;
  String? get sv => _sv;
  String? get sn => _sn;
  String? get pn => _pn;
  String? get detectActivity => _detectActivity;
  String? get enableLanguage => _enableLanguage;
  String? get forceSsl => _forceSsl;
  String? get maintenanceMode => _maintenanceMode;
  String? get securePassword => _securePassword;
  String? get agree => _agree;
  String? get multiLanguage => _multiLanguage;
  String? get registration => _registration;
  String? get activeTemplate => _activeTemplate;
  String? get systemInfo => _systemInfo;
  dynamic get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['site_name'] = _siteName;
    map['otp_verification'] = _otpVerification;
    map['otp_expiration'] = _otpExpiration;
    map['cur_text'] = _curText;
    map['cur_sym'] = _curSym;
    map['email_from'] = _emailFrom;
    map['qr_code_template'] = _qrCodeTemplate;
    map['email_template'] = _emailTemplate;
    map['sms_body'] = _smsBody;
    map['firebase_template'] = _firebaseTemplate;
    map['sms_from'] = _smsFrom;
    map['base_color'] = _baseColor;
    if (_mailConfig != null) {
      map['mail_config'] = _mailConfig?.toJson();
    }
    if (_smsConfig != null) {
      map['sms_config'] = _smsConfig?.toJson();
    }
    if (_firebaseConfig != null) {
      map['firebase_config'] = _firebaseConfig?.toJson();
    }
    if (_globalShortcodes != null) {
      map['global_shortcodes'] = _globalShortcodes?.toJson();
    }
    map['fiat_currency_api'] = _fiatCurrencyApi;
    map['crypto_currency_api'] = _cryptoCurrencyApi;
    if (_cronRun != null) {
      map['cron_run'] = _cronRun?.toJson();
    }
    map['kv'] = _kv;
    map['ev'] = _ev;
    map['en'] = _en;
    map['sv'] = _sv;
    map['sn'] = _sn;
    map['pn'] = _pn;
    map['detect_activity'] = _detectActivity;
    map['enable_language'] = _enableLanguage;
    map['force_ssl'] = _forceSsl;
    map['maintenance_mode'] = _maintenanceMode;
    map['secure_password'] = _securePassword;
    map['agree'] = _agree;
    map['multi_language'] = _multiLanguage;
    map['registration'] = _registration;
    map['active_template'] = _activeTemplate;
    map['system_info'] = _systemInfo;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

class CronRun {
  CronRun({
      String? fiatCron, 
      String? cryptoCron,}){
    _fiatCron = fiatCron;
    _cryptoCron = cryptoCron;
}

  CronRun.fromJson(dynamic json) {
    _fiatCron = json['fiat_cron'];
    _cryptoCron = json['crypto_cron'];
  }
  String? _fiatCron;
  String? _cryptoCron;

  String? get fiatCron => _fiatCron;
  String? get cryptoCron => _cryptoCron;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fiat_cron'] = _fiatCron;
    map['crypto_cron'] = _cryptoCron;
    return map;
  }

}

class GlobalShortcodes {
  GlobalShortcodes({
      String? siteName, 
      String? siteCurrency, 
      String? currencySymbol,}){
    _siteName = siteName;
    _siteCurrency = siteCurrency;
    _currencySymbol = currencySymbol;
}

  GlobalShortcodes.fromJson(dynamic json) {
    _siteName = json['site_name'];
    _siteCurrency = json['site_currency'];
    _currencySymbol = json['currency_symbol'];
  }
  String? _siteName;
  String? _siteCurrency;
  String? _currencySymbol;

  String? get siteName => _siteName;
  String? get siteCurrency => _siteCurrency;
  String? get currencySymbol => _currencySymbol;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['site_name'] = _siteName;
    map['site_currency'] = _siteCurrency;
    map['currency_symbol'] = _currencySymbol;
    return map;
  }

}

class FirebaseConfig {
  FirebaseConfig({
      String? apiKey, 
      String? authDomain, 
      String? projectId, 
      String? storageBucket, 
      String? messagingSenderId, 
      String? appId, 
      String? measurementId, 
      String? serverKey,}){
    _apiKey = apiKey;
    _authDomain = authDomain;
    _projectId = projectId;
    _storageBucket = storageBucket;
    _messagingSenderId = messagingSenderId;
    _appId = appId;
    _measurementId = measurementId;
    _serverKey = serverKey;
}

  FirebaseConfig.fromJson(dynamic json) {
    _apiKey = json['apiKey'];
    _authDomain = json['authDomain'];
    _projectId = json['projectId'];
    _storageBucket = json['storageBucket'];
    _messagingSenderId = json['messagingSenderId'];
    _appId = json['appId'];
    _measurementId = json['measurementId'];
    _serverKey = json['serverKey'];
  }
  String? _apiKey;
  String? _authDomain;
  String? _projectId;
  String? _storageBucket;
  String? _messagingSenderId;
  String? _appId;
  String? _measurementId;
  String? _serverKey;

  String? get apiKey => _apiKey;
  String? get authDomain => _authDomain;
  String? get projectId => _projectId;
  String? get storageBucket => _storageBucket;
  String? get messagingSenderId => _messagingSenderId;
  String? get appId => _appId;
  String? get measurementId => _measurementId;
  String? get serverKey => _serverKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['apiKey'] = _apiKey;
    map['authDomain'] = _authDomain;
    map['projectId'] = _projectId;
    map['storageBucket'] = _storageBucket;
    map['messagingSenderId'] = _messagingSenderId;
    map['appId'] = _appId;
    map['measurementId'] = _measurementId;
    map['serverKey'] = _serverKey;
    return map;
  }

}

class SmsConfig {
  SmsConfig({
      String? name, 
      Clickatell? clickatell, 
      Infobip? infobip, 
      MessageBird? messageBird, 
      Nexmo? nexmo, 
      SmsBroadcast? smsBroadcast, 
      Twilio? twilio, 
      TextMagic? textMagic, 
      Custom? custom,}){
    _name = name;
    _clickatell = clickatell;
    _infobip = infobip;
    _messageBird = messageBird;
    _nexmo = nexmo;
    _smsBroadcast = smsBroadcast;
    _twilio = twilio;
    _textMagic = textMagic;
    _custom = custom;
}

  SmsConfig.fromJson(dynamic json) {
    _name = json['name'];
    _clickatell = json['clickatell'] != null ? Clickatell.fromJson(json['clickatell']) : null;
    _infobip = json['infobip'] != null ? Infobip.fromJson(json['infobip']) : null;
    _messageBird = json['message_bird'] != null ? MessageBird.fromJson(json['message_bird']) : null;
    _nexmo = json['nexmo'] != null ? Nexmo.fromJson(json['nexmo']) : null;
    _smsBroadcast = json['sms_broadcast'] != null ? SmsBroadcast.fromJson(json['sms_broadcast']) : null;
    _twilio = json['twilio'] != null ? Twilio.fromJson(json['twilio']) : null;
    _textMagic = json['text_magic'] != null ? TextMagic.fromJson(json['text_magic']) : null;
    _custom = json['custom'] != null ? Custom.fromJson(json['custom']) : null;
  }
  String? _name;
  Clickatell? _clickatell;
  Infobip? _infobip;
  MessageBird? _messageBird;
  Nexmo? _nexmo;
  SmsBroadcast? _smsBroadcast;
  Twilio? _twilio;
  TextMagic? _textMagic;
  Custom? _custom;

  String? get name => _name;
  Clickatell? get clickatell => _clickatell;
  Infobip? get infobip => _infobip;
  MessageBird? get messageBird => _messageBird;
  Nexmo? get nexmo => _nexmo;
  SmsBroadcast? get smsBroadcast => _smsBroadcast;
  Twilio? get twilio => _twilio;
  TextMagic? get textMagic => _textMagic;
  Custom? get custom => _custom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_clickatell != null) {
      map['clickatell'] = _clickatell?.toJson();
    }
    if (_infobip != null) {
      map['infobip'] = _infobip?.toJson();
    }
    if (_messageBird != null) {
      map['message_bird'] = _messageBird?.toJson();
    }
    if (_nexmo != null) {
      map['nexmo'] = _nexmo?.toJson();
    }
    if (_smsBroadcast != null) {
      map['sms_broadcast'] = _smsBroadcast?.toJson();
    }
    if (_twilio != null) {
      map['twilio'] = _twilio?.toJson();
    }
    if (_textMagic != null) {
      map['text_magic'] = _textMagic?.toJson();
    }
    if (_custom != null) {
      map['custom'] = _custom?.toJson();
    }
    return map;
  }

}

class Custom {
  Custom({
      String? method, 
      String? url, 
      Headers? headers, 
      Body? body,}){
    _method = method;
    _url = url;
    _headers = headers;
    _body = body;
}

  Custom.fromJson(dynamic json) {
    _method = json['method'];
    _url = json['url'];
    _headers = json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    _body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }
  String? _method;
  String? _url;
  Headers? _headers;
  Body? _body;

  String? get method => _method;
  String? get url => _url;
  Headers? get headers => _headers;
  Body? get body => _body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method'] = _method;
    map['url'] = _url;
    if (_headers != null) {
      map['headers'] = _headers?.toJson();
    }
    if (_body != null) {
      map['body'] = _body?.toJson();
    }
    return map;
  }

}

class Body {
  Body({
      List<String>? name, 
      List<String>? value,}){
    _name = name;
    _value = value;
}

  Body.fromJson(dynamic json) {
    _name = json['name'] != null ? json['name'].cast<String>() : [];
    _value = json['value'] != null ? json['value'].cast<String>() : [];
  }
  List<String>? _name;
  List<String>? _value;

  List<String>? get name => _name;
  List<String>? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['value'] = _value;
    return map;
  }

}

class Headers {
  Headers({
      List<String>? name, 
      List<String>? value,}){
    _name = name;
    _value = value;
}

  Headers.fromJson(dynamic json) {
    _name = json['name'] != null ? json['name'].cast<String>() : [];
    _value = json['value'] != null ? json['value'].cast<String>() : [];
  }
  List<String>? _name;
  List<String>? _value;

  List<String>? get name => _name;
  List<String>? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['value'] = _value;
    return map;
  }

}

class TextMagic {
  TextMagic({
      String? username, 
      String? apiv2Key,}){
    _username = username;
    _apiv2Key = apiv2Key;
}

  TextMagic.fromJson(dynamic json) {
    _username = json['username'];
    _apiv2Key = json['apiv2_key'];
  }
  String? _username;
  String? _apiv2Key;

  String? get username => _username;
  String? get apiv2Key => _apiv2Key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['apiv2_key'] = _apiv2Key;
    return map;
  }

}

class Twilio {
  Twilio({
      String? accountSid, 
      String? authToken, 
      String? from,}){
    _accountSid = accountSid;
    _authToken = authToken;
    _from = from;
}

  Twilio.fromJson(dynamic json) {
    _accountSid = json['account_sid'];
    _authToken = json['auth_token'];
    _from = json['from'];
  }
  String? _accountSid;
  String? _authToken;
  String? _from;

  String? get accountSid => _accountSid;
  String? get authToken => _authToken;
  String? get from => _from;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['account_sid'] = _accountSid;
    map['auth_token'] = _authToken;
    map['from'] = _from;
    return map;
  }

}

class SmsBroadcast {
  SmsBroadcast({
      String? username, 
      String? password,}){
    _username = username;
    _password = password;
}

  SmsBroadcast.fromJson(dynamic json) {
    _username = json['username'];
    _password = json['password'];
  }
  String? _username;
  String? _password;

  String? get username => _username;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

}

class Nexmo {
  Nexmo({
      String? apiKey, 
      String? apiSecret,}){
    _apiKey = apiKey;
    _apiSecret = apiSecret;
}

  Nexmo.fromJson(dynamic json) {
    _apiKey = json['api_key'];
    _apiSecret = json['api_secret'];
  }
  String? _apiKey;
  String? _apiSecret;

  String? get apiKey => _apiKey;
  String? get apiSecret => _apiSecret;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key'] = _apiKey;
    map['api_secret'] = _apiSecret;
    return map;
  }

}

class MessageBird {
  MessageBird({
      String? apiKey,}){
    _apiKey = apiKey;
}

  MessageBird.fromJson(dynamic json) {
    _apiKey = json['api_key'];
  }
  String? _apiKey;

  String? get apiKey => _apiKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key'] = _apiKey;
    return map;
  }

}

class Infobip {
  Infobip({
      String? username, 
      String? password,}){
    _username = username;
    _password = password;
}

  Infobip.fromJson(dynamic json) {
    _username = json['username'];
    _password = json['password'];
  }
  String? _username;
  String? _password;

  String? get username => _username;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

}

class Clickatell {
  Clickatell({
      String? apiKey,}){
    _apiKey = apiKey;
}

  Clickatell.fromJson(dynamic json) {
    _apiKey = json['api_key'];
  }
  String? _apiKey;

  String? get apiKey => _apiKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key'] = _apiKey;
    return map;
  }

}

class MailConfig {
  MailConfig({
      String? name,}){
    _name = name;
}

  MailConfig.fromJson(dynamic json) {
    _name = json['name'];
  }
  String? _name;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    return map;
  }

}