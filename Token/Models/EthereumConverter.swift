import UIKit
import SweetSwift

struct EthereumConverter {
    
    static let forcedLocale = "en_US"

    public static var latestExchangeRate = Decimal(10.0)

    public static let weisToEtherConstant = NSDecimalNumber(string: "1000000000000000000")

    public static var weisToEtherPowerOf10Constant: Int16 {
        get {
            return Int16(self.weisToEtherConstant.stringValue.length - 1)
        }
    }

    public static func ethereumValueString(forEther balance: NSDecimalNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 4
        numberFormatter.maximumFractionDigits = 4
        return "\(numberFormatter.string(from: balance)!) ETH"
    }

    public static func fiatValueString(forWei balance: NSDecimalNumber) -> String {
        
        let ether = balance.dividing(by: self.weisToEtherConstant)
        // Conversion from https://www.coinbase.com/charts
        let currentFiatConversion = NSDecimalNumber(decimal: self.latestExchangeRate)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: self.forcedLocale)

        let fiat: NSDecimalNumber = currentFiatConversion.multiplying(by: ether)

        return numberFormatter.string(from: fiat)!
    }
    
    public static func balanceAttributedString(forWei balance: NSDecimalNumber) -> NSAttributedString {
        let fiatText = "\(self.fiatValueString(forWei: balance)) \(Locale(identifier: self.forcedLocale).currencyCode!)"
        let etherText = self.ethereumValueString(forEther: balance.dividing(by: self.weisToEtherConstant).rounding(accordingToBehavior: NSDecimalNumber.weiRoundingBehavior))
        
        let text = fiatText + " · " + etherText
        let coloredPart = etherText
        let range = (text as NSString).range(of: coloredPart)
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: Theme.regular(size: 15)])
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Theme.greyTextColor, range: range)
        
        return attributedString
    }
    
}