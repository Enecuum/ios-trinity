//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class SendView: UIView, NibView {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var doneView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorners(corners: [.topRight, .topLeft], radius: 25)
    }

    @IBAction func onSendClicked(_ sender: Any) {
        confirmView.isHidden = false
    }

    @IBAction func onRejectClicked(_ sender: Any) {
        confirmView.isHidden = true
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        doneView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.confirmView.isHidden = true
            self?.doneView.isHidden = true
        })
    }
}
