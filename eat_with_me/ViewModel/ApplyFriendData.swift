//
//  ApplyFriend.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/06.
//

import Foundation

class ApplyFriendData {
  var userRepository = UserAPIRepository()
  
  
  func searchFriend(username: String) async -> User? {
    let user = await self.userRepository.fetchUserByUsername(username: username)
    return user
  }
  
  func apply(userID: Int, friend_user_id: Int) async {
    await userRepository.applyFriend(userID: userID, friend_user_id: friend_user_id)
  }
  
}
