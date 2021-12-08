//
//  UserDetailModal.swift
//  eat_with_me
//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI


struct FriendDetailView: View {
  
  var friend: Friend
  var friendData = FriendData()
  @State var openModal = false
  
  var body: some View {
    VStack {
      HStack {
        UserIcon(url: self.friend.user.imageURL, size: 90.0)
          .padding(.trailing, 20)
        Text(self.friend.user.username)
          .font(.title)
        Spacer()
        
        if friend.status == "accepted" {
          Button(action: {
            self.openModal.toggle()
          }) {
            Image("edit")
          }
        }
      }
      .padding(.top, 16)
      
      Spacer()
    }
    .navigationBarTitle(Text(self.friend.user.username))
    .padding(.vertical, 10)
    .padding(.horizontal, 30)
    .sheet(isPresented: self.$openModal) {
      FriendDetailModalView(friend: friend, openModal: self.$openModal)
    }
  }
}

//struct FriendDetail_Previews: PreviewProvider {
//  static var previews: some View {
//    FriendDetailView(user: user)
//  }
//}

