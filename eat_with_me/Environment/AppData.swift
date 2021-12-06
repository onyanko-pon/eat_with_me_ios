//
//  AppData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/05.
//

import Foundation

class AppData: ObservableObject {
  @Published var userID: Int = 0
  @Published var token: String? = nil
  @Published var user: User? = nil
  @Published var friends: [User] = []
  
  let userRepository = UserAPIRepository()
  
  init() {
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
      let friends = await userRepository.fetchFriends(userID: Int64(userID))
      self.user = user
      self.friends = friends
    }
    
    if token != nil {
      self.setToken(token: token!)
      print("token", token)
    }
  }
  
  func setToken(token: String) {
    UserDefaults.standard.set(token, forKey: "token")
    self.token = token
  }
  
  func setUserID(userID: Int) {
    UserDefaults.standard.set(userID, forKey: "userID")
    self.userID = userID
  }
}
