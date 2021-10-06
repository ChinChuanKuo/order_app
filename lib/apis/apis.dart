class APi {
  static List<Map<String, dynamic>> user = const [
    {"url": "localhost:5000", "route": "Userinfo/searchData"},
    {"url": "localhost:5000", "route": "Notifications/searchData"},
    {"url": "localhost:5000", "route": "Notifications/filterData"},
    {"url": "localhost:1337", "route": "histories/searchData"},
    {"url": "localhost:1337", "route": "histories/filterData"},
  ];

  static List<Map<String, dynamic>> signin = const [
    {"url": "localhost:5000", "route": "signin/signinData"},
    {"url": "localhost:1337", "route": "forget/forgetData"},
    {"url": "localhost:1337", "route": "code/verificationData"},
    {"url": "localhost:1337", "route": "code/resendData"},
    {"url": "localhost:1337", "route": "resend/resendData"},
  ];

  static List<Map<String, dynamic>> menu = const [
    {"url": "localhost:5000", "route": "Menu/officeData"},
    {"url": "localhost:5000", "route": "Menu/searchData"},
    {"url": "localhost:5000", "route": "Menu/orderData"},
    {"url": "localhost:5000", "route": "Menu/insertData"},
    {"url": "localhost:5000", "route": "Menu/deleteData"},
  ];

  static List<Map<String, dynamic>> money = const [
    {"url": "localhost:5000", "route": "Money/balanceData"},
    {"url": "localhost:5000", "route": "Money/searchData"},
    {"url": "localhost:5000", "route": "Money/statistData"},
    {"url": "localhost:5000", "route": "Money/analysisData"},
  ];

  static List<Map<String, dynamic>> suggest = const [
    {"url": "localhost:5000", "route": "Suggest/insertData"},
  ];

  static List<Map<String, dynamic>> profile = const [
    {"url": "localhost:5000", "route": "Profile/searchData"},
  ];
}
