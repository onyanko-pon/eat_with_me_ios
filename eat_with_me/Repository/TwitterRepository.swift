//
//  TwitterRepository.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/06.
//

import Foundation
import Alamofire

struct FetchRequestTokenResult: Codable {
  let requestToken: String
  let requestSecret: String
}


class TwitterAPIRepository: APIRepository {
  
  func fetchRequestToken() async -> (String, String) {
    let requestEntity = RequestEntity(url: "https://eat-with.herokuapp.com/api/twitter/request_token")
    
    let (data, _) = await self.request(requestEntity: requestEntity)
    let decoder = JSONDecoder()
    let json = try! decoder.decode(FetchRequestTokenResult.self, from: data!)
    
    return (json.requestToken, json.requestSecret)
  }
}
