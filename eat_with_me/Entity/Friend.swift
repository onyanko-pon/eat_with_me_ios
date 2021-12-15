//
//  Friend.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/07.
//

import Foundation

struct Friend: Identifiable {
  let id = UUID()
  let blinding: Bool
  let user: User
}

struct FriendList {
  var friends: [Friend]
  
  func len() -> Int {
    return self.friends.count
  }
}
