//
//  Usuario.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 29/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import Foundation
import Firebase

public struct Usuario {
    
    public var email: String
    public var nome: String
    //public var dataCadastro: [String : Double]
    public var dataCadastro: NSDate
    public var logouComSenha: Bool
    
    init(email: String, nome: String, dataCadastro: NSDate, logouComSenha: Bool) {
        self.email = email
        self.nome = nome
        self.dataCadastro = dataCadastro
        self.logouComSenha = logouComSenha
    }
    
    init() {
        self.email = ""
        self.nome = ""
        self.dataCadastro = NSDate()
        self.logouComSenha = false
    }
    
}
