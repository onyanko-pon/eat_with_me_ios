//
//  FriendData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/07.
//

import Foundation

class FriendData {
  private var userRepository = UserAPIRepository()
  
  func block(userID: Int, friendUserID: Int) async {
    await self.userRepository.blockFriend(userID: userID, friend_user_id: friendUserID)
  }
  
}
