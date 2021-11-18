//
//  Event.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

struct Event: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let date: Date
  let latitude: Double
  let longitude: Double
  let imageURL: String
}
