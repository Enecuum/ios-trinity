//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol BottomTabsDelegate: class {
    func changeToIndex(index: Int)
}

class BottomTabsView: UIView {
    private var buttonImages: [UIImage]?
    private var buttons: [UIButton]?
    private var selectorView: UIView?

    weak var delegate: BottomTabsDelegate?

    public private(set) var selectedIndex: Int = 0

    convenience init(frame: CGRect, buttonImages: [UIImage]) {
        self.init(frame: frame)
        self.buttonImages = buttonImages
    }

    func setButtonImages(buttonImages: [UIImage]) {
        self.buttonImages = buttonImages
        updateView()
    }

    func setIndex(index: Int) {
        if let button = buttons?[index], let count = buttonImages?.count {
            selectedIndex = index
            let tabWidth = UIScreen.main.bounds.width / CGFloat(count)
            let selectorPosition = tabWidth * CGFloat(index - (count - 1))
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.selectorView?.frame.origin.x = selectorPosition
            }
        }
    }

    @objc func buttonAction(sender: UIButton) {
        guard let buttons = buttons else {
            return
        }
        for (buttonIndex, btn) in buttons.enumerated() {
            if btn == sender && selectedIndex != buttonIndex {
                let tabWidth = UIScreen.main.bounds.width / CGFloat(buttons.count)
                let selectorPosition = tabWidth * CGFloat(buttonIndex - (buttons.count - 1))
                selectedIndex = buttonIndex
                delegate?.changeToIndex(index: selectedIndex)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.selectorView?.frame.origin.x = selectorPosition
                }
            }
        }
    }
}

extension BottomTabsView {
    private func updateView() {
        createTabButtons()
        configSelectorView()
        configStackView()
    }

    private func configStackView() {
        guard let buttons = buttons else {
            return
        }
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.semanticContentAttribute = .forceLeftToRight
    }

    private func configSelectorView() {
        guard let tabsCount = buttons?.count else {
            return
        }
        let tabWidth = UIScreen.main.bounds.width / CGFloat(tabsCount)
        let sideTabWidth = tabWidth * CGFloat(tabsCount - 1)
        let sumWidth = sideTabWidth * 2 + tabWidth
        let selectorView = TabsBackgroundView(frame: CGRect(x: -sideTabWidth,
                                                            y: 0,
                                                            width: sumWidth,
                                                            height: frame.height))
        selectorView.leftTabWidthConstraint.constant = sideTabWidth
        selectorView.rightTabWidthConstraint.constant = sideTabWidth
        selectorView.stubWidthConstraint.constant = tabWidth
        addSubview(selectorView)
        self.selectorView = selectorView
    }

    private func createTabButtons() {
        guard let buttonImages = buttonImages else {
            return
        }
        buttons = [UIButton]()
        subviews.forEach({ $0.removeFromSuperview() })

        for buttonImage in buttonImages {
            let button = UIButton(type: .custom)
            button.setImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(TabsView.buttonAction(sender:)), for: .touchUpInside)
            buttons?.append(button)
        }
    }
}
