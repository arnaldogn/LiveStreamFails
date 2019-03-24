//
//  StreamService.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/25/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

protocol StreamServiceProtocol {
    func fetchVideoInfo(completion: @escaping ([Video])->())
}

class StreamService: StreamServiceProtocol {
    enum Constants {
        static let postsURL = "https://livestreamfails.com/post/"
        static let postsMax = 10
    }
    
    func fetchVideoInfo(completion: @escaping ([Video])->()) {
        let dispatchGroup = DispatchGroup()
        var streams = [Video]()
        for i in 1...Constants.postsMax {
            dispatchGroup.enter()
            if let url = URL(string: "\(Constants.postsURL)\(i)"),
                let content = try? String(contentsOf: url) {
                if let url = URL(string: content.parseHTML(tag: .video)),
                    let thumbnail = URL(string: content.parseHTML(tag: .thumbnail)) {
                    let video = Video(title: content.parseHTML(tag: .title),
                                      url: url,
                                      thumbnailURL: thumbnail)
                    streams.append(video)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                completion(streams)
            }
        }
    }
}
