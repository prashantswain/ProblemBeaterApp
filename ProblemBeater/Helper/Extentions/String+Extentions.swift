//
//  String+Extentions.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 31/05/25.
//
import Foundation

extension String {
    //MARK:  Email_Validation
    func isValidEmail() -> Bool {
        let emailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$" as String
        let emailText = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        let isValid  = emailText.evaluate(with: self) as Bool
        return isValid
    }
    
    //MARK:  Password_Validation
    func isPasswordValidate() -> Bool {
        let passwordRegix = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\W_]).{8,}$"
        let passwordText  = NSPredicate(format:"SELF MATCHES %@",passwordRegix)
        return !(passwordText.evaluate(with:self))
    }
    
    //MARK:  Mobile_Validation
    func isNumber() -> Bool {
        if self.isStringEmpty() { return false }
        let phoneRegex = "^\\d{10,10}$"
        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phoneText.evaluate(with: self) as Bool
        return isValid
    }
    
    //MARK: To Check Whether String is empty
    func isStringEmpty() -> Bool {
        return self.stringByTrimmingWhiteSpace().count == 0 ? true : false
    }
    
    //MARK: Get string by removing White Space
    func stringByTrimmingWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    //MARK: Get string by removing White Space & New Line
    func stringByTrimmingWhiteSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    //MARK: Convet any type to string
    static func toString(_ message: Any?) -> String {
        guard let strMessage = message as? String else {
            guard let doubleValue = message as? Double else {
                guard let intValue = message as? Int else {
                    guard let int64Value = message as? Int64 else{
                        return ""
                    }
                    return String(int64Value)
                }
                return String(intValue)
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 4
            formatter.minimumIntegerDigits = 1
            guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                return ""
            }
            return formattedNumber
        }
        return strMessage.stringByTrimmingWhiteSpaceAndNewLine()
    }
}
