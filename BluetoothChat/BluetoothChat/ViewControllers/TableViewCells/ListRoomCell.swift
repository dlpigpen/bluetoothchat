//
//  ListRoomCell.swift
//  BluetoothChat
//
//  Created by Duc Nguyen on 11/18/15.
//  Copyright © 2015 Duc Nguyen. All rights reserved.
//

import UIKit

class ListRoomCell: UITableViewCell {


    @IBOutlet weak var paddingLeftLbName: NSLayoutConstraint!
    @IBOutlet weak var imgRead: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLastMsg: UILabel!
    @IBOutlet weak var lbLastTime: UILabel!
    var idDevice: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var value:CGFloat = 1.0
        if UIScreen.mainScreen().respondsToSelector(Selector("scale")) == true && UIScreen.mainScreen().scale == 2.0
        {
            value = 0.5
        }
        else{
            value = 0.33
        }
    
        let separatorView:UIView! = UIView(frame:FRAME(62,y: self.contentView.height - value,w: ScreenSize.SCREEN_WIDTH - 62.0,h: value))
        if self.tag == 1
        {
            
        }
        separatorView.layer.borderColor = RGBA(127, g: 127, b: 127, c: 0.4).CGColor
        separatorView.layer.borderWidth = value
        
        self.contentView.addSubview(separatorView)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



class StateConnectionCell: UITableViewCell {
    
    @IBOutlet weak var btAction: UIButton!
     @IBOutlet weak var imgScan: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var value:CGFloat = 1.0
        if UIScreen.mainScreen().respondsToSelector(Selector("scale")) == true && UIScreen.mainScreen().scale == 2.0
        {
            value = 0.5
        }
        else{
            value = 0.33
        }
        
        let separatorView:UIView! = UIView(frame:FRAME(0,y: self.contentView.height - value,w: ScreenSize.SCREEN_WIDTH ,h: value))

        separatorView.layer.borderColor = RGBA(127, g: 127, b: 127, c: 0.4).CGColor
        separatorView.layer.borderWidth = value
        
        self.contentView.addSubview(separatorView)
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
