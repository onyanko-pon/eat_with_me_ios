//
//  UserRepository.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/20.
//

import Foundation

// お菓子データ検索用クラス
class UserData: ObservableObject {
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
        let user: UserCodable?
    }
    
    // お菓子のリスト（Identifiableプロトコル）
    @Published var user: User? = nil
    var userID: Int
  
    init(userID: Int) {
      self.userID = userID
      fetchUser(userID: userID)
    }
    
    // Web API検索用メソッド 第一引数：keyword 検索したいワード
  func fetchUser(userID: Int) {
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://eat-with.herokuapp.com/api/users/\(userID)") else {
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
              
              if let item = json.user {
                self.user = User(id: item.id, username: item.username, imageURL: item.imageURL)
                print(self.user)
              }
                // お菓子の情報が取得できているか確認
//                if let item = json.user {
//                    // お菓子のリストを初期化
//                  if let imageData = try? Data(contentsOf: item.imageURL),
//                  let image = UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal) {
//                    self.user = User(id: item.id, username: item.username, image: image)
//                    print(self.user)
//                  }
//
//                }
            } catch {
                // エラー処理
                 print("エラーが出ました")
            }
        })
        // ダウンロード開始
        task.resume()
    }
}
