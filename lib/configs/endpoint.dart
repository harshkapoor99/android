import 'package:guftagu_mobile/configs/host.dart';

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

  // MasterData by id
  fetchBehaviousByPersonality(path: 'masterservice/behaviour/getallbehaviour/'),
  fetchPersionalitiesByRelationship(
    path: 'masterservice/personality/getallpersonality/',
  ),
  fetchRelationshipsByCharactertype(
    path: 'masterservice/relationship/getallrelationship/',
  ),

  fetchMasterCharacters(
    path: 'chatgenerationservice/character/getallcharacterlist/',
  ),

  // Generate Random prompt
  generateRandomPrompt(
    path: "chatgenerationservice/character/createramdomprompt/",
  ),

  // Character Creation
  refImageUpload(
    path: 'chatgenerationservice/character/characterimage/refimageupload/',
  ),
  createCharacter(path: 'chatgenerationservice/character/characterimage/gen/'),
  imageSelection(path: 'chatgenerationservice/character/imageselection/'),
  charactersByUser(path: 'chatgenerationservice/character/bycreatorid/'),
  charactersDetails(
    path: 'chatgenerationservice/character/characterdetailsbycharacterid/',
  ),

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
