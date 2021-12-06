//
//  CreateUserData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/24.
//

import Foundation
import SwiftUI
 
class CreateUserData: ObservableObject {
  
  struct ResultJson: Codable {
    struct UserCodable: Codable {
      let id: Int
      let username: String
      let imageURL: String
    }
    let user: UserCodable?
    let token: String?
  }
  
  struct UploadResult: Codable {
    let url: String
    let filename: String
  }
  
  struct CreateBody: Codable {
    struct UserCodable: Codable {
      let username: String
      let imageURL: String
    }
    let user: UserCodable?
  }
  
  @Published var user: User? = nil
  var userRepository = UserAPIRepository()
  
  let fieldName = "usericon"
  let boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
  
  init() {
    
  }
  
  func createUser(username: String, uiimage: UIImage) async -> (String, Int){
    
    let (user, token) = await self.userRepository.createUser(username: username, imageURL: "")
    await self.userRepository.uploadUserIcon(userID: user.id, uiImage: uiimage, token: token)
    
    return (token, user.id)
  }
}

