//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
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

    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stakeSlider: Slider!
    @IBOutlet weak var stakeTextField: UITextField!

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

    private var buyTabsState: BuyTabsState = .none
    private var roiList: [Roi]? = nil

    struct Constants {
        static let balanceFromApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                               exponent: -10,
                                                                               isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)
        static let buyViewTag: Int = 2000
        static let acceptableStakeChars = "0123456789."

        static let roiCoefficient: Float = 1
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

        if Localization.isRTL() {
            stakeSlider.semanticContentAttribute = .forceRightToLeft
            stakeTextField.textAlignment = .right
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
        fetchRoi { [weak self] roiList in
            self?.roiList = roiList

            guard let self = self, let minStake = roiList?.first?.stake, let maxStake = roiList?.last?.stake else {
                return
            }

            let minStakeInt = NSDecimalNumber(value: minStake).multiplying(by: Constants.balanceFromApiMultiplier).intValue
            Defaults.setMinStake(minStakeInt)
            let maxStakeInt = NSDecimalNumber(value: maxStake).multiplying(by: Constants.balanceFromApiMultiplier).intValue
            Defaults.setMaxStake(maxStakeInt)
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
        /* var maxRoi = Roi(stake: 0, roi: 0)
         var maxPercent: UInt64 = 0
         roiList.forEach {
             let percent = ($0.roi - $0.stake) / $0.stake * 100
             if percent > maxPercent {
                 maxPercent = percent
                 maxRoi = $0
             }
         }*/

        guard let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() else {
            return
        }

        minLabel.text = R.string.untranslatable.min_value("\(minStake)")
        maxLabel.text = R.string.untranslatable.max_value("\(maxStake)")

        stakeTextField.text = "\(minStake)"

        stakeSlider.value = Float(minStake)
        stakeSlider.minimumValue = Float(minStake)
        stakeSlider.maximumValue = Float(maxStake)
    }

    private func updateRoiVerboseData(_ stake: Float) {
        guard let roiList = self.roiList, roiList.count > 1 else {
            return
        }
        let position = roiList.firstIndex { roi in
            let floatStake = NSDecimalNumber(value: roi.stake).multiplying(by: Constants.balanceFromApiMultiplier).floatValue
            return floatStake == stake
        }
        let uint64roi: UInt64 = {
            if position == nil {
                return 0
            } else {
                return roiList[position!].roi
            }
        }()

        let floatRoi = NSDecimalNumber(value: uint64roi).multiplying(by: Constants.balanceFromApiMultiplier).floatValue
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
        let percent = (profit / stake * 100 * Constants.roiCoefficient)
        let percentFormat = String(format: "%.2f", percent)
        return R.string.untranslatable.percent_value(percentFormat)
    }

    private func formProfitValue(_ profit: Float) -> String {
        let resultValue = profit * Constants.roiCoefficient
        return String(format: "%.2f", resultValue)
    }

    // MARK: - Stake Slider

    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() else {
            return
        }
        var newValue = Int(sender.value)
        if newValue < minStake {
            newValue = minStake
        } else if newValue > maxStake {
            newValue = maxStake
        }
        stakeTextField.text = "\(newValue)"
        updateRoiVerboseData(Float(newValue))
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
}

extension RoiViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let stakeString = stakeTextField.text, !stakeString.isEmpty, let stake = Int(stakeString),
           let minStake = Defaults.minStake(), let maxStake = Defaults.maxStake() {
            if stake < minStake {
                stakeTextField.text = "\(minStake)"
                stakeSlider.value = Float(minStake)
            } else if stake > maxStake {
                stakeTextField.text = "\(maxStake)"
                stakeSlider.value = Float(maxStake)
            } else {
                stakeSlider.value = Float(stake)
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
