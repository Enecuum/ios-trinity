//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import AVFoundation

class RoiViewController: UIViewController {

    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var amountInUsdLabel: UILabel!

    @IBOutlet weak var buyTabsView: UIView!
    @IBOutlet weak var byCardButton: GradientButton!
    @IBOutlet weak var exchangesButton: GradientButton!
    @IBOutlet weak var swapButton: GradientButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stakeSlider: Slider!
    @IBOutlet weak var sliderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stakeTextField: UITextField!
    @IBOutlet weak var stakeTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var referralSwitch: UISwitch!
    @IBOutlet weak var referralLabel: UILabel!

    @IBOutlet weak var roiTitleLabel: UILabel!
    @IBOutlet weak var roiDailyLabel: UILabel!
    @IBOutlet weak var roiWeeklyLabel: UILabel!
    @IBOutlet weak var roiYearLabel: UILabel!

    @IBOutlet weak var roiDailyPercentLabel: UILabel!
    @IBOutlet weak var roiWeeklyPercentLabel: UILabel!
    @IBOutlet weak var roiYearPercentLabel: UILabel!

    @IBOutlet weak var roiDailyValueLabel: UILabel!
    @IBOutlet weak var roiWeeklyValueLabel: UILabel!
    @IBOutlet weak var roiYearValueLabel: UILabel!

    @IBOutlet weak var bottomTabsPlaceholder: UIView!

    private struct RoiFloat: Codable {
        let stake: Float
        let roi: Float
    }

    private var buyTabsState: BuyTabsState = .none
    private var roiList: [RoiFloat]? = nil

    private var roiCoefficient: Float {
        get {
            referralSwitch.isOn ? 1.1 : 1
        }
    }

    struct Constants {
        static let balanceFromApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                               exponent: -10,
                                                                               isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)
        static let buyViewTag: Int = 2000
        static let acceptableStakeChars = "0123456789."

        static let daysInWeek: Float = 7
        static let daysInYear: Float = 365
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissKeyBoardOnTouchOutside()

