//
//  User.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

struct User: Identifiable {
  let id = UUID()
  let username: String
//  let name: String
  let imageURL: String
}

