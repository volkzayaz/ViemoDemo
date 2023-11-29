//
//  AppState.swift
//  VimeoDemo
//
//  Created by Vladislav Soroka on 29.11.2023.
//

import Foundation
import Toolbox

var appStore: App.Store<AppState>!

struct AppState: Equatable, Codable, UserDefaultsStorable, AppStateT {
    ///we can save vimewoVideos in cache here
    
    static var `default`: AppState {
        return .init()
    }
}
