//
//  ParticipateButton.swift
//  eat_with_me
//
//  Created by 丸山司 on 2022/1/26.
//

import Foundation
import SwiftUI

struct EditButton: View {
  var action: (() -> Void)?

  var body: some View {
    Button(action: action!){
      Text("編集する")
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

