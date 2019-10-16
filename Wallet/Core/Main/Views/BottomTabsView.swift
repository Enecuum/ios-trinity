//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol BottomTabsDelegate: class {
    func changeToIndex(index: Int)
}

class BottomTabsView: UIView {
    private var buttonImages: [UIImage]!
    private var buttons: [UIButton]!
    private var selectorView: UIImageView!

    var textColor: UIColor = .black
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red

    weak var delegate: BottomTabsDelegate?

    public private(set) var selectedIndex: Int = 0

    convenience init(frame: CGRect, buttonImages: [UIImage]) {
        self.init(frame: frame)
        self.buttonImages = buttonImages
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }

    func setButtonImages(buttonImages: [UIImage]) {
        self.buttonImages = buttonImages
        self.updateView()
    }

    func setIndex(index: Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width / CGFloat(buttonImages.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }

    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorWidth = frame.width / CGFloat(buttonImages.count)
                let selectorPosition = frame.width / CGFloat(buttonImages.count) * CGFloat(buttonIndex) - selectorWidth
                selectedIndex = buttonIndex
                delegate?.changeToIndex(index: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

extension BottomTabsView {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        stack.semanticContentAttribute = .forceLeftToRight
    }

    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(buttonImages.count)
        selectorView = UIImageView(frame: CGRect(x: -selectorWidth, y: 0, width: self.frame.width * 1.5, height: self.frame.height))
        selectorView.image = R.image.bottomTabs.tab()!
        addSubview(selectorView)
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview() })

        for buttonImage in buttonImages {
            let button = UIButton(type: .custom)
            button.setImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(TabsView.buttonAction(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
}