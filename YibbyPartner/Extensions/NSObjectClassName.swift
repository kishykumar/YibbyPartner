import Foundation

extension NSObject {
    func readableClassName() -> String {
        return type(of: self).readableClassName()
    }

    class func readableClassName() -> String {
        let classString = NSStringFromClass(self)
        let range = classString.range(of: ".", options: NSString.CompareOptions.caseInsensitive, range: Range<String.Index>(classString.startIndex..<classString.endIndex), locale: nil)

        return range.map { classString.substring(from: $0.upperBound) } ?? classString
    }
}
