// const host = 'https://api.guftagu.net/api';
const host = 'http://10.0.2.2:8000/api';

enum RemoteEndpoint {
  // Authentication
  loginPhone(path: 'userservice/user/userloginwithphonenumber/'),
  otpPhone(path: 'userservice/user/userotpverificationbyphonenumber/'),
  loginEmail(path: 'userservice/user/userloginwithemail/'),
  otpEmail(path: 'userservice/user/userotpverificationbyemail/'),

  // Master Service
  fetchLanguages(path: 'masterservice/language/getalllanguage/'),
  fetchBehavious(path: 'masterservice/behaviour/getallbehaviour/'),
  fetchPersionalities(path: 'masterservice/personality/getallpersonality/'),
  fetchRelationships(path: 'masterservice/relationship/getallrelationship/'),
  fetchVoices(path: 'masterservice/voice/getallvoice/'),
  fetchCountries(path: 'masterservice/country/getallcountry/'),
  fetchCities(path: 'masterservice/city/getallcity/'),
  fetchCharacterTypes(path: 'masterservice/charactertype/getallcharactertype/')
  //
  ;

  const RemoteEndpoint({required this.path});

  final String path;

  String get url => '$host/$path';
}
