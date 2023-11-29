//  VimeoRequest.swift
//  Created by Vladislav Soroka on 29.11.2023.

import Foundation
import RxSwift
import Alamofire
import Toolbox

enum VimeoRequest {

    struct list { let query: String }
    struct playURL { let uri: String }
    
}

extension VimeoRequest.list: BaseRequest {
    
    struct Response: Codable {
        let data: [VimeoVideo]
    }
    
    func response() async throws -> [VimeoVideo] {
        let res: Response = try await personilisedRequest(
            method: .get,
            path: "/videos",
            params: ["query": query],
            encoding: URLEncoding.queryString
        ).plainResponse()
        
        return res.data
    }
    
}

extension VimeoRequest.playURL: BaseRequest {
    
    struct Response: Codable {
        struct Request: Codable {
            struct Files: Codable {
                struct HLS: Codable {
                    struct CDNS: Codable {
                        struct Name: Codable {
                            let url: URL
                        }; let fastly_skyfire: Name
                    }; let cdns: CDNS
                }; let hls: HLS
            }; let files: Files
        }; let request: Request
    }
    
    func response() async throws -> URL {
        let id = uri.split(separator: "/").last ?? ""
        
        let res: Response = try await personilisedRequest(
            baseURL: "https://player.vimeo.com",
            method: .get,
            path: "/video/\(id)/config"
        ).plainResponse()
        
        return res.request.files.hls.cdns.fastly_skyfire.url
    }
    
}
