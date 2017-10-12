//
//  OdontogramaTabBarController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 08/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit

class OdontogramaTabBarController: UITabBarController {
    
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

    
//    open var viewControllers: [UIViewController]?
//    
//    // If the number of view controllers is greater than the number displayable by a tab bar, a "More" navigation controller will automatically be shown.
//    // The "More" navigation controller will not be returned by -viewControllers, but it may be returned by -selectedViewController.
//    open func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool)
//    
//    
//    unowned(unsafe) open var selectedViewController: UIViewController? // This may return the "More" navigation controller if it exists.
//    
//    open var selectedIndex: Int
//    
//    
//    open var moreNavigationController: UINavigationController { get } // Returns the "More" navigation controller, creating it if it does not already exist.
//    
//    open var customizableViewControllers: [UIViewController]? // If non-nil, then the "More" view will include an "Edit" button that displays customization UI for the specified controllers. By default, all view controllers are customizable.
//    
//    
//    @available(iOS 3.0, *)
//    open var tabBar: UITabBar { get } // Provided for -[UIActionSheet showFromTabBar:]. Attempting to modify the contents of the tab bar directly will throw an exception.
//    
//    
//    weak open var delegate: UITabBarControllerDelegate?
//    
}
