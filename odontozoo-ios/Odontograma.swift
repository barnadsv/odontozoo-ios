  //
//  Odontograma.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 29/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import Foundation
import Firebase

public struct Odontograma {
    
    //let key: String
    public var id: String
    public var emailUsuario: String
    public var nomeUsuario: String
    public var nomeProprietario: String
    public var nomeAnimal: String
    public var familiaAnimal: String
    public var racaAnimal: String
    public var idadeAnimal: Int
    public var sexoAnimal: String
    //    public var tipoOdontograma: String
    //    public var urlFotos: String[]
    public var dataCriacao: NSDate
    public var dataUltimaAlteracao: NSDate
    
    var ref: DatabaseReference!

    init(id: String, emailUsuario: String, nomeUsuario: String,
         nomeProprietario: String, nomeAnimal: String, familiaAnimal: String,
         racaAnimal: String, idadeAnimal: Int, sexoAnimal: String,
         dataCriacao: NSDate, dataUltimaAlteracao: NSDate) {
        self.id = id
        self.emailUsuario = emailUsuario
        self.nomeUsuario = nomeUsuario
        self.nomeProprietario = nomeProprietario
        self.nomeAnimal = nomeAnimal
        self.familiaAnimal = familiaAnimal
        self.racaAnimal = racaAnimal
        self.idadeAnimal = idadeAnimal
        self.sexoAnimal = sexoAnimal
        //self.tipoOdontograma = tipoOdontograma
        //self.urlFotos = urlFotos
        self.dataCriacao = dataCriacao
        self.dataUltimaAlteracao = dataUltimaAlteracao
    }
    
    
    /*init(snapshot: DataSnapshot) {
        //key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        emailUsuario = snapshotValue["emailUsuario"] as! String
        nomeUsuario = snapshotValue["nomeUsuario"] as! String
        nomeProprietario = snapshotValue["nomeProprietario"] as! String
        nomeAnimal = snapshotValue["nomeAnimal"] as! String
        familiaAnimal = snapshotValue["familiaAnimal"] as! String
        racaAnimal = snapshotValue["racaAnimal"] as! String
        idadeAnimal = snapshotValue["idadeAnimal"] as! Int
        sexoAnimal = snapshotValue["sexoAnimal"] as! String
        dataCriacao = snapshotValue["dataCriacao"] as! [String: NSDate]
        dataUltimaAlteracao = snapshotValue["dataUltimaAlteracao"] as! [String: NSDate]
        ref = snapshot.ref
    }*/

}
