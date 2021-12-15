//
//  ApplyFriendModalView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/06.
//

import SwiftUI


struct ApplyFriendModalView: View {
  
  var userID: Int
  @State var username = ""
  @State var user: User? = nil
  @Binding var openSheet: Bool
  @State var userNotFound = false
  
  var applyUserData = ApplyFriendData()
  
  var body: some View {
    VStack {
      Text("友達申請")
        .fontWeight(.heavy)
        .font(.title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
      
      Spacer()
      
      if user == nil {
        TextField("友達のユーザーIDを入力", text: $username)
          .padding(.bottom, 40)
        
        if self.userNotFound == true {
          Text("友達が見つかりませんでした")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color.red)
            .padding(.bottom, 6)
        }
        
        Button(action: {
          async {
            let user = await applyUserData.searchFriend(username: self.username)
            if user == nil {
              self.userNotFound = true
            } else {
              self.user = user
              self.userNotFound = false
            }
          }
        }) {
          Text("友達を探す")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        
        UserIcon(
          url: user!.imageURL,
          size: 130.0
        )
        .padding(.bottom, 12)
        
        Text(user!.username)
          .font(.title)
          .fontWeight(.bold)
          .padding(.bottom, 24)
        
        Button(action: {
          async {
            await self.applyUserData.apply(userID: self.userID, friend_user_id: self.user!.id)
            openSheet.toggle()
            
          }
        }) {
          Text("友達申請")
            .font(.body)
            .fontWeight(.bold)
        }
        .frame(width: 120, height: 50, alignment: .center)
        .foregroundColor(Color(.white))
        .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
        .cornerRadius(8)
        
      }
      Spacer()
    }
    .onAppear(perform: {
      print(self.user)
    })
    .padding(.all, 24)
  }
}

//
//struct ApplyFriendModalView_Previews: PreviewProvider {
//  static var previews: some View {
//    ApplyFriendModalView(userID: 11, openSheet: <#T##Binding<Bool>#>)
//  }
//}

