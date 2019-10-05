//
// Created by Daria Kokareva on 05/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol ConfirmViewDelegate {
    func onConfirmClicked()
    func onCancelClicked()
}

class ConfirmViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var rejectButton: UIButton!
    @IBOutlet private weak var confirmButton: GradientButton!

    var confirmText: String?
    var delegate: ConfirmViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = confirmText

        addAttributedButton(rejectButton, image: R.image.icons.cross()!, string: "  NO", color: .red)
        addAttributedButton(confirmButton, image: R.image.icons.tick()!, string: "  YES", color: .white)
    }

    private func addAttributedButton(_ button: UIButton, image: UIImage, string: String, color: UIColor) {
        let font = R.font.ttNormsMedium(size: 13)!

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageSize = imageAttachment.image!.size
        imageAttachment.bounds = CGRect(x: CGFloat(0),
                                        y: (font.capHeight - imageSize.height) / 2,
                                        width: imageSize.width,
                                        height: imageSize.height)
        let imageString = NSMutableAttributedString(attachment: imageAttachment)

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style
        ]
        let label = NSMutableAttributedString(string: string, attributes: attributes)
        label.insert(imageString, at: 0)
        button.setAttributedTitle(label, for: .normal)
        button.setTitleColor(color, for: .normal)
    }

    @IBAction private func onCancelClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.onCancelClicked()
        }
    }

    @IBAction private func onConfirmClicked(_ sender: Any) {
        dismiss(animated: false) { [weak self] in
            self?.delegate?.onConfirmClicked()
        }
    }
}
