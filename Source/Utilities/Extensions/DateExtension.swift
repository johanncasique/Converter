//
//  DateExtension.swift
//  Converter (iOS)
//
//  Created by johann casique on 8/12/22.
//

import Foundation

extension Date {
    enum DateFormat {
        case short
        case medium
        case long
        case full

        var formatString: String {
            switch self {
            case .short:
                return "dd/MM/yyyy"
            case .medium:
                return "dd MMM yyyy"
            case .long:
                return "dd MMMM yyyy"
            case .full:
                return "EEEE, dd MMMM yyyy"
            }
        }
    }

    func dateToString(format: DateFormat, locale: Locale? = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.formatString
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
}
