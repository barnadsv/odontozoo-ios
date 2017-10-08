//
//  OdontogramaDetailViewContoller.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 07/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
//import DateTimePicker

class OdontogramaDetailViewController: UIViewController {

    public var id: String = ""
    public var emailUsuario: String = ""
    public var nomeUsuario: String = ""
    public var nomeProprietario: String = ""
    public var nomeAnimal: String = ""
    public var familiaAnimal: String = ""
    public var racaAnimal: String = ""
    public var idadeAnimal: Int = 0
    public var sexoAnimal: String = ""
    //    public var tipoOdontograma: String
    //    public var urlFotos: String[]
    public var dataCriacao: NSDate = NSDate()
    public var dataUltimaAlteracao: NSDate = NSDate()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
