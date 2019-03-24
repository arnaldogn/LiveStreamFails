//
//  StreamViewModel.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/25/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

protocol StreamViewModelProtocol {
    func loadStreams(completion: @escaping ([Video])->())
}

class StreamViewModel: StreamViewModelProtocol {
    let service: StreamServiceProtocol
    
    init(service: StreamServiceProtocol) {
        self.service = service
    }
    
    func loadStreams(completion: @escaping ([Video])->()) {
        service.fetchVideoInfo(completion: completion)
    }
}
