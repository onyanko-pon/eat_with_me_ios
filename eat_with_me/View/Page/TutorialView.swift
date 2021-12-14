//
//  TutorialView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/05.
//

import SwiftUI
import AuthenticationServices

class AuthPresentationContextProver: NSObject, ASWebAuthenticationPresentationContextProviding {
    private weak var viewController: UIViewController!

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return viewController?.view.window! ?? ASPresentationAnchor()
    }
}

func extractTokenVerifier(queryItems: [URLQueryItem]) -> (String, String) {
  var oauth_token: String = ""
  var oauth_verifier :String = ""
  for queryItem in queryItems {
    if queryItem.name == "oauth_token" {
      oauth_token = queryItem.value!
    }
    if queryItem.name == "oauth_verifier" {
      oauth_verifier = queryItem.value!
    }
  }
  
  return (oauth_token, oauth_verifier)
}

struct TutorialView: View {
  @EnvironmentObject var appData: AppData
  let twitterRepository = TwitterAPIRepository()
  let userRepository = UserAPIRepository()
  @State var secret = ""
  
  init(){
  }
  
  var body: some View {
    VStack {
      Text("サインイン")
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        
      Spacer()
      Button(action: {
        async {
          let (token, secret) = await twitterRepository.fetchRequestToken()
          if let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") {
            print("start session")
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "eat-with-me-app-twitter")
            { callbackURL, error in
              print("callback", callbackURL)
              print("error", error)
              let components = URLComponents(
                url: callbackURL!,
                resolvingAgainstBaseURL: false
              )!
              
              let (token, verifier) = extractTokenVerifier(queryItems: components.queryItems!)
              
              async {
                print("token:", token, "secret:", secret, "verifier:", verifier)
                let (user, jwtToken) = await userRepository.createUserWithTwitterAuth(token: token, secret: secret, verifier: verifier)
                appData.setToken(token: jwtToken)
                appData.setUserID(userID: user.id)
              }
            }
            let presentationContextProvider = AuthPresentationContextProver(viewController: UIHostingController(rootView: self))
            session.presentationContextProvider = presentationContextProvider
            session.start()
          }
          
        }
      }) {
        
        HStack {
          Image("twitter_icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .padding()
          Text("Sign in with Twitter")
            .font(.callout)
            .foregroundColor(Color.white)
          Spacer()
        }
        .frame(width: 260, height: 44)
        .foregroundColor(Color(.white))
        .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
        .cornerRadius(8)
        
      }
      Spacer()
    }
  }
  
  
}

//struct TutorialView_Previews: PreviewProvider {
//  static var previews: some View {
//    TutorialView()
//      .previewInterfaceOrientation(.portrait)
//  }
//}