        balanceTitleLabel.text = R.string.localizable.balance.localized()

        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
        if let usdRate = Defaults.usdRate() {
            self.updateUsdRate(usdRate)
        }
        balanceAmountLabel.isUserInteractionEnabled = true
        let balanceTap = UITapGestureRecognizer(target: self, action: #selector(balanceTapped))
        balanceAmountLabel.addGestureRecognizer(balanceTap)

        byCardButton.setTitle(R.string.localizable.pay_by_card.localized(), for: .normal)
        byCardButton.titleLabel?.numberOfLines = 0
        byCardButton.titleLabel?.textAlignment = .center
        exchangesButton.setTitle(R.string.localizable.buy_on_exchange.localized(), for: .normal)
        exchangesButton.titleLabel?.numberOfLines = 0
        exchangesButton.titleLabel?.textAlignment = .center
        swapButton.setTitle(R.string.localizable.swap.localized(), for: .normal)
        swapButton.titleLabel?.numberOfLines = 0
        swapButton.titleLabel?.textAlignment = .center

        updateForBuyTabState()

        titleLabel.text = R.string.localizable.roi_alert.localized()

        stakeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        roiTitleLabel.text = R.string.untranslatable.roi()
        roiDailyLabel.text = R.string.localizable.roi_daily.localized()
        roiWeeklyLabel.text = R.string.localizable.roi_weekly.localized()
        roiYearLabel.text = R.string.localizable.roi_annual.localized()
        updateRoiSliderData()
        updateRoiVerboseData(Float(stakeSlider.value))

        referralSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        referralSwitch.onTintColor = UIColor(red: 0 / 255, green: 209 / 255, blue: 1, alpha: 1)
        referralSwitch.isOn = Defaults.isIAmReferrer()
        referralLabel.text = R.string.localizable.referral_tick.localized()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleReferralSwitch))
        referralLabel.addGestureRecognizer(tap)

        if Localization.isRTL() {
            stakeSlider.semanticContentAttribute = .forceRightToLeft
            stakeTextField.textAlignment = .right
        }

        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            tuneForSE()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchBalance { [weak self] amount in
            if let amount = amount {
                Defaults.saveBalance(amount)
                self?.balanceAmountLabel.text = "\(amount)"
            }
        }
        fetchStats()
        fetchRoi { [weak self] roiListUint64 in
            self?.roiList = roiListUint64?.map({ roiUint64 in
                let stakeFloat: Float = NSDecimalNumber(value: roiUint64.stake).multiplying(by: Constants.balanceFromApiMultiplier).floatValue
                let roiFloat: Float = NSDecimalNumber(value: roiUint64.roi).multiplying(by: Constants.balanceFromApiMultiplier).floatValue
                return RoiFloat(stake: stakeFloat, roi: roiFloat)
            })

            guard let self = self, let minStake = self.roiList?.first?.stake, let maxStake = self.roiList?.last?.stake else {
                return
            }

            Defaults.setMinStake(minStake)
            Defaults.setMaxStake(maxStake)
            self.updateRoiSliderData()
            self.updateRoiVerboseData(self.stakeSlider.value)
        }
    }

    // MARK: - Public methods

    func resetBalance() {
        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
    }

    // MARK: - Private methods

    private func updateUsdRate(_ usdRate: String) {
        let usdCourse = NSDecimalNumber(string: usdRate)
        self.usdRateLabel.text = CurrencyFormat.asUsdString(usdCourse)

        if let balance = Defaults.getBalance() {
            let usdAmount = usdCourse.multiplying(by: balance)
            self.amountInUsdLabel.text = Formatter.decimalString(usdAmount, fractionDigits: 2)
        }
    }

    private func showBuyView(tab: Int) {
        if let buyView = view.viewWithTag(Constants.buyViewTag) {
            buyView.removeFromSuperview()
        }
        let rect = CGRect(x: buyTabsView.frame.origin.x,
                          y: buyTabsView.frame.origin.y,
                          width: buyTabsView.frame.width,
                          height: bottomTabsPlaceholder.frame.origin.y - buyTabsView.frame.origin.y - BuyNativeView.Constants.bottomPadding)
        let buyView = buyTabsState == .byCard ? BuyNativeView(frame: rect) : BuyInExchangeView(frame: rect)
        buyView.tag = Constants.buyViewTag
        self.view.insertSubview(buyView, belowSubview: buyTabsView)
    }

    private func hideBuyView() {
        buyTabsView.backgroundColor = .clear
        byCardButton.gradientIsVisible = true
        exchangesButton.gradientIsVisible = true
        swapButton.gradientIsVisible = true
        if let buyView = view.viewWithTag(Constants.buyViewTag) {
            buyView.removeFromSuperview()
        }
    }

    private func updateForBuyTabState() {
        switch (buyTabsState) {
        case .none, .swap:
            hideBuyView()
        case .byCard:
            buyTabsView.backgroundColor = Palette.buyTabsBackground
            byCardButton.gradientIsVisible = true
            exchangesButton.gradientIsVisible = false
            swapButton.gradientIsVisible = false
            showBuyView(tab: 0)
        case .inExchange:
            buyTabsView.backgroundColor = Palette.buyTabsBackground
            byCardButton.gradientIsVisible = false
            exchangesButton.gradientIsVisible = true
            swapButton.gradientIsVisible = false
            showBuyView(tab: 1)
        }
    }

    private func updateRoiSliderData() {
        guard let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() else {
            return
        }

        minLabel.text = R.string.untranslatable.min_value("\(Int(minStake))")
        maxLabel.text = R.string.untranslatable.max_value("\(Int(maxStake))")

        stakeTextField.text = "\(Int(minStake))"

        stakeSlider.value = Float(minStake)
        stakeSlider.minimumValue = Float(minStake)
        stakeSlider.maximumValue = Float(maxStake)
    }

    private func updateRoiVerboseData(_ stake: Float) {
        guard let roiList = self.roiList, roiList.count > 1 else {
            return
        }
        let position = roiList.firstIndex { roi in
            Float(roi.stake) == stake
        }
        let floatRoi: Float = {
            if position == nil {
                let nextRoiIndex = roiList.firstIndex { roiFloat in
                    roiFloat.stake > stake
                }
                guard let nextIndex = nextRoiIndex, nextIndex > 0 else {
                    return 0
                }
                let roiPrev = roiList[nextIndex - 1]
                let roiNext = roiList[nextIndex]
                return (roiNext.roi - roiPrev.roi) * (stake - roiPrev.stake) / (roiNext.stake - roiPrev.stake) + roiPrev.roi
            } else {
                return Float(roiList[position!].roi)
            }
        }()

        let dailyProfit = floatRoi - stake
        let weeklyProfit = dailyProfit * Constants.daysInWeek
        let annualProfit = dailyProfit * Constants.daysInYear

        roiDailyPercentLabel.text = formProfitPercent(dailyProfit, stake)
        roiDailyValueLabel.text = formProfitValue(dailyProfit)

        roiWeeklyPercentLabel.text = formProfitPercent(weeklyProfit, stake)
        roiWeeklyValueLabel.text = formProfitValue(weeklyProfit)

        roiYearPercentLabel.text = formProfitPercent(annualProfit, stake)
        roiYearValueLabel.text = formProfitValue(annualProfit)
    }

    private func formProfitPercent(_ profit: Float, _ stake: Float) -> String {
        String(format: "%.2f", profit / stake * 100 * roiCoefficient)
    }

    private func formProfitValue(_ profit: Float) -> String {
        String(format: "%.2f", profit * roiCoefficient)
    }

    @objc private func toggleReferralSwitch() {
        referralSwitch.setOn(!referralSwitch.isOn, animated: true)
    }

    // MARK: - Stake Slider

    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() else {
            return
        }
        var newValue = sender.value
        if newValue < minStake {
            newValue = minStake
        } else if newValue > maxStake {
            newValue = maxStake
        }
        stakeTextField.text = "\(Int(newValue))"
        updateRoiVerboseData(newValue)
    }

    @objc private func balanceTapped() {
        if let text = balanceAmountLabel.text {
            let balanceValue = NSDecimalNumber(string: text)
            let balanceInt = balanceValue.intValue
            stakeSlider.setValue(Float(balanceInt), animated: true)
            stakeTextField.text = "\(balanceInt)"
        }
    }

    // MARK: - Server

    private func fetchBalance(completion: @escaping (NSDecimalNumber?) -> Void) {
        ApiClient.balance(id: CryptoHelper.getPublicKey()) { result in
            switch result {
            case .success(let balanceAmount):
                debugPrint(balanceAmount)
                let amount = NSDecimalNumber(value: balanceAmount.amount).multiplying(by: Constants.balanceFromApiMultiplier)
                completion(amount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    private func fetchStats() {
        ApiClient.stats { [weak self] result in
            switch result {
            case .success(let statistics):
                debugPrint(statistics)

                Defaults.setUsdRate(statistics.cg_usd)
                self?.updateUsdRate(statistics.cg_usd)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchRoi(completion: @escaping ([Roi]?) -> Void) {
        ApiClient.roiList { result in
            switch result {
            case .success(let roiList):
                debugPrint(roiList)
                completion(roiList)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    // MARK: - Size Tuning

    private func tuneForSE() {
        balanceTitleLabel.font = balanceTitleLabel.font.withSize(15)
        balanceAmountLabel.font = balanceTitleLabel.font.withSize(15)
        amountInUsdLabel.font = balanceTitleLabel.font.withSize(15)

        titleTopConstraint.constant = 12
        sliderTopConstraint.constant = 30
        stakeTopConstraint.constant = 8
    }

    // MARK: - IB Actions

    @IBAction func byCardTabClicked() {
        buyTabsState = buyTabsState == .byCard ? .none : .byCard
        updateForBuyTabState()
    }

    @IBAction func exchangesTabClicked() {
        buyTabsState = buyTabsState == .inExchange ? .none : .inExchange
        updateForBuyTabState()
    }

    @IBAction func swapTabClicked() {
        buyTabsState = .swap
        updateForBuyTabState()
    }

    @IBAction func referralSwitchChanged(_ sender: Any) {
        updateRoiVerboseData(Float(stakeSlider.value))
        Defaults.setIAmReferrer(referrer: referralSwitch.isOn)
    }
}

extension RoiViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let stakeString = stakeTextField.text, !stakeString.isEmpty, let stake = Float(stakeString),
           let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() {
            if stake < minStake {
                stakeTextField.text = "\(Int(minStake))"
                stakeSlider.value = minStake
            } else if stake > maxStake {
                stakeTextField.text = "\(Int(maxStake))"
                stakeSlider.value = maxStake
            } else {
                stakeSlider.value = stake
            }
        } else {
            textField.text = "\(Defaults.maxStake() ?? 0)"
            stakeSlider.value = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet: CharacterSet = NSCharacterSet(charactersIn: Constants.acceptableStakeChars).inverted
        let filtered = string.components(separatedBy: charSet).joined(separator: "")
        if (string != filtered) {
            return false
        } else {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 10
        }
    }
}
