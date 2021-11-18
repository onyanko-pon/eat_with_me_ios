//
//  UserIcon.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation
import SwiftUI

struct UserIcon: View {
  var url: String
  var size: Double = 90.0
  
  let color = Color(red: 1.0, green: 84/255, blue: 168/255)
  var body: some View {
    URLImage(url: url)
      .frame(width: size, height: size, alignment: .leading)
      .clipShape(Circle())
      .overlay(Circle().stroke(color, lineWidth: 3))
  }
}

