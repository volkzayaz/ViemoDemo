//
//  VimeoVideo.swift
//  VimeoDemo
//
//  Created by Vladislav Soroka on 29.11.2023.
//

import Foundation

struct VimeoVideo: Codable, Equatable {
    
    let uri: String
    let url: URL
    let name: String
    
    struct Thumbnail: Codable, Equatable {
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "base_link"
        }
        
    }; let thumbnail: Thumbnail
    
    enum CodingKeys: String, CodingKey {
        case uri
        case url = "player_embed_url"
        case name
        case thumbnail = "pictures"
    }
    
}
