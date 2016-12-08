//
//  Bootstrap Button.swift
//  BootstrapBtn
//
//  Created by ZhangLiangZhi on 2016/11/15.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import UIKit

class BootstrapBtn: UIButton
{
    
    enum BootstrapBtnType: Int
    {
        case Default
        case Primary
        case Success
        case Info
        case Warning
        case Danger
    }
    
    var BtButtonType: BootstrapBtnType = .Default
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
    }
    
    init(frame: CGRect, btButtonType: BootstrapBtnType)
    {
        super.init(frame: frame);
        self.BtButtonType = btButtonType;
        self.setupButtons()
    }
    
    func setupButtons() -> Void
    {
        switch (BtButtonType)
        {
        case .Default:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor.white), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), for: UIControlState.normal)
            self.setTitleColor(UIColor(red: 77/255, green: 51/255, blue: 51/255, alpha: 1), for: UIControlState.highlighted)
            self.layer.borderColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        case .Primary:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 70/255, green: 138/255, blue: 207/255, alpha: 1)), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 51/255, green: 112/255, blue: 173/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.layer.borderColor = UIColor(red: 57/255, green: 125/255, blue: 194/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        case .Success:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 102/255, green: 184/255, blue: 77/255, alpha: 1)), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 78/255, green: 157/255, blue: 51/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.layer.borderColor = UIColor(red: 87/255, green: 174/255, blue: 58/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        case .Info:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 99/255, green: 191/255, blue: 225/255, alpha: 1)), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 63/255, green: 175/255, blue: 271/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.layer.borderColor = UIColor(red: 80/255, green: 183/255, blue: 221/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        case .Warning:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 238/255, green: 174/255, blue: 56/255, alpha: 1)), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 233/255, green: 152/255, blue: 0/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.layer.borderColor = UIColor(red: 235/255, green: 163/255, blue: 4/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        case .Danger:
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 212/255, green: 84/255, blue: 76/255, alpha: 1)), for: UIControlState.normal)
            self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 193/255, green: 49/255, blue: 38/255, alpha: 1)), for: UIControlState.highlighted)
            self.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.layer.borderColor = UIColor(red: 199/255, green: 63/255, blue: 52/255, alpha: 1).cgColor
            self.layer.borderWidth = 1.0
            break
        default:
            // self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor.white), for: UIControlState.normal)
            // self.setBackgroundImage(self.imageWithColorToButton(colorButton: UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)), for: UIControlState.highlighted)
            // self.setTitleColor(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), for: UIControlState.normal)
            // self.setTitleColor(UIColor(red: 77/255, green: 51/255, blue: 51/255, alpha: 1), for: UIControlState.highlighted)
            // self.layer.borderColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1).cgColor
            // self.layer.borderWidth = 1.0
            break
        }
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
    func imageWithColorToButton(colorButton: UIColor) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(colorButton.cgColor)
        context.fill(rect)
        let imageReturn: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return imageReturn
    }
}

