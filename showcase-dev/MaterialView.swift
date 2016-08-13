//
//  MaterialView.swift
//  showcase-dev
//
//  Created by Cex on 08/08/2016.
//  Copyright © 2016 newmediatechies. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0.0, 3.0)  //so shadow shows behind
    }

}
