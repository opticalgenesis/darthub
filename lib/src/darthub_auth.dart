import 'dart:math';
import 'dart:io';

class DartHubAuth {

  static String generateState(int stateSize) {
    String seed = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghijklmnopqrstuvwxyz";
    StringBuffer stateBuffer = new StringBuffer();
    Random r = new Random();

    for (int i = 0; i < stateSize - 1; i++) {
      stateBuffer.write(seed[r.nextInt(seed.length - 1)]);
    }
    return stateBuffer.toString();
  }

  static String generateLoginUrl(String redirectUrl, String clientId, String scopes, String state,
      {bool bShouldEnforceSignUp = true}) {
    return "https://github.com/login/oauth/authorize/?client_id=$clientId&redirect_uri=$redirectUrl"
        "&scope=$scopes&state=$state&allow_signup=$bShouldEnforceSignUp";
  }

  static HttpClientResponse getAccessTokenResponse(String code, String state, String redirectUri,
      String clientId, String clientSecret, {String responseType = "application/json"}) {
    HttpClientResponse resp;
    HttpClient client = new HttpClient();
    client.postUrl(Uri.parse("https://github.com/login/oauth/access_token"))
    .then((HttpClientRequest req) {
      req.headers.contentType = new ContentType("application", "x-www-form-urlencoded");
      req.headers.add("Accept", responseType);
      req.write("client_id=$clientId&client_secret=$clientSecret&code=$code&redirect_uri=$redirectUri"
          "&state=$state");
    }).then((HttpClientResponse response) {
      resp = response;
    });
    return resp;
  }
}