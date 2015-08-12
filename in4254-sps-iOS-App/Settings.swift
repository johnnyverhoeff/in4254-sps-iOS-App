//
//  Settings.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 26-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation
import ParticleFilterKit

class Settings {
    var url: String
    var port: String
    var connectionTimeout: Int
    
    var clientParams: ClientParameters
    
    var shouldRotate: Bool
    var shouldTrackProbableCell: Bool
    
    init() {
        url = "127.0.0.1"
        port = "1337"
        connectionTimeout = 5 // seconds
        
        clientParams = ClientParameters()
        
        shouldRotate = true
        shouldTrackProbableCell = true
    }
    
    init(settings: Settings) {
        self.url = settings.url
        self.port = settings.port
        
        self.connectionTimeout = settings.connectionTimeout
        
        self.clientParams = settings.clientParams
        
        self.shouldRotate = settings.shouldRotate
        self.shouldTrackProbableCell = settings.shouldTrackProbableCell
    }
    
    func connectionURL() -> String {
        return "\(self.url):\(self.port)"
    }
}