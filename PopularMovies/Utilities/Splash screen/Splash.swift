//
//  Splash.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        perform(#selector(showSplash), with: nil, afterDelay: 3)
    }
    
    @objc func showSplash()
    {
        performSegue(withIdentifier: "splash", sender:self)
    }

}
