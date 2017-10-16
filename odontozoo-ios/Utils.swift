//
//  Utils.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 30/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import Foundation

class Utils {
    
    static func encodeEmail(email: String) -> String? {
        let encodedEmail = String(email.characters.map {
            $0 == "." ? "," : $0
        })
        return encodedEmail
    }
    
    static func decodeEmail(email: String) -> String? {
        let decodedEmail = String(email.characters.map {
            $0 == "," ? "." : $0
        })
        return decodedEmail
    }
    
}
