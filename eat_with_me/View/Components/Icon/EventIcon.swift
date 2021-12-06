//
//  EventIcon.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation
import SwiftUI

struct EventIcon: View {
  var url: String
  let color = Color(red: 1.0, green: 84/255, blue: 168/255)
  var body: some View {
    URLImage(url: url)
      .frame(width: 60.0, height: 60.0, alignment: .leading)
      .clipShape(Circle())
      .overlay(Circle().stroke(color, lineWidth: 2))
  }
}
