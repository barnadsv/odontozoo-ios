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
    var selectedIndexPath: IndexPath = [0, 0]
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    let reuseIdentifier = "OdontogramaImageCell"
    fileprivate let imagem: Imagem! = nil
    fileprivate let itemsPerRow: CGFloat = 2
    let imagesRef = Database.database().reference(withPath: "odontogramaImagesList/")
    var usuario: Usuario!
    var odontogramaId: String! = ""
    var imageWidth: CGFloat! = 200.0
    
//    @IBAction func didTapCameraButton(_ sender: Any) {
//        performSegue(withIdentifier: "segueToCamera", sender: nil)
//    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        //        //myViewController.title = "My App"
        //        let nav = UINavigationController(rootViewController: self)
        //        nav.navigationBar.barTintColor = UIColor.red
        //        nav.navigationBar.tintColor = UIColor.white
        ////        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStuff))
        //        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        //        add.tintColor = UIColor.white
        //        self.navigationItem.rightBarButtonItem = add
        
        // self.title = "Imagens do Odontograma"
        
//        let navigationController = UINavigationController(rootViewController: self);
//        let navigationBar = navigationController.navigationBar
//        navigationBar.tintColor = UIColor.black
        //        let navigationItem = navigationBar.items?[0] as UINavigationItem
        //
        //        let cameraButton = navigationItem. ?[1] as UIBarButtonItem
        //
        //        self.navigationItem.title = "Imagens do Odontograma"
        //        navigationItem?.title = "Imagens do Odontograma"
        //        let navigationItem = UINavigationItem()
        //        navigationItem.title = "Imagens do Odontograma"
        //
        //        let rightButton = UIBarButtonItem(title: "Camera", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        //
        //        navigationItem.rightBarButtonItem = rightButton
        //
        //        navigationBar.items = [navigationItem]
        
        
        
        
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "segueToImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToImage") {
            let selectedCell = collectionView?.cellForItem(at: selectedIndexPath) as! OdontogramaImageCollectionViewCell
            let cameraViewController: OdontogramaCameraViewController = segue.destination as! OdontogramaCameraViewController
            cameraViewController.odontogramaImage = selectedCell.imageView.image
            cameraViewController.ehCamera = false
        }
        
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
        
        return CGSize(width: widthPerItem, height: 1.33*widthPerItem)
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
                return CGSize(width: UIScreen.main.bounds.width, height: 110)
            case .portraitUpsideDown:
                return CGSize(width: UIScreen.main.bounds.width, height: 110)
            case .landscapeLeft:
                return CGSize(width: UIScreen.main.bounds.width, height: 80)
            case .landscapeRight:
                return CGSize(width: UIScreen.main.bounds.width, height: 80)
            default:
                return CGSize(width: UIScreen.main.bounds.width, height: 110)
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
