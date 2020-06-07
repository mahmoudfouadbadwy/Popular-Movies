//
//  CustomMenu.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/7/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit

extension Home{
    func setupCollectionMenu()
    {
     
        blackView = UIView()
        collectionMenu = {
            let layout = UICollectionViewFlowLayout()
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = UIColor.black
            cv.tag = 1
            return cv
        }()
        collectionMenu.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionMenu.delegate = self
        collectionMenu.dataSource = self

    }
    func setupMenuLabel(name:String ,x:CGFloat,y:CGFloat,width:CGFloat,hight:CGFloat) -> UILabel
    {
            let label = UILabel()
            label.text = name
            label.textColor = UIColor.white
            label.frame = CGRect(x:x,y:y,width:width,height:hight)
            return label
    }
    
    
    func setupMenuImage(name:String, x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)-> UIImageView
    {
            let image = UIImageView()
            image.backgroundColor = UIColor.black
            image.image = UIImage.init(named:name)
            image.frame = CGRect(x: x, y: y, width: width, height: height)
            return image
    }
    
    // show navigation menu
    func showMenu()
    {
        if let window = UIApplication.shared.keyWindow
        {
            // view
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action:#selector(handledismiss)))
            blackView.backgroundColor = UIColor(white: 0, alpha:0.5)
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // collection
            window.addSubview(collectionMenu)
            collectionMenu.frame = CGRect(x: 0, y: 0 ,width: window.frame.width, height:0)
            collectionMenu.alpha = 1
            
            //  animation
            UIView.animate(withDuration:0.5) {
                self.blackView.alpha = 1
                self.collectionMenu.frame = CGRect(x: 0, y: 0 , width: window.frame.width, height: 110)
            }
        }
    }
    
    // dismis navigation menu
    @objc func handledismiss()
    {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionMenu.frame = CGRect(x:0,y:0,width: self.collectionMenu.frame.width, height:0)
        }
    }

}
