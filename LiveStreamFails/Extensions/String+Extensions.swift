//
//  String+Extensions.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/25/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

extension String {
    enum HTMLTag: String {
        case video
        case title
        case thumbnail = "image"
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func parseHTML(tag: HTMLTag) -> String {
        return self.slice(from: "<meta property=\"og:\(tag.rawValue)\" content=", to: " />")?.replacingOccurrences(of: "\"", with: "") ?? ""
    }
    
}
