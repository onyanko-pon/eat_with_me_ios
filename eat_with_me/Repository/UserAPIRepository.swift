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

struct FriendApplyCodable: Codable {
  let user: UserCodable
}

struct FriendCodable: Codable {
  let user: UserCodable
  let blinding: Bool
  
  func toFriend() -> Friend {
    return Friend(blinding: self.blinding, user: self.user.toUser())
  }
}

struct FetchUserResult: Codable {
  let user: UserCodable?
}

struct FetchFriendsResult: Codable {
  let friends: [FriendCodable]
  let applyings: [FriendApplyCodable]
  let applyeds: [FriendApplyCodable]
}

struct FetchRecommendUsersResult: Codable {
  let users: [UserCodable]
}

struct CreateUserResult: Codable {
  let user: UserCodable
  let token: String
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
  
  func fetchUser(userID: Int64) async -> User? {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchUserResult.self, from: data!)
    let userCodable = json.user
    
    if let uc = userCodable {
      return uc.toUser()
    }
    return nil
  }
  
  func fetchUserByUsername(username: String) async -> User? {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(username)/by_username")
    requestEntity.setToken()
    
    let (data, response) = await self.request(requestEntity: requestEntity)
    if let httpResponse = response as? HTTPURLResponse {
        print("statusCode: \(httpResponse.statusCode)")
    } else {
      print("fail HTTPURLResponse")
    }
    let str: String? = String(data: data!, encoding: .utf8)
    print(str)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchUserResult.self, from: data!)
    let userCodable = json.user
    
    if let uc = userCodable {
      return uc.toUser()
    }
    return nil
  }
  
  func fetchFriends(userID: Int64) async -> ([Friend], [FriendApply], [FriendApply]) {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchFriendsResult.self, from: data!)
    
    var friends: [Friend] = []
    for friend in json.friends {
      let f = friend.toFriend()
      friends.append(f)
    }
    
    var applyings: [FriendApply] = []
    var applyeds: [FriendApply] = []
    for apply in json.applyings {
      let u = apply.user
      applyings.append(FriendApply(user: u.toUser()))
    }
    for apply in json.applyeds {
      let u = apply.user
      applyeds.append(FriendApply(user: u.toUser()))
    }
    
    return (friends, applyings, applyeds)
  }
  
  func fetchRecommendFriends(userID: Int64) async -> [User] {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends/recommended")
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchRecommendUsersResult.self, from: data!)
    
    var users: [User] = []
    for user in json.users {
      let u = user.toUser()
      users.append(u)
    }
    
    return users
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
  
  func applyFriend(userID: Int, friend_user_id: Int) async {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends/\(friend_user_id)/apply")
    requestEntity.setPostRequest()
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
  }
  
  func acceptFriend(userID: Int, friend_user_id: Int) async {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends/\(friend_user_id)/accept")
    requestEntity.setPostRequest()
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
  }
  
  func blindFriend(userID: Int, friend_user_id: Int) async {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/users/\(userID)/friends/\(friend_user_id)/blind")
    requestEntity.setPostRequest()
    requestEntity.setToken()
    
    let (data, _) = await self.request(requestEntity: requestEntity)
  }
}
