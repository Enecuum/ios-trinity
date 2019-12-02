//
//  Created by Andrew Konovalskiy on 6/12/19.
//  Copyright © 2019 Heatherglade Ltd. All rights reserved.
//	

import UIKit

protocol NibView {
    func loadViewFromNib()
}

extension NibView where Self: UIView {
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                     UIView.AutoresizingMask.flexibleHeight]
            
            addSubview(view)
        }
    }
}
