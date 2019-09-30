//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
//import Nantes

class AboutViewController: UIViewController {

    //@IBOutlet weak var websiteLable: NantesLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    //    websiteLable.delegate = self
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

//extension AboutViewController: NantesLabelDelegate {
   /* func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        print("Tapped link: \(link)")
        if let url = URL(string: "https://www.hackingwithswift.com") {
            UIApplication.shared.open(link)
        }
    }*/
//}
