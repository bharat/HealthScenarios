//
//  HKUnit.swift
//  HealthScenarios
//
//  Created by Bharat Mediratta on 6/15/18.
//  Copyright © 2018 Bharat Mediratta. All rights reserved.
//

import Foundation
import HealthKit

extension HKUnit {
    static func milligramsPerDeciliter() -> HKUnit {
        return HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))
    }
}
