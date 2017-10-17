//
//  OdontogramaListViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 03/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase

var gUsuario: Usuario!
var gOdontogramaId: String!
var gImageId: String!
var gImageStorageId: String!

class OdontogramaListViewController: UITableViewController {
    
    var odontogramas: [Odontograma] = []
    var odontogramasRef = Database.database().reference(withPath: "odontogramasList/")
    let imagesRef = Database.database().reference(withPath: "odontogramaImagesList/")
    let usuarioRef = Database.database().reference(withPath: "usuarios")
    var usuario: Usuario!
//    var encodedEmail: String = ""
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
        
//        if (gUsuario != nil && gUsuario.email != "") {
//            encodedEmail = Utils.encodeEmail(email: gUsuario.email)!
//        }
        
        
        //odontogramasRef.child(encodedEmail).observe(DataEventType.value, with: { (snapshot) in
        odontogramasRef.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.odontogramas.removeAll()
                
                // usuarios
                for itens in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    // odontogramas
                    let itemList = itens.value as? [String: AnyObject]
                    
                    // odontogramas
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
                        
                        // Por enquanto, apenas os odontogramas do usuário autenticado carregam
                        // Se houver compartilhamento de odontogramas, carregará também os odontogramas de outros usuários
                        if (odontograma.emailUsuario == gUsuario.email) {
                            self.odontogramas.append(odontograma)
                        }
                    
                    }
                    
                }
                //self.odontogramas = self.odontogramas.sorted(by: { $0.nomeAnimal < $1.nomeAnimal })
                self.tableView.reloadData()
            }
        })
        
        //}
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            if (self.usuario == nil) {
                self.usuario = Usuario()
                self.usuario.email = (user?.email!)!
//                if (user?.displayName! != nil) {
//                    self.usuario.nome = (user?.displayName!)!
//                }
                //Pegar as outras variaveis de usuario no Firebase!
                let encodedEmail = Utils.encodeEmail(email: self.usuario.email)
                self.usuarioRef.child(encodedEmail!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    //self.usuario.nome = value?["name"] as! String
                    self.usuario.logouComSenha = value?["logouComSenha"] as? Bool ?? false
                    let dataCadastroTimestamp = value?["dataCadastro"] as! [String : Double]
                    self.usuario.dataCadastro = NSDate(timeIntervalSince1970: dataCadastroTimestamp["timestamp"]!/1000)
                })
                gUsuario = self.usuario
            }
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
    
    @IBAction func didTapAdd(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdd", sender: self)
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
            let tabBarC: UITabBarController = segue.destination as! UITabBarController
            let editView: OdontogramaDetailViewController = tabBarC.viewControllers?.first as! OdontogramaDetailViewController
//            let editView: OdontogramaDetailViewController = segue.destination as! OdontogramaDetailViewController
            editView.tituloView = "Novo Odontograma"
            editView.usuario = usuario!
        }
        if (segue.identifier == "segueToEdit") {
            let tabBarC: UITabBarController = segue.destination as! UITabBarController
            let editView: OdontogramaDetailViewController = tabBarC.viewControllers?.first as! OdontogramaDetailViewController
//            let editView: OdontogramaDetailViewController = segue.destination as! OdontogramaDetailViewController
            editView.tituloView = "Detalhes do Odontograma"
            editView.id = id!
            editView.emailUsuario = emailUsuario!
            editView.nomeUsuario = nomeUsuario!
            editView.nomeProprietario = nomeProprietario!
            editView.nomeAnimal = nomeAnimal!
            editView.familiaAnimal = familiaAnimal!
            editView.racaAnimal = racaAnimal!
            editView.idadeAnimal = idadeAnimal!
            editView.sexoAnimal = sexoAnimal!
            editView.dataCriacao = dataCriacao!
            editView.dataUltimaAlteracao = dataUltimaAlteracao!
            editView.usuario = usuario!
            
            gUsuario = usuario!
            gOdontogramaId = id!
            gImageId = nil
            gImageStorageId = nil
        }
    }

    
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
            self.odontogramasRef.child(Utils.encodeEmail(email: self.usuario.email)!+"/"+id).removeValue()
            self.odontogramas.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

}
