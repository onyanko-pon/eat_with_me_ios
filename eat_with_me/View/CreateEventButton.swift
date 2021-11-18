//
//  CreateEventButton.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation
import SwiftUI

struct CreateEventButton: View {
  var action: (() -> Void)?

  var body: some View {
    Button(action: action!){
      Text("この辺でごはんを誘う")
        .fontWeight(.medium)
        .padding()
        .frame(height: 44)
        .foregroundColor(.white)
        .background(Color.orange)
        .cornerRadius(24)
    }
    .shadow(radius: 3)
  }
}
