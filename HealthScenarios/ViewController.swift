//
//  ViewController.swift
//  HealthScenarios
//
//  Created by Bharat Mediratta on 11/24/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//

import UIKit
import HealthKit
import CarbKit
import GlucoseKit
import InsulinKit

struct Sample {
    var value: Double
    var date: Date
}

class ViewController: UIViewController {
    var glucoseStore: GlucoseStore! = GlucoseStore()
    var carbStore: CarbStore! = CarbStore()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if IOS_SIMULATOR
            carbStore.authorize() { (_, _) in }
            glucoseStore.authorize() { (_, _) in }
        #else
            abort("You can only run this on a simulator!")
        #endif
    }

    func abort(_ msg: String) {
        let alert = UIAlertController(title: "Fatal error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: {
            exit(0)
        })
    }
    
    func curve(_ startDelta: Int, _ startBg: Int,
               _ endDelta: Int, _ endBg: Int,
               _ easing: (Double, Double, Double, Double) -> Double)
        -> [Sample] {
        var results: [Sample] = []
        let duration = Double(endDelta - startDelta)
        let change = Double(endBg - startBg)
        
        for (i, delta) in (startDelta...endDelta).enumerated() where delta % 3 == 0 {
            results += [Sample(
                value: easing(Double(i), Double(startBg), change, duration),
                date: Date().addingTimeInterval(TimeInterval(delta * 60)))
            ]
        }
        return results
    }
    
    func jitter(_ data: [Sample]) -> [Sample] {
        return data.map { sample in
            // 1% jitter with multiplier between .99 to 1.01
            let delta: Double = 1.0 + (Double(arc4random_uniform(2)) - 1.0) / 100.0
            return Sample(value: sample.value * delta, date: sample.date)
        }
    }

    @IBAction func highAndFallingBloodGlucose(_ sender: Any) {
        let rawValues = jitter(
            curve(-180, 125, -120, 110, Easing.easeInOutQuad) +
            curve(-120, 110, -60 , 210, Easing.easeInOutCubic) +
            curve(-60, 210, -5, 160, Easing.easeInSine)
        )

        overwriteStoreValuesWith(rawValues)
    }

    @IBAction func lowAndRisingBloodGlucose(_ sender: Any) {
        let rawValues = jitter(
            curve(-180, 110, -120, 60, Easing.easeInOutQuad) +
            curve(-120, 60, -5, 95, Easing.easeInSine)
        )

        overwriteStoreValuesWith(rawValues)
    }

    func overwriteStoreValuesWith(_ rawValues: [Sample]) {
        let glucoseStoreValues = rawValues.map { sample in
            return (
                HKQuantity(unit:HKUnit.milligramsPerDeciliterUnit(), doubleValue: sample.value),
                sample.date,
                false)
        }
        
        glucoseStore.healthStore.deleteObjects(
            of: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
            predicate: HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date.distantFuture, options: [])) {
                (success, count, error) -> Void in
                // ignore for now
        }

        glucoseStore.addGlucoseValues(glucoseStoreValues, device: nil) {
            (success, _, error) in
            if error != nil {
                self.abort((error?.localizedDescription)!)
            }
        }

        carbStore.healthStore.deleteObjects(
            of: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
            predicate: HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date.distantFuture, options: [])) {
                (success, count, error) -> Void in
                // ignore for now
        }

        carbStore.addCarbEntry(
            NewCarbEntry(quantity: HKQuantity(unit: carbStore.preferredUnit, doubleValue: 50),
                         startDate: Date().addingTimeInterval(-120 * 60),
                         foodType: nil,
                         absorptionTime: carbStore.defaultAbsorptionTimes.medium)) {
            (success, _, error) in
        }
    }
}

