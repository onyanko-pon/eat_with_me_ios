//
//  Event.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

struct Event: Identifiable {
  let uuid = UUID()
  let id: Int
  let title: String
  let description: String
  let startDatetime: Date
  let endDatetime: Date
  let latitude: Double
  let longitude: Double
  let imageURL: String
  var organizeUser: User
  var participants: [User]
}
