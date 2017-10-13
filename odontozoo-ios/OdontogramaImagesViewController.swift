//
//  OdontogramaFotosViewControllerCollectionViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 13/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "OdontogramaImageCell"

class OdontogramaImagesViewController: UICollectionViewController {

    var imagens: [Imagem] = []
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let reuseIdentifier = "OdontogramaImageCell"
    fileprivate let imagem: Imagem! = nil
    fileprivate let itemsPerRow: CGFloat = 2
    let imagesRef = Database.database().reference(withPath: "odontogramaImagesList/")
    var usuario: Usuario!
    var odontogramaId: String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // imagens
        imagesRef.child(odontogramaId).observe(DataEventType.value, with: { (snapshot) in

            if snapshot.childrenCount > 0 {
                
                self.imagens.removeAll()
                
                // imagem
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    guard let imagemObject = item.value as? [String: Any] else { continue }
                    let id = imagemObject["id"] as? String
                    let storageId  = imagemObject["storageId"] as? String
                    let strUri = imagemObject["strUri"] as? String
                
                    let imagem = Imagem(
                        id: id!,
                        storageId: storageId!,
                        strUri: strUri!
                    )
                    
                    self.imagens.append(imagem)
                    
                }
            }
        })

    }
    
    // Quando a view começa a ser carregada
    override func loadView() {
        super.loadView()
        let detailTabController = self.tabBarController?.viewControllers?.first as! OdontogramaDetailViewController
        self.usuario = detailTabController.usuario
        self.odontogramaId = detailTabController.id
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: 50)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension OdontogramaImagesViewController {
    //1
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return imagens.count
//    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.imagens.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //1
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
//                                                      for: indexPath) as! ImageCollectionViewCell
//        //2
//        if let imagemOdontogramaUrl = imagens[indexPath.row].strUri {
//            let url = URL(string: imagemOdontogramaUrl)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                if (error != nil) {
//                    print(error)
//                    return
//                }
//                
//                DispatchQueue.main.async(execute: {
//                    cell.backgroundColor = UIColor.white
//                    cell.imageView?.image = UIImage(data: data!)
//                })
//                
//            })
//        }
//        
//        //cell.backgroundColor = UIColor.white
//        //3
//        //cell.imageView.image = imagemOdontograma.thumbnail
//        
//        return cell
//    }
    

}

extension OdontogramaImagesViewController : UICollectionViewDelegateFlowLayout {
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//private extension OdontogramaImagesViewController {
//    func imageByIndexPath(indexPath: IndexPath) -> FlickrPhoto {
//        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
//    }
//}
