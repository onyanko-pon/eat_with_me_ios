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
  @State var openFriendModal = false
  @EnvironmentObject var appData: AppData
  @State var recommendUsers: [User] = []
  let userRepository = UserAPIRepository()
  
  init(userID: Int) {
    self.userID = userID
  }
  
  var body: some View {
    VStack {
      Button(action: {
        self.openFriendModal.toggle()
      }) {
        Text("友達を追加")
          .font(.body)
          .frame(width: 120, height: 40)
          .foregroundColor(Color(.white))
          .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
          .cornerRadius(8)
        
      }
      
      List {
        Section(header: Text("フォローリクエスト中 \(appData.friendList.filterApplying().count)人")) {
          ForEach(appData.friendList.filterApplying()) { friend in
            NavigationLink(destination: FriendDetailView(friend: friend)) {
              HStack {
                UserIcon(url: friend.user.imageURL, size: 60.0)
                  .padding(.trailing, 10)
                Text(friend.user.username)
                  .font(.headline)
              }
              .padding(.all, 6)
            }
          }
        }
        
        Section(header: Text("友達 \(appData.friendList.filterAccepted().count)人")) {
          ForEach(appData.friendList.filterAccepted()) { friend in
            NavigationLink(destination: FriendDetailView(friend: friend)) {
              HStack {
                UserIcon(url: friend.user.imageURL, size: 60.0)
                  .padding(.trailing, 10)
                Text(friend.user.username)
                  .font(.headline)
              }
              .padding(.all, 6)
            }
          }
        }
        
        Section(header: Text("フォローリクエスト \(appData.friendApplyeds.count)人")) {
          ForEach(appData.friendApplyeds) { apply in
            HStack {
              UserIcon(url: apply.user.imageURL, size: 60.0)
                .padding(.trailing, 10)
              Text(apply.user.username)
                .font(.headline)
              
              Spacer()
              Button(action: {
                async {
                  await userRepository.acceptFriend(userID: appData.userID, friend_user_id: user.id)
                  print("許可")
                  await appData.load()
                }
              }) {
                Text("許可")
                  .font(.caption)
                  .fontWeight(.medium)
                  .frame(width: 55, height: 30)
                  .foregroundColor(Color(.white))
                  .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
                  .cornerRadius(8)
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.trailing, 2)

              Button(action: {
                print("削除")
//                async {
//                  await userRepository.applyFriend(userID: appData.userID, friend_user_id: user.id)
//                  await appData.load()
//                }
              }) {
                Text("削除")
                  .font(.caption)
                  .fontWeight(.medium)
                  .frame(width: 55, height: 30)
                  .foregroundColor(Color(.black))
                  // .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
                  .overlay(
                    RoundedRectangle(cornerRadius: 8)
                      .stroke(Color.gray, lineWidth: 0.5)
                  )
              }
              .buttonStyle(PlainButtonStyle())
            }
            .padding(.all, 6)
          }
        }
        
        Section(header: Text("友達かも? \(appData.recommendUsers.count)人")) {
          ForEach(appData.recommendUsers) { user in
            HStack {
              UserIcon(url: user.imageURL, size: 60.0)
                .padding(.trailing, 10)
              
              Text(user.username)
                .font(.headline)
              
              Spacer()
              Button(action: {
                async {
                  await userRepository.applyFriend(userID: appData.userID, friend_user_id: user.id)
                  await appData.load()
                }
              }) {
                Text("フォロー申請")
                  .font(.caption)
                  .fontWeight(.medium)
                  .frame(width: 85, height: 34)
                  .foregroundColor(Color(.white))
                  .background(Color(red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0)))
                  .cornerRadius(8)
              }
              .buttonStyle(PlainButtonStyle())
                
            }
            .padding(.all, 6)
          }
        }
       }
      .listStyle(InsetListStyle())
      .navigationBarTitle(Text("友達リスト"))
    }
    .sheet(isPresented: self.$openFriendModal) {
      ApplyFriendModalView(userID: userID, openSheet: self.$openFriendModal)
    }
  }
}

struct FriendListView_Previews: PreviewProvider {
  static var previews: some View {
    FriendListView(userID: 2)
  }
}
