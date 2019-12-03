//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol CustomSegmentedControlDelegate: class {
    func changeToIndex(index: Int)
}

class TabsView: UIView {
    private var buttonTitles: [String]?
    private var buttons: [UIButton]?
    private var selectorView: UIImageView?

    var textColor: UIColor = .black
    var selectorTextColor: UIColor = .red

    weak var delegate: CustomSegmentedControlDelegate?

    override var bounds: CGRect {
        didSet {
            updateView()
        }
    }

    public private(set) var selectedIndex: Int = 0

    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }

    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }

    func setIndex(index: Int) {
        buttons?.forEach({ $0.setTitleColor(textColor, for: .normal) })
        if let button = buttons?[index], let count = buttons?.count {
            selectedIndex = index
            button.setTitleColor(selectorTextColor, for: .normal)
            let selectorPosition = frame.width / CGFloat(count) * CGFloat(index)
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
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.changeToIndex(index: selectedIndex)
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.selectorView?.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

extension TabsView {
    private func updateView() {
        createButton()
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
        let selectorWidth = frame.width / CGFloat(tabsCount)
        let selectorView = UIImageView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selectorView.image = R.image.tabs.transfer()!
        addSubview(selectorView)
        self.selectorView = selectorView
    }

    private func createButton() {
        guard let buttonTitles = buttonTitles else {
            return
        }

        buttons = [UIButton]()
        subviews.forEach({ $0.removeFromSuperview() })

        let ttNormsFont = R.font.ttNormsMedium(size: 13)
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = ttNormsFont
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(TabsView.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons?.append(button)
        }
        buttons?[0].setTitleColor(selectorTextColor, for: .normal)
    }
}
