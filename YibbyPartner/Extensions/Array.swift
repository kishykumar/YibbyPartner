//
//  Array.swift
//  Ello
//
//  Created by Gordon Fontenot on 3/26/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

extension Array {
    func safeValue(_ index: Int) -> Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : .none
    }

    func find(_ test: (_ el: Element) -> Bool) -> Element? {
        for ob in self {
            if test(ob) {
                return ob
            }
        }
        return nil
    }

    func any(_ test: (_ el: Element) -> Bool) -> Bool {
        for ob in self {
            if test(ob) {
                return true
            }
        }
        return false
    }

    func all(_ test: (_ el: Element) -> Bool) -> Bool {
        for ob in self {
            if !test(ob) {
                return false
            }
        }
        return true
    }
}

extension Array where Element: Equatable {
    func unique() -> [Element] {
        return self.reduce([Element]()) { elements, el in
            if elements.contains(el) {
                return elements
            }
            return elements + [el]
        }
    }

}
