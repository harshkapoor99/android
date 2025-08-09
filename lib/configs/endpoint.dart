import 'package:guftagu_mobile/configs/host.dart';

enum RemoteEndpoint {
  // Authentication
  loginPhone(path: 'userservice/user/userloginwithphonenumber/'),
  otpPhone(path: 'userservice/user/userotpverificationbyphonenumber/'),
  loginEmail(path: 'userservice/user/userloginwithemail/'),
  otpEmail(path: 'userservice/user/userotpverificationbyemail/'),
  updateName(path: 'userservice/user/userupdatename/'),

  // user interests
  saveInterests(path: "userservice/user/selectcharactertype/"),

  // google auth
  googleAuthenticationByEmail(
    path: 'userservice/user/googleauthenticationbyemail/',
  ),

  // Master Service
  fetchLanguages(path: 'masterservice/language/getalllanguage/'),
  fetchBehavious(path: 'masterservice/behaviour/getallbehaviour/'),
  fetchPersionalities(path: 'masterservice/personality/getallpersonality/'),
  fetchRelationships(path: 'masterservice/relationship/getallrelationship/'),
  fetchVoices(path: 'masterservice/voice/getallvoice/'),
  fetchVoicesByLanguage(path: 'masterservice/voice/voicedetailsbylanguageid/'),
  fetchCountries(path: 'masterservice/country/getallcountry/'),
  fetchCities(path: 'masterservice/city/getallcity/'),
  fetchCitiesByCountry(path: 'masterservice/city/citiesdetailsbycountryid/'),
  fetchCharacterTypes(path: 'masterservice/charactertype/getallcharactertype/'),

  searchCharacters(
    path: 'chatgenerationservice/character/admincharactersearchformobile/',
  ),

  // MasterData by id
  fetchBehaviousByPersonality(
    path: 'masterservice/behaviour/behaviourdetailsbypersonalityid/',
  ),
  fetchPersionalitiesByRelationship(
    path: 'masterservice/personality/personalitydetailsbyrelationshipid/',
  ),
  fetchRelationshipsByCharactertype(
    path: 'masterservice/relationship/relationshipdetailsbycharactertypeid/',
  ),

  fetchMasterCharacters(
    path: 'chatgenerationservice/character/getallcharacterformobile/',
  ),
  fetchMasterCharactersByCharacterType(
    path:
        'chatgenerationservice/character/characterdetailsbycharactertypeidformobile/',
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
  characterImageUpdate(
    path: 'chatgenerationservice/character/updatecharacterimage/',
  ),
  deleteCharacter(
    path: "chatgenerationservice/character/deletecharacterformobile/",
  ),

  // Chat with character
  initiateChatWithCharacter(path: 'chatgenerationservice/character/initchat/'),
  chatWithCharacter(path: 'chatgenerationservice/character/chat/'),
  chatHistory(path: 'chatgenerationservice/character/chathistory/'),
  chatList(path: 'chatgenerationservice/character/chatlist/'),

  // Audio
  generateAudio(path: "chatgenerationservice/character/texttospeech/"),
  audioMessage(path: "chatgenerationservice/character/speechtotextgeneration/"),

  // call
  voiceCall(path: "chatgenerationservice/character/voicecall/"),

  // File/Image
  fileMessage(path: "chatgenerationservice/character/fileuploadinchat/"),

  // User Profile
  profileDetails(path: 'userservice/user/userdetailsbyuserid/'),
  updateProfile(path: 'userservice/user/userupdateprofile/'),
  updateProfileImage(path: 'userservice/user/userprofileimageupdate/'),

  // User profile verify
  userVerify(path: "userservice/user/userverifybyphoneoremail/"),
  userVerifyOtp(path: "userservice/user/otpverify/"),

  // subscription
  fetchSubscriptions(
    path: "subscriptionandbillingservice/subscription/getallsubscription/",
  ),
  fetchWallet(
    path: "subscriptionandbillingservice/wallet/walletdetailsbyuserid/",
  ),
  rechargeWallet(
    path: "subscriptionandbillingservice/walletrecharge/createwalletrecharge/",
  )
  // ending semicolon - DONT REMOVE THIS COMMENT
  ;

  const RemoteEndpoint({required this.path});

  final String path;

  String get url => '$host/$path';
}
