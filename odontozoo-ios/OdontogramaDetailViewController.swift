//
//  OdontogramaDetailViewContoller.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 07/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase
//import DateTimePicker

class OdontogramaDetailViewController: UIViewController {

    let odontogramasRef = Database.database().reference(withPath: "odontogramasList/")
    let usuarioRef = Database.database().reference(withPath: "usuarios")
    
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
    public var dataCriacao: NSDate? = nil
    public var dataUltimaAlteracao: NSDate? = nil
    public var usuario: Usuario!
    
    public var tituloView: String = "Detalhes do Odontograma"

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var txtNomeAnimal: UITextField!
    @IBOutlet weak var txtRacaAnimal: UITextField!
    @IBOutlet weak var txtNomeProprietario: UITextField!
    @IBOutlet weak var lblDataCriacao: UILabel!
    @IBOutlet weak var lblDataUltimaAlteracao: UILabel!
    
    @IBOutlet weak var segFamiliaAnimal: UISegmentedControl!
    @IBAction func changeFamiliaAnimal(_ sender: Any) {
        switch segFamiliaAnimal.selectedSegmentIndex {
            case 0:
                familiaAnimal = "Canina";
            case 1:
                familiaAnimal = "Felina";
            default:
                break
        }
    }
    
    
    @IBOutlet weak var segSexoAnimal: UISegmentedControl!
    
    @IBAction func changeSexoAnimal(_ sender: Any) {
        switch segSexoAnimal.selectedSegmentIndex {
            case 0:
                sexoAnimal = "Macho";
            case 1:
                sexoAnimal = "Fêmea";
            default:
                break
        }
    }
    
    @IBOutlet weak var lblIdadeAnimal: UILabel!
    @IBOutlet weak var stepperIdadeAnimal: UIStepper!
    @IBAction func changeIdadeAnimal(_ sender: Any) {
        idadeAnimal = Int(stepperIdadeAnimal.value)
        lblIdadeAnimal.text = String(idadeAnimal)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        
        let txtMensagem = camposValidos()
        if (txtMensagem == "") {
            let key = id == "" ? self.odontogramasRef.child(Utils.encodeEmail(email: self.usuario.email)).childByAutoId().key : id
        
            //let key = self.odontogramasRef.child(Utils.encodeEmail(email: self.usuario.email)).childByAutoId().key
        
            if (dataCriacao == nil) {
                dataCriacao = NSDate()
            }
            dataUltimaAlteracao = NSDate()
            
            let novoOdontograma = ["dataCriacao": ["timestamp": Double(Int((dataCriacao?.timeIntervalSince1970)!*1000))],
                               "dataUltimaAlteracao": ["timestamp":Double(Int((dataUltimaAlteracao?.timeIntervalSince1970)!*1000))],
                               "emailUsuario": self.usuario.email,
                               "familiaAnimal": self.familiaAnimal,
                               "id": key,
                               "idadeAnimal": self.idadeAnimal,
                               "nomeAnimal": self.nomeAnimal,
                               "nomeProprietario": self.nomeProprietario,
                               "nomeUsuario": self.usuario.nome,
                               "racaAnimal": self.racaAnimal,
                               "sexoAnimal": self.sexoAnimal
                               ] as [String : Any]
        
            let childUpdate = ["\(Utils.encodeEmail(email: self.usuario.email))/\(key)": novoOdontograma]
            odontogramasRef.updateChildValues(childUpdate)
            self.showAlert("Odontograma salvo com sucesso!")
        } else {
            self.showAlert(txtMensagem)
        }
        //let key = ref.child("posts").childByAutoId().key
        //let post = ["uid": userID,
        //            "author": username,
        //            "title": title,
        //            "body": body]
        //let childUpdates = ["/posts/\(key)": post,
        //                    "/user-posts/\(userID)/\(key)/": post]
        //ref.updateChildValues(childUpdates)
        
    }
    
    func camposValidos() -> String {
        var txtMensagemErro = ""
        switch segFamiliaAnimal.selectedSegmentIndex {
            case 0:
                familiaAnimal = "Canina";
            case 1:
                familiaAnimal = "Felina";
            default:
                break
        }
        if (Int(lblIdadeAnimal.text!)! > 0) {
            idadeAnimal = Int(lblIdadeAnimal.text!)!
        } else {
            txtMensagemErro = "A idade do animal não pode ser 0."
        }
        if (txtNomeAnimal.text != "") {
            nomeAnimal = txtNomeAnimal.text!
        } else {
            txtMensagemErro = "O nome do animal é obrigatório."
        }
        if (txtNomeProprietario.text != "") {
            nomeProprietario = txtNomeProprietario.text!
        } else {
            txtMensagemErro = "O nome do proprietário é obrigatório."
        }
        if (txtRacaAnimal.text != "") {
            racaAnimal = txtRacaAnimal.text!
        } else {
            txtMensagemErro = "A raça do animal é obrigatória."
        }
        switch segSexoAnimal.selectedSegmentIndex {
            case 0:
                sexoAnimal = "Macho";
            case 1:
                sexoAnimal = "Fêmea";
            default:
                break
        }
        return txtMensagemErro
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitulo.text = tituloView
        txtNomeAnimal.text  = nomeAnimal
        switch familiaAnimal {
            case "Canina":
                segFamiliaAnimal.selectedSegmentIndex = 0
            case "Felina":
                segFamiliaAnimal.selectedSegmentIndex = 1
            default:
                break
        }
        txtRacaAnimal.text = racaAnimal
        switch sexoAnimal {
            case "Macho":
                segSexoAnimal.selectedSegmentIndex = 0
            case "Fêmea":
                segSexoAnimal.selectedSegmentIndex = 1
            default:
                break
        }
        lblIdadeAnimal.text = String(idadeAnimal)
        stepperIdadeAnimal.value = Double(idadeAnimal)
        
//        stepperIdadeAnimal.value = Double(idadeAnimal)
//        stepperIdadeAnimal.autorepeat = true
        txtNomeProprietario.text = nomeProprietario
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm:ss")
        if (dataCriacao == nil) {
            lblDataCriacao.text = "-"
        } else {
            lblDataCriacao.text = dateFormatter.string(from: dataCriacao! as Date)
        }
        if (dataUltimaAlteracao == nil) {
            lblDataUltimaAlteracao.text = "-"
        } else {
            lblDataUltimaAlteracao.text = dateFormatter.string(from: dataUltimaAlteracao! as Date)
        }
        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Odontozoo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
