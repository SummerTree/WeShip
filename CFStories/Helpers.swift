//
//  Helpers.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/19/20.
//

import SwiftUI

class HapticFeedback {
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    static func playSelection() -> Void {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
