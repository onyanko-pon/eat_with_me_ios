//
//  RootView.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/24.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var appData: AppData
  @State var isActive = false
  
  var body: some View {
    VStack {
      if self.isActive {
        if appData.userID != 0 {
          ContentView(userID: appData.userID)
            .environmentObject(appData)
            .animation(Animation.easeIn(duration: 0.1))
        } else {
          TutorialView()
        }
      } else {
        Image("splash")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          
      }
    }.onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        withAnimation {
          self.isActive = true
        }
      }
    }
    .onOpenURL(perform: { url in
      print(url)
    })
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
      .previewInterfaceOrientation(.portrait)
  }
}

