//
//  ContentView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

let user = User(username: "username", imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png")

struct UserList: View {
  
  var body: some View {
//    NavigationView {
      
      List([user, user, user,user,user,user,user,user,user,user,user,user,user,user]) { user in
        NavigationLink(destination: UserDetail(user: user)) {
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
      .navigationBarTitle(Text("ユーザー一覧"))
      .padding(.top, 20)
      
//    }
//    }
  }
}

struct UserList_Previews: PreviewProvider {
  static var previews: some View {
    UserList()
  }
}
