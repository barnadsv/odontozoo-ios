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
    let ref = Database.database().reference(withPath: "odontogramasList/")
    let usuarioRef = Database.database().reference(withPath: "usuarios")
    var usuario: Usuario!
    //var logouComSenha: Bool!
    
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
                        
                        let dataCriacao = NSDate(timeIntervalSince1970: dataCriacaoTimestamp!/1000)
                        let dataUltimaAlteracao = NSDate(timeIntervalSince1970: dataUltimaAlteracaoTimestamp!/1000)
                        
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
            if (self.usuario == nil) {
                self.usuario = Usuario()
                self.usuario.email = (user?.email!)!
                self.usuario.nome = (user?.displayName!)!
                //Pegar as outras variaveis de usuario no Firebase!
                let encodedEmail = Utils.encodeEmail(email: self.usuario.email)
                self.usuarioRef.child(encodedEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    self.usuario.logouComSenha = value?["logouComSenha"] as? Bool ?? false
                    let dataCadastroTimestamp = value?["dataCadastro"] as! [String : Double]
                    self.usuario.dataCadastro = NSDate(timeIntervalSince1970: dataCadastroTimestamp["timestamp"]!/1000)
                })
            }
            //self.usuario = Usuario(authData: user)
            /*let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()*/
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdontogramaCell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm:ss")
        
        let odontogramaItem = odontogramas[indexPath.row]
        
        cell.textLabel?.text = odontogramaItem.nomeAnimal
        cell.detailTextLabel?.text = "Data de Criação: " + dateFormatter.string(from: odontogramaItem.dataCriacao as Date)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let id = odontogramas[indexPath.row].id
            self.ref.child(Utils.encodeEmail(email: self.usuario.email)+"/"+id).removeValue()
            odontogramas.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }



}
