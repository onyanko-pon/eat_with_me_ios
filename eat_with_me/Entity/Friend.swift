//
//  Friend.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/07.
//

import Foundation

struct Friend: Identifiable {
  let id = UUID()
  let status: String
  let user: User
}

struct FriendList {
  var friends: [Friend]
  
  func len() -> Int {
    return self.friends.count
  }
  
  func filterAccepted() -> [Friend] {
    var resFriends: [Friend] = []
    for friend in self.friends {
      if friend.status == "accepted" {
        resFriends.append(friend)
      }
    }
    return resFriends
  }
  
  func filterApplying() -> [Friend] {
    var resFriends: [Friend] = []
    for friend in self.friends {
      if friend.status == "applying" {
        resFriends.append(friend)
      }
    }
    return resFriends
  }
}
