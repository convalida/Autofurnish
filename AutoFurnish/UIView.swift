//
//  UIView.swift
//  AutoFurnish
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 tutist. All rights reserved.
//

import Foundation
import UIKit

/**
 An object that manages the content for a rectangular area on the screen.
 */
extension UIView {
    
    /**
 Set safe area of top anchor to top edge of the view’s frame. Rajat ji please check this. Different return types depending on different version of iOS
 */
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    /**
     Set safe area of bottom anchor to bottom edge of the view’s frame. Different return types depending on different version of iOS
     */
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    // Left Anchor
    /**
     Set safe area of left anchor to left edge of the view’s frame. Different return types depending on different version of iOS
     */
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    // Right Anchor
    /**
     Set safe area of right anchor to left edge of the view’s frame. Different return types depending on different version of iOS
     */
    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
}
