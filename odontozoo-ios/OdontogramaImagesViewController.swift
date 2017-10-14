//
//  OdontogramaFotosViewControllerCollectionViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 13/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import SDWebImage

class OdontogramaImagesViewController: UICollectionViewController {

    var imagens: [Imagem] = []
    fileprivate let sectionInsets = UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
    let reuseIdentifier = "OdontogramaImageCell"
    fileprivate let imagem: Imagem! = nil
    fileprivate let itemsPerRow: CGFloat = 2
    let imagesRef = Database.database().reference(withPath: "odontogramaImagesList/")
    var usuario: Usuario!
    var odontogramaId: String! = ""
    var imageWidth: CGFloat! = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //collectionView!.register(OdontogramaImageCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier,
                                                      for: indexPath) as! OdontogramaImageCollectionViewCell
        
        if let imagemOdontogramaUrl = imagens[indexPath.row].strUri {
            
            cell.imageView?.sd_setIndicatorStyle(.gray)
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            let imageStorage = Storage.storage().reference(forURL: imagemOdontogramaUrl)
            cell.imageView?.sd_setImage(with: imageStorage, placeholderImage: UIImage(named: "placeholder.png"))

        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "OdontogramaImagesHeaderView",
                                                                             for: indexPath) as! OdontogramaImagesHeaderView
            headerView.lblTitulo.text = "Imagens do Odontograma"
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    

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
        self.imageWidth = widthPerItem
        
        return CGSize(width: widthPerItem, height: 1.5*widthPerItem)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch UIDevice.current.orientation{
            case .portrait:
                return CGSize(width: UIScreen.main.bounds.width, height: 100)
            case .portraitUpsideDown:
                return CGSize(width: UIScreen.main.bounds.width, height: 100)
            case .landscapeLeft:
                return CGSize(width: UIScreen.main.bounds.width, height: 75)
            case .landscapeRight:
                return CGSize(width: UIScreen.main.bounds.width, height: 75)
            default:
                return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
        
    }
    
}

private extension OdontogramaImagesViewController {
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
