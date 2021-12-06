//
//  UserAPIRepository.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/25.
//

import Foundation
import UIKit
import Alamofire
import SwiftUI

struct UserCodable: Codable {
  let id: Int
  let username: String
  let imageURL: String
  
  func toUser() -> User {
    return User(id: self.id, username: self.username, imageURL: self.imageURL)
  }
}

struct FetchUserResult: Codable {
  let user: UserCodable
}

struct FetchFriendsResult: Codable {
  let friends: [UserCodable]
}

struct CreateUserResult: Codable {
  let user: UserCodable
  let token: String
}

struct CreateUserBody: Codable {
  struct UserCodable: Codable {
    let username: String
    let imageURL: String
  }
  let user: UserCodable
}

struct UploadIcon: Codable {
  let url: String
  let filename: String
}

struct CreateUserWithTwitterBody: Codable {
  let oauth_token: String
  let oauth_secret: String
  let oauth_verifier: String
}

class UserAPIRepository: APIRepository {
  
  func fetchUser(userID: Int64) async -> User {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchUserResult.self, from: data!)
    let userCodable = json.user
    
    return userCodable.toUser()
  }
  
  func fetchFriends(userID: Int64) async -> [User] {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchFriendsResult.self, from: data!)
    
    var users: [User] = []
    
    for u in json.friends {
      let user = u.toUser()
      users.append(user)
    }
    
    return users
  }
  
  func createUser(username: String, imageURL: String) async -> (User, String) {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users")
    requestEntity.setPostRequest()
    
    let requestBody = CreateUserBody(user: CreateUserBody.UserCodable(username: username, imageURL: imageURL))
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try! encoder.encode(requestBody)
    let jsonstr: String = String(data: jsonData, encoding: .utf8)!
    requestEntity.setJsonBody(json: jsonstr)
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    do {
      let json = try decoder.decode(CreateUserResult.self, from: data!)
      let user = User(id: json.user.id, username: json.user.username, imageURL: json.user.imageURL)
    
      return (user, json.token)
    } catch {
      print(error)
      fatalError()
    }
  }
  
  func uploadUserIcon(userID: Int, uiImage: UIImage, token: String) async {
    let url = "https://eat-with.herokuapp.com/api/users/\(userID)/usericons"
    
    var request = self.uploadRequest(url: url, data: uiImage.jpegData(compressionQuality: 1.0)!, name: "usericon", token: token)
    request
      .response{ res in
        print(res)
      }
  }
  
  func createUserWithTwitterAuth(token: String, secret: String, verifier: String) async -> (User, String) {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/twitter_verify")
    requestEntity.setPostRequest()
    
    let requestBody = CreateUserWithTwitterBody(oauth_token: token, oauth_secret: secret, oauth_verifier: verifier)
    let encoder = JSONEncoder()
    let jsonData = try! encoder.encode(requestBody)
    let jsonstr: String = String(data: jsonData, encoding: .utf8)!
    requestEntity.setJsonBody(json: jsonstr)
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    print("res data")
    print(String(data: data!, encoding: .utf8))
    let items = try! JSONSerialization.jsonObject(with: data!)
    print(items)
    let decoder = JSONDecoder()
    do {
      let json = try decoder.decode(CreateUserResult.self, from: data!)
      let user = User(id: json.user.id, username: json.user.username, imageURL: json.user.imageURL)
    
      return (user, json.token)
    } catch {
      print(error)
      fatalError()
    }
  }
}
