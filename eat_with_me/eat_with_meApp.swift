//
//  eat_with_meApp.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/17.
//

import SwiftUI

@main
struct eat_with_meApp: App {
  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(AppData())
//        .onOpenURL(perform: { url in
//          var components = URLComponents(
//            url: url,
//            resolvingAgainstBaseURL: false
//          )!
//          print(components.queryItems)
//        })
    }
  }
}
