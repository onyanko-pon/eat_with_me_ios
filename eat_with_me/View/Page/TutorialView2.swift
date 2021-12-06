//
//  TutorialView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/24.
//

import SwiftUI

struct TutorialView2: View {
  @EnvironmentObject var appData: AppData
  @ObservedObject var createUserData = CreateUserData()
  @State private var image: UIImage? = nil
  @State var username = ""
  @State var isPresented = false
  
  init(){
  }
  
  var body: some View {
    NavigationView {
      
      Form {
        Section {
          TextField("ユーザー名", text: $username)
          
          Button(action: {
            self.isPresented = true
          }) {
            Text("アイコンを設定")
          }
          if let image = self.image {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(minWidth: 0, maxWidth: .infinity)
              .edgesIgnoringSafeArea(.all)
          }
        }
        Section {
          Button(action: {
            if let image = self.image {
              async {
                let (token, userID) = await createUserData.createUser(
                  username: username,
                  uiimage: image
                )
                appData.setToken(token: token)
                appData.setUserID(userID: userID)
              }
            }
            
          }) {
            Text("はじめる")
          }
        }
      }
      .navigationTitle("チュートリアル")
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .sheet(isPresented: $isPresented, content: {
      ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
    })
  }
  
  
}

//struct TutorialView_Previews: PreviewProvider {
//  static var previews: some View {
//    TutorialView()
//      .previewInterfaceOrientation(.portrait)
//  }
//}


