import CoreGraphics
import Foundation
import SwiftUI

public extension CGFloat {
    static let quarterUnit: CGFloat = 2
    static let halfUnit: CGFloat = 4
    static let singleUnit: CGFloat = 8
    static let doubleUnit: CGFloat = 16
    static let tripleUnit: CGFloat = 24
    static let quadrupleUnit: CGFloat = 32
    static let quintupleUnit: CGFloat = 40
    static let sextupleUnit: CGFloat = 48
    static let septuple: CGFloat = 56
    static let octupleUnit: CGFloat = 64
}

public extension Double {
    static let disabledOpacity: Double = 0.5
}

public extension EdgeInsets {
    init(horizontal: CGFloat, vertical: CGFloat) {
        self = EdgeInsets(top: vertical,
                          leading: horizontal,
                          bottom: vertical,
                          trailing: horizontal)
    }

    init(top: CGFloat = .zero,
         bottom: CGFloat = .zero,
         horizontal: CGFloat = .zero)
    {
        self = EdgeInsets(top: top,
                          leading: horizontal,
                          bottom: bottom,
                          trailing: horizontal)
    }

    init(leading: CGFloat = .zero,
         trailing: CGFloat = .zero,
         vertical: CGFloat = .zero)
    {
        self = EdgeInsets(top: vertical,
                          leading: leading,
                          bottom: vertical,
                          trailing: trailing)
    }
}
