//
//  EventDetailData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/21.
//

import Foundation
import CloudKit

// お菓子データ検索用クラス
class EventDetailData: ObservableObject {
    // JSONのデータ構造
  struct ResultJson: Codable {
    struct UserCodable: Codable {
      let id: Int
      let username: String
      let imageURL: String
    }
      // JSONのitem内のデータ構造
    struct EventCodable: Codable {
        // お菓子の名称
      let id: Int
      let title: String
      let description: String
      let start_datetime: Date
      let end_datetime: Date
      let organize_user_id: Int
      let latitude: Double
      let longitude: Double
      let organize_user: UserCodable
      let join_users: [UserCodable]
    }
    // 複数要素
    let event: EventCodable?
  }
  
  struct PostBody: Codable {
    let user_id: Int
  }

  // お菓子のリスト（Identifiableプロトコル）
  @Published var event: Event? = nil
  let userID: Int
  init(userID: Int) {
    self.userID = userID
  }
    // Web API検索用メソッド 第一引数：keyword 検索したいワード
  func fetchEvent(eventID: Int) {
    // リクエストURLの組み立て
    guard let req_url = URL(string: "https://eat-with.herokuapp.com/api/events/\(eventID)") else {
        return
    }
    print(req_url)
    
    // リクエストに必要な情報を生成
    let req = URLRequest(url: req_url)
    // データ転送を管理するためのセッションを生成
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    // リクエストをタスクとして登録
    let task = session.dataTask(with: req, completionHandler: {
      (data, response ,error) in
        // セッションを終了
      session.finishTasksAndInvalidate()
      // do try catch エラーハンドリング
      do {
        // JSONDecoderのインスタンス取得
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        print("パースはじめ")
        // 受け取ったJSONデータをパース（解析）して格納
        let json = try decoder.decode(ResultJson.self, from: data!)
        print("パース終わり")
        print(json)
      
        if let event = json.event {
          // 取得しているお菓子の数だけ処理
          
          let u = User(id: event.organize_user.id, username: event.organize_user.username, imageURL: event.organize_user.imageURL)
          
          var participants: [User] = []
          
          for joinUser in event.join_users {
            participants.append(User(id: joinUser.id, username: joinUser.username, imageURL: joinUser.imageURL))
          }
          
          let e = Event(
            id: event.id,
            title: event.title,
            description: event.description,
            startDatetime: event.start_datetime,
            endDatetime: event.end_datetime,
            latitude: event.latitude,
            longitude: event.longitude,
            imageURL: "https://pics.prcm.jp/f3ff3de4e8133/82924626/png/82924626.png",
            organizeUser: u,
            participants: participants
          )
          self.event = e
        }
      } catch {
            // エラー処理
        print("Event取得でエラーが出ました")
      }
    })
    // ダウンロード開始
    task.resume()
  }
  
  func joinEvent(eventID: Int) {
    let url = URL(string: "https://eat-with.herokuapp.com/api/events/\(eventID)/join")!
    var request = URLRequest(url: url)
    let postBody = PostBody(user_id: self.userID)
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    
    do {
      let data = try encoder.encode(postBody)
      let jsonstr:String = String(data: data, encoding: .utf8)!
      print(jsonstr)
      request.httpBody = jsonstr.data(using: .utf8)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpMethod = "POST"      // Postリクエストを送る(このコードがないとGetリクエストになる)
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        print("イベント参加")
        print(data)
        self.fetchEvent(eventID: eventID)
      }
      task.resume()
    } catch {
      print("エラー")
      print(error.localizedDescription)
    }
  }
}


