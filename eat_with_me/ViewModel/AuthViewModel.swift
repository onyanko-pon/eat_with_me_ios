//
//  AuthViewModel.swift
//  eat_with_me
//  Created by 丸山司 on 2021/12/29.
//

import Foundation
import AuthenticationServices
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
  @Published var appleAuthResults: Result<ASAuthorization, Error>?
  @Published private var disposables = Set<AnyCancellable>()
  @EnvironmentObject var appData: AppData
  
  private var userRepository = UserAPIRepository()
  
  init() {
    $appleAuthResults
      .sink(receiveValue: { results in
        switch results {
          case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
              print("userIdentifier:\(appleIDCredential.user)")
              print("fullName:\(String(describing: appleIDCredential.fullName))")
              print("email:\(String(describing: appleIDCredential.email))")
              print("authorizationCode:\(String(describing: appleIDCredential.authorizationCode))")
              
              print("ここでログイン処理を呼び出す")
              
              async {
                var (user, token) = await self.userRepository.createUserWithAppleAuth(user_identifier: appleIDCredential.user)
//                UserDefaults.standard.set(token, forKey: "token")
//                UserDefaults.standard.set(user.id, forKey: "userID")
                print("set token userid")
                self.appData.setToken(token: token)
                self.appData.setUserID(userID: user.id)
                await self.appData.load()
              }
                
            default:
              break
            }
              
          case .failure(let error):
            print(error.localizedDescription)
              
          default:
            break
          }
      })
      .store(in: &disposables)
  }
}
