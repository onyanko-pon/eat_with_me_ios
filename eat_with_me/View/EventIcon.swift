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
  
  var body: some View {
    URLImage(url: url)
      .frame(width: 70.0, height: 70.0, alignment: .leading)
      .clipShape(Circle())
      .overlay(Circle().stroke(Color.pink, lineWidth: 3))
  }
}
