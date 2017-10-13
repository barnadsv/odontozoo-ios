//
//  Imagem.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 29/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import Foundation

public struct Imagem {
    
    public var id: String
    public var storageId: String
    public var strUri: String?
    
    init(id: String, storageId: String, strUri: String) {
        self.id = id
        self.storageId = storageId
        self.strUri = strUri
    }
    
}
