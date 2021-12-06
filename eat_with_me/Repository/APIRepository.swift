//
//  APIRepository.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/25.
//

import Foundation
import SwiftUI
import Alamofire

//extension NSMutableData {
//  func append(_ string: String) {
//    if let data = string.data(using: .utf8) {
//      self.append(data)
//    }
//  }
//}

class RequestEntity {
  var request: URLRequest
//  private var httpBody = NSMutableData()
//  let boundary: String = UUID().uuidString
  
  init(url: String) {
    let req_url = URL(string: url)!
    self.request = URLRequest(url: req_url)
  }
  
  func setToken() {
    let token = UserDefaults.standard.string(forKey: "token")!
    self.request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
  }
  
  func setHeader(key: String, value: String) {
    self.request.addValue(value, forHTTPHeaderField: key)
  }
  
  func setPostRequest() {
    self.request.httpMethod = "POST"
  }
  
  func setJsonBody(json: String) {
    print("set json:", json)
    request.httpBody = json.data(using: .utf8)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  }
  
  func setBody(body: Data) {
    self.request.httpBody = body
  }
  
//  func addDataField(named name: String, data: Data, mimeType: String) {
//    self.request.httpBody = self.dataFormField(named: name, data: data, mimeType: mimeType)
//    self.request.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
//    self.request.httpMethod = "POST"
//  }
  
//  func genMultiPartRequest() {
//
//    self.request.httpMethod = "POST"
//    self.request.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
//
//    self.httpBody.append("--\(self.boundary)--")
//    self.request.httpBody = self.httpBody as Data
//  }
  
//  private func dataFormField(named name: String,
//                             data: Data,
//                             mimeType: String) -> Data {
//    var fieldData = Data()
//
//    fieldData.append("--\(self.boundary)\r\n".data(using: .utf8)!)
//    fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!)
//    fieldData.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
//    fieldData.append("\r\n".data(using: .utf8)!)
//    fieldData.append(data)
//    fieldData.append("\r\n".data(using: .utf8)!)
//    fieldData.append("--\(self.boundary)--".data(using: .utf8)!)
//
//    return fieldData
//  }
}

class APIRepository {
  
  func request(requestEntity: RequestEntity) async -> (Data?, URLResponse?) {
    do {
      let (data, response) = try await URLSession.shared.data(for: requestEntity.request)
      return (data, response)
    } catch {
      print("api fetch occur error:", error.localizedDescription)
      return (nil, nil)
    }
  }
  
  func uploadRequest(url: String, data: Data, name: String, token: String) -> UploadRequest {
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)",
        "Accept": "application/json",
//        "Content-Type": "multipart/form-data; boundary=fdafafaafa"
    ]
    return AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(data, withName: name, fileName: "hoge.jpeg", mimeType: "image/jpeg")
    }, to: url, headers: headers)
  }
}
