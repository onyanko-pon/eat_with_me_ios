//
//  TutorialView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/05.
//

import SwiftUI

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
          self.secret = secret
          if let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") {
            await UIApplication.shared.open(url)
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
    .onOpenURL(perform: { url in
      print("url", url)
      let components = URLComponents(
        url: url,
        resolvingAgainstBaseURL: false
      )!
      let (token, verifier) = extractTokenVerifier(queryItems: components.queryItems!)
      print("token:", token, "secret:", secret, "verifier:", verifier)
      
      async {
        let (user, jwtToken) = await userRepository.createUserWithTwitterAuth(token: token, secret: secret, verifier: verifier)
        appData.setToken(token: jwtToken)
        appData.setUserID(userID: user.id)
      }
    })
//    .sheet(isPresented: self.$isPresented, content: {
//    })
  }
  
  
}

//struct TutorialView_Previews: PreviewProvider {
//  static var previews: some View {
//    TutorialView()
//      .previewInterfaceOrientation(.portrait)
//  }
//}


