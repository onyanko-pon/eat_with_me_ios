//
//  AppData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/05.
//

import Foundation
import AuthenticationServices
import Combine
import SwiftUI

class AppData: ObservableObject {
  @Published var userID: Int = 0
  @Published var token: String? = nil
  @Published var user: User? = nil
  @Published var friendList: FriendList = FriendList(friends: [])
  @Published var friendApplyings: [FriendApply] = []
  @Published var friendApplyeds: [FriendApply] = []
  @Published var recommendUsers: [User] = []
  
  @Published var appleAuthResults: Result<ASAuthorization, Error>?
  @Published private var disposables = Set<AnyCancellable>()
  
  var userRepository = UserAPIRepository()
  
  init() {
    setUpAppleAuth()
    async {
     await self.load()
    }
  }
  
  func load() async {
    let userID = UserDefaults.standard.integer(forKey: "userID")
    let token = UserDefaults.standard.string(forKey: "token")
    
    if userID != 0 {
      self.setUserID(userID: userID)
      let user = await userRepository.fetchUser(userID: Int64(userID))
      let (friends, applyings, applyeds) = await userRepository.fetchFriends(userID: Int64(userID))
      self.user = user
      self.friendList = FriendList(friends: friends)
      self.friendApplyings = applyings
      self.friendApplyeds = applyeds
      
      self.recommendUsers = await self.userRepository.fetchRecommendFriends(userID: Int64(userID))
    }
    
    if token != nil {
      self.setToken(token: token!)
      print("token", token)
    }
  }
  
  func loadFriend() async {
    let (friends, applyings, applyeds) = await self.userRepository.fetchFriends(userID: Int64(userID))
    self.friendList = FriendList(friends: friends)
    self.friendApplyings = applyings
    self.friendApplyeds = applyeds
    
    self.recommendUsers = await self.userRepository.fetchRecommendFriends(userID: Int64(userID))
  }
  
  func setToken(token: String) {
    UserDefaults.standard.set(token, forKey: "token")
    self.token = token
  }
  
  func setUserID(userID: Int) {
    UserDefaults.standard.set(userID, forKey: "userID")
    self.userID = userID
  }
  
  func setUpAppleAuth() {
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
                self.setToken(token: token)
                self.setUserID(userID: user.id)
                await self.load()
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
