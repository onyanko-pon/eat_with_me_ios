//
//  FriendDetailModalView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/07.
//

import Foundation
import SwiftUI

struct FriendDetailModalView: View {
  @EnvironmentObject var appData: AppData
  var friend: Friend
  @Binding var openModal: Bool
  
  var friendData = FriendData()
  
  var body: some View {
    VStack {
      Text(friend.user.username)
        .fontWeight(.heavy)
        .font(.title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
        .padding(.leading, 16)
      
      List {
        Button(action: {
          async {
            await self.friendData.block(userID: appData.userID, friendUserID: friend.user.id)
            self.openModal.toggle()
            await appData.load()
            // TODO ブロックしたとポップアップを出す
          }
        }) {
          Text("ブロックする")
            .foregroundColor(Color.red)
        }
      }
      .listStyle(InsetListStyle())
      
      Spacer()
    }
    .padding(.top, 24)
  }
}
