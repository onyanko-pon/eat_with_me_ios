//
//  EventsData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

class UsersData: ObservableObject {
  @Published var users: [User] = []
  
  func appendUser(user :User) {
    self.users.append(user)
  }
}

