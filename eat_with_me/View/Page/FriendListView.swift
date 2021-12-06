//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

let user = User(id: 1, username: "username", imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png")

struct FriendListView: View {
  var userID: Int
  init(userID: Int) {
    self.userID = userID
//    self.data = FriendsData(userID: userID)
  }
  @EnvironmentObject var appData: AppData
  
  var body: some View {
      
    List(appData.friends) { user in
        NavigationLink(destination: FriendDetailView(user: user)) {
          HStack {
            UserIcon(url: user.imageURL, size: 60.0)
              .padding(.trailing, 10)
            Text(user.username)
              .font(.headline)
          }
          .padding(.all, 6)
        }
      }
      .listStyle(InsetListStyle())
      .navigationBarTitle(Text("友達リスト"))
      .padding(.top, 20)
  }
}

struct FriendListView_Previews: PreviewProvider {
  static var previews: some View {
    FriendListView(userID: 2)
  }
}
