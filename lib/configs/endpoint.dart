const host = 'https://api.guftagu.net/api';
// const host = 'http://10.0.2.2:8000/api';

enum RemoteEndpoint {
  // Authentication
  loginPhone(path: 'userservice/user/userloginwithphonenumber/'),
  otpPhone(path: 'userservice/user/userotpverificationbyphonenumber/'),
  loginEmail(path: 'userservice/user/userloginwithemail/'),
  otpEmail(path: 'userservice/user/userotpverificationbyemail/'),
  updateName(path: 'userservice/user/userupdatename/'),

  // Master Service
  fetchLanguages(path: 'masterservice/language/getalllanguage/'),
  fetchBehavious(path: 'masterservice/behaviour/getallbehaviour/'),
  fetchPersionalities(path: 'masterservice/personality/getallpersonality/'),
  fetchRelationships(path: 'masterservice/relationship/getallrelationship/'),
  fetchVoices(path: 'masterservice/voice/getallvoice/'),
  fetchCountries(path: 'masterservice/country/getallcountry/'),
  fetchCities(path: 'masterservice/city/getallcity/'),
  fetchCharacterTypes(path: 'masterservice/charactertype/getallcharactertype/'),

  // Character Creation
  refImageUpload(
    path: 'chatgenerationservice/character/characterimage/refimageupload/',
  ),
  createCharacter(path: 'chatgenerationservice/character/characterimage/gen/'),
  imageSelection(path: 'chatgenerationservice/character/imageselection/'),
  charactersByUser(path: 'chatgenerationservice/character/bycreatorid/'),

  // Chat with character
  initiateChatWithCharacter(path: 'chatgenerationservice/character/initchat/'),
  chatWithCharacter(path: 'chatgenerationservice/character/chat/'),
  chatHistory(path: 'chatgenerationservice/character/chathistory/'),
  chatList(path: 'chatgenerationservice/character/chatlist/')
  //
  ;

  const RemoteEndpoint({required this.path});

  final String path;

  String get url => '$host/$path';
}
