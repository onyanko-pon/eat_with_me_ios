//
//  FriendShareSheet.swift
//  eat_with_me
//
//  Created by 丸山司 on 2021/12/15.
//

import SwiftUI

struct FriendShareSheet: UIViewControllerRepresentable {
    @Binding var items: [String]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems: [Any] = items

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)

        return controller
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}
