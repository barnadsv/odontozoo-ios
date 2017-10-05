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
        
        /*ref.observe(.childAdded, with: { (snapshot) -> Void in
            self.odontogramas.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.odontogramas.count-1)], with: UITableViewRowAnimation.automatic)
        })*/
        
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.odontogramas.removeAll()
                
                //iterating through all the values
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
                    //getting values
                    
                }
                
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
        
        /*ref.queryOrdered(byChild: "nomeAnimal").observe(.childAdded, with: { snapshot in
            
            let getData = snapshot.value as? [String:AnyObject]
            
            let odontograma = Odontograma(
                id: getData["id"],
                emailUsuario: getData["emailUsuario"],
                nomeUsuario: getData["nomeUsuario"],
                nomeProprietario: getData["nomeProprietario"],
                nomeAnimal: getData["nomeAnimal"],
                familiaAnimal: getData["familiaAnimal"],
                racaAnimal: getData["racaAnimal"],
                idadeAnimal: getData["idadeAnimal"],
                sexoAnimal: getData["sexoAnimal"],
                dataCriacao: getData["dataCriacao"],
                dataUltimaAlteracao: getData["dataUltimaAlteracao"]
            )
            self.odontogramas.append(odontograma)
            self.tableView.reloadData()
        })*/
        /*ref.queryOrdered(byChild: "nomeAnimal").observe(.childAdded, with: { snapshot in
            
            let item = snapshot.value as? DataSnapshot
            //for item in snapshot.children {
                //let odontogramaItem = Odontograma()
                //odontogramaItem.id = item
            let odontogramaItem = Odontograma(snapshot: item!)
                self.odontogramas.append(odontogramaItem)
            //}
            
            //self.odontogramas = novosOdontogramas
            self.tableView.reloadData()
        })

        
        ref.queryOrdered(byChild: "nomeAnimal").observe(.value, with: { snapshot in
            var novosOdontogramas: [Odontograma] = []
            
            for item in snapshot.children {
                //let odontogramaItem = Odontograma()
                //odontogramaItem.id = item
                let odontogramaItem = Odontograma(snapshot: item as! DataSnapshot)
                novosOdontogramas.append(odontogramaItem)
            }
            
            self.odontogramas = novosOdontogramas
            self.tableView.reloadData()
        })*/
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            /*self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()*/
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdontogramaCell", for: indexPath)
        let odontogramaItem = odontogramas[indexPath.row]
        
        cell.textLabel?.text = odontogramaItem.nomeAnimal
        cell.detailTextLabel?.text = odontogramaItem.racaAnimal
        
        //toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }


}
