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
  
  var user: User
  
  var body: some View {
    VStack {
      HStack {
        UserIcon(url: self.user.imageURL, size: 90.0)
          .padding(.trailing, 20)
        Text(user.username)
          .font(.title)
        Spacer()
      }
      .padding(.top, 16)
      Spacer()
    }
    .navigationBarTitle(Text(self.user.username))
    .padding(.vertical, 10)
    .padding(.horizontal, 30)
  }
}

struct FriendDetail_Previews: PreviewProvider {
  static var previews: some View {
    FriendDetailView(user: user)
  }
}

