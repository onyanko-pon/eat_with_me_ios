//
//  File.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/22.
//

import SwiftUI

struct UserDetailView: View {
  
  @Binding var user: User?
  
  var body: some View {
    if let user = self.user {
      
      VStack {
        HStack {
          UserIcon(url: user.imageURL, size: 90.0)
            .padding(.trailing, 20)
          Text(user.username)
            .font(.title)
          Spacer()
        }
        .padding(.top, 16)
        Spacer()
      }
      .navigationBarTitle(Text(user.username))
      .padding(.vertical, 10)
      .padding(.horizontal, 30)
    } else {
      VStack {}
    }
  }
}

//struct UserDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    UserDetailView(user: $user)
//  }
//}

