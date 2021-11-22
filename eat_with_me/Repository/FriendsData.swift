//
//  FriendData.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/21.
//

import Foundation

// お菓子データ検索用クラス
class FriendsData: ObservableObject {
    // JSONのデータ構造
    struct ResultJson: Codable {
        // JSONのitem内のデータ構造
        struct UserCodable: Codable {
            // お菓子の名称
            let id: Int
            // 掲載URL
            let username: String
            // 画像URL
            let imageURL: String
        }
        // 複数要素
        let friends: [UserCodable]?
    }
    
    // お菓子のリスト（Identifiableプロトコル）
    @Published var friends: [User] = []
  var userID: Int
  
  init(userID: Int) {
    self.userID = userID
      self.fetchUser(userID: userID)
    }
    
    // Web API検索用メソッド 第一引数：keyword 検索したいワード
  func fetchUser(userID: Int) {
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://eat-with.herokuapp.com/api/users/\(userID)/friends") else {
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
                // 受け取ったJSONデータをパース（解析）して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                // print(json)
              
              if let friends = json.friends {
                self.friends.removeAll()
                // 取得しているお菓子の数だけ処理
                for user in friends {
                  let u = User(id: user.id, username: user.username, imageURL: user.imageURL)
                  // お菓子の配列へ追加
                  self.friends.append(u)
                  print(self.friends)
                }

              }
            } catch {
                // エラー処理
                 print("エラーが出ました")
            }
        })
        // ダウンロード開始
        task.resume()
    }
}

