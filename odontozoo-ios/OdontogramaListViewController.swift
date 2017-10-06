//
//  OdontogramaListViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 03/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase

class OdontogramaListViewController: UITableViewController {
    
    var odontogramas: [Odontograma] = []
    let ref = Database.database().reference(withPath: "odontogramasList")
    //var usuario: Usuario!
    var logouComSenha: Bool!

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (odontogramas.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.odontogramas.removeAll()
                
                for itens in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let itemList = itens.value as? [String: AnyObject]
                    
                    for item in itemList! {
                    
                        //let key = item.key
                        let odontogramaObject = item.value as? [String: AnyObject]
                        let id  = odontogramaObject?["id"]
                        let emailUsuario  = odontogramaObject?["emailUsuario"]
                        let nomeUsuario = odontogramaObject?["nomeUsuario"]
                        let nomeProprietario = odontogramaObject?["nomeProprietario"]
                        let nomeAnimal = odontogramaObject?["nomeAnimal"]
                        let familiaAnimal = odontogramaObject?["familiaAnimal"]
                        let racaAnimal = odontogramaObject?["racaAnimal"]
                        let idadeAnimal = odontogramaObject?["idadeAnimal"]
                        let sexoAnimal = odontogramaObject?["sexoAnimal"]
                        let dataCriacaoObject = odontogramaObject?["dataCriacao"]
                        let dataUltimaAlteracaoObject = odontogramaObject?["dataUltimaAlteracao"]
                        
                        let dataCriacaoTimestamp = dataCriacaoObject?["timestamp"] as? Double
                        let dataUltimaAlteracaoTimestamp = dataUltimaAlteracaoObject?["timestamp"] as? Double
                        
                        let dataCriacao = NSDate(timeIntervalSince1970: dataCriacaoTimestamp!)
                        let dataUltimaAlteracao = NSDate(timeIntervalSince1970: dataUltimaAlteracaoTimestamp!)
                        
                        let odontograma = Odontograma(
                            id: (id as! String?)!,
                            emailUsuario: (emailUsuario as! String?)!,
                            nomeUsuario: (nomeUsuario as! String?)!,
                            nomeProprietario: (nomeProprietario as! String?)!,
                            nomeAnimal: (nomeAnimal as! String?)!,
                            familiaAnimal: (familiaAnimal as! String?)!,
                            racaAnimal: (racaAnimal as! String?)!,
                            idadeAnimal: (idadeAnimal as! Int?)!,
                            sexoAnimal: (sexoAnimal as! String?)!,
                            dataCriacao: (dataCriacao),
                            dataUltimaAlteracao: (dataUltimaAlteracao)
                        )
                        
                        self.odontogramas.append(odontograma)
                        
                        
                    }
                    
                }
                
                self.tableView.reloadData()
            }
        })
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            /*self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()*/
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdontogramaCell", for: indexPath)
        
        let odontogramaItem = odontogramas[indexPath.row]
        
        //cell.nomeAnimalLabel.text = odontogramaItem.nomeAnimal
        //cell.racaAnimalLabel.text = odontogramaItem.racaAnimal
        cell.textLabel?.text = odontogramaItem.nomeAnimal
        cell.detailTextLabel?.text = odontogramaItem.racaAnimal
        
        return cell
    }


}
