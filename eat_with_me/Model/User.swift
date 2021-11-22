//
//  User.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation
import UIKit

struct User: Identifiable {
  let uuid = UUID()
  let id: Int
  let username: String
  let imageURL: String
//  let image: UIImage
}

