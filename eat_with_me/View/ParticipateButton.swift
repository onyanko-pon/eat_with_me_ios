//
//  ParticipateButton.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation
import SwiftUI

struct PerticipateButton: View {
  var action: (() -> Void)?

  var body: some View {
    Button(action: action!){
      Text("参加する")
        .fontWeight(.medium)
        .padding()
        .frame(height: 40)
        .foregroundColor(.white)
        .background(Color.orange)
        .cornerRadius(8)
    }
    .shadow(radius: 2)
  }
}

