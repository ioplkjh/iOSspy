//
//  ShepardModeTableViewCell.swift
//  dropbyke
//
//  Created by CookieDev on 8/4/15.
//  Copyright (c) 2015 CookieDev. All rights reserved.
//

import UIKit

@objc protocol ShepardModeTableViewCellDelegate : NSObjectProtocol {
    
    @objc optional func activeShepardMode(_ active: Bool)
    
}

open class ShepardModeTableViewCell: UITableViewCell {
    
    var delegate: ShepardModeTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shepardModeSwitcher: UISwitch!
    
    class var identifier: String { return String.className(self) }
    
//    required public init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setup()
//    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    @IBAction func activeShepardModeDidClicked(_ sender: UISwitch) {

//        DBUserManager.sharedManager().user.isActiveShepard = sender.on
//        
//        if ( self.delegate?.respondsToSelector(Selector("activeShepardMode:")) != nil ) {
//            self.delegate?.activeShepardMode!(sender.on)
//        }
        
    }

}
