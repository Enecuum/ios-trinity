//
// Created by Daria Kokareva on 05/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate {
    func onConfirmClicked()
    func onCancelClicked()
}

class AlertViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var rejectButton: UIButton!
    @IBOutlet private weak var confirmButton: GradientButton!

    var titleText: String?
    var text: String?
    var cancelText: String?
    var confirmText: String?

    var hasButtonIcons: Bool = true

    var delegate: AlertViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.titleLabel?.numberOfLines = 0;
        confirmButton.titleLabel?.lineBreakMode = .byWordWrapping;
        rejectButton.titleLabel?.numberOfLines = 0;
        rejectButton.titleLabel?.lineBreakMode = .byWordWrapping;

        titleLabel.text = titleText ?? R.string.localizable.are_you_sure.localized()
        textLabel.text = text
        let confirm = confirmText ?? R.string.localizable.yes.localized().uppercased()
        let cancel = cancelText ?? R.string.localizable.no.localized().uppercased()

        if hasButtonIcons {
            addAttributedButton(rejectButton,
                                image: R.image.icons.cross()!,
                                string: cancel,
                                color: .red)
            addAttributedButton(confirmButton,
                                image: R.image.icons.tick()!,
                                string: confirm,
                                color: .white)
        } else {
            rejectButton.setTitle(cancel, for: .normal)
            confirmButton.setTitle(confirm, for: .normal)
        }
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
        //TODO: messed offset
        let label = NSMutableAttributedString(string: "  \(string)", attributes: attributes)
        label.insert(imageString, at: 0)
        button.setAttributedTitle(label, for: .normal)
        button.setTitleColor(color, for: .normal)
    }

    // MARK: - IBActions

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
