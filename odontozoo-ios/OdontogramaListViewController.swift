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
    let odontogramasRef = Database.database().reference(withPath: "odontogramasList/")
    let imagesRef = Database.database().reference(withPath: "odontogramaImagesList/")
    let usuarioRef = Database.database().reference(withPath: "usuarios")
    var usuario: Usuario!
    //var logouComSenha: Bool!
    var id: String?
    var emailUsuario: String?
    var nomeUsuario: String?
    var nomeProprietario: String?
    var nomeAnimal: String?
    var familiaAnimal: String?
    var racaAnimal: String?
    var idadeAnimal: Int?
    var sexoAnimal: String?
    //    var tipoOdontograma: String
    //    var urlFotos: String[]
    var dataCriacao: NSDate?
    var dataUltimaAlteracao: NSDate?
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (odontogramas.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        odontogramasRef.observe(DataEventType.value, with: { (snapshot) in
            
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        print("Row: \(row)")
        
        id = self.odontogramas[row].id
        emailUsuario = self.odontogramas[row].emailUsuario
        nomeUsuario = self.odontogramas[row].nomeUsuario
        nomeProprietario = self.odontogramas[row].nomeProprietario
        nomeAnimal = self.odontogramas[row].nomeAnimal
        familiaAnimal = self.odontogramas[row].familiaAnimal
        racaAnimal = self.odontogramas[row].racaAnimal
        idadeAnimal = self.odontogramas[row].idadeAnimal
        sexoAnimal = self.odontogramas[row].sexoAnimal
        dataCriacao = self.odontogramas[row].dataCriacao
        dataUltimaAlteracao = self.odontogramas[row].dataUltimaAlteracao

        performSegue(withIdentifier: "segueToEdit", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToAdd") {
            let editView: OdontogramaDetailViewController = segue.destination as! OdontogramaDetailViewController
            editView.tituloView = "Novo Odontograma"
        }
        if (segue.identifier == "segueToEdit") {
            let detailViewController = segue.destination as! OdontogramaDetailViewController
            detailViewController.tituloView = "Detalhes do Odontograma"
            detailViewController.id = id!
            detailViewController.nomeAnimal = nomeAnimal!
            detailViewController.emailUsuario = emailUsuario!
            detailViewController.nomeUsuario = nomeUsuario!
            detailViewController.nomeProprietario = nomeProprietario!
            detailViewController.nomeAnimal = nomeAnimal!
            detailViewController.familiaAnimal = familiaAnimal!
            detailViewController.racaAnimal = racaAnimal!
            detailViewController.idadeAnimal = idadeAnimal!
            detailViewController.sexoAnimal = sexoAnimal!
            detailViewController.dataCriacao = dataCriacao!
            detailViewController.dataUltimaAlteracao = dataUltimaAlteracao!
        }
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "segueToAdd") {
//            let editView: OdontogramaDetailViewController = segue.destination as! OdontogramaDetailViewController
//            editView.tituloView = "Novo Odontograma"
//        }
//        if (segue.identifier == "segueToEdit") {
//            /*let tabBarC: UITabBarController = segue.destination as! UITabBarController
//            let editView: OdontogramaDetailViewController = tabBarC.viewControllers?.first as! OdontogramaDetailViewController*/
//            let editView: OdontogramaDetailViewController = segue.destination as! OdontogramaDetailViewController
//            editView.tituloView = "Detalhes do Odontograma"
//            editView.emailUsuario = emailUsuario!
//            editView.nomeUsuario = nomeUsuario!
//            editView.nomeProprietario = nomeProprietario!
//            editView.nomeAnimal = self.nomeAnimal!
//            editView.familiaAnimal = familiaAnimal!
//            editView.racaAnimal = racaAnimal!
//            editView.idadeAnimal = idadeAnimal!
//            editView.sexoAnimal = sexoAnimal!
//            editView.dataCriacao = dataCriacao!
//            editView.dataUltimaAlteracao = dataUltimaAlteracao!
//            
//            /*let odontogramaTabBarController = segue.destination as! OdontogramaTabBarController
//            odontogramaTabBarController.id = id!
//            odontogramaTabBarController.emailUsuario = emailUsuario!
//            odontogramaTabBarController.nomeUsuario = nomeUsuario!
//            odontogramaTabBarController.nomeProprietario = nomeProprietario!
//            odontogramaTabBarController.nomeAnimal = nomeAnimal!
//            odontogramaTabBarController.familiaAnimal = familiaAnimal!
//            odontogramaTabBarController.racaAnimal = racaAnimal!
//            odontogramaTabBarController.idadeAnimal = idadeAnimal!
//            odontogramaTabBarController.sexoAnimal = sexoAnimal!
//            odontogramaTabBarController.dataCriacao = dataCriacao!
//            odontogramaTabBarController.dataUltimaAlteracao = dataUltimaAlteracao!*/
//        }
//    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let id = odontogramas[indexPath.row].id
            
            imagesRef.child(id).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    //let key = snap.key
                    let value = snap.value as? [String: AnyObject]
                    let storageId = value?["storageId"] as! String
                    let imagesStorage = Storage.storage().reference(forURL: "gs://odontozoo-345a7.appspot.com/odontogramaImagesList/" + id + "/" + storageId)
                    imagesStorage.delete { error in
                        if error != nil {
                            // Uh-oh, an error occurred!
                        } else {
                            
                        }
                    }
                }
            })
            self.imagesRef.child(id).removeValue()
            self.odontogramasRef.child(Utils.encodeEmail(email: self.usuario.email)+"/"+id).removeValue()
            self.odontogramas.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
    }

}
