//
//  ViewControllerExtension.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 4/3/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func getController<T: UIViewController>(_ controller: T.Type, fromBoard boardName: String) -> T? {
        guard let controller = UIStoryboard(name: boardName, bundle: nil)
                   .instantiateViewController(withIdentifier: String(describing: T.self)) as? T
                   else { return nil }
        return controller
    }
    
    func navigate(to controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
