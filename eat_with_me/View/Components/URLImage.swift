//
//  URLImage.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/11/18.
//

import Foundation

import SwiftUI

class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil

    func downloadImage(url: String) {

        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
}

struct URLImage: View {

    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()

    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
            }
        } else {
            return VStack {
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
            }
        }
    }
}
