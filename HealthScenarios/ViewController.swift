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

class ViewController: UIViewController {
    var glucoseStore: GlucoseStore! = GlucoseStore()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if !IOS_SIMULATOR
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
        -> [(Double, Date)] {
        var results: [(Double, Date)] = []
        let duration = Double(endDelta - startDelta)
        let change = Double(endBg - startBg)
        
        for (i, delta) in (startDelta...endDelta).enumerated() where delta % 3 == 0 {
            results += [
                (easing(Double(i), Double(startBg), change, duration),
                 Date().addingTimeInterval(TimeInterval(delta * 60)))
            ]
        }
        return results
    }
    
    func jitter(_ data: [(Double, Date)]) -> [(Double, Date)] {
        return data.map { amt, date in
            // 1% jitter with multiplier between .99 to 1.01
            let delta: Double = 1.0 + (Double(arc4random_uniform(2)) - 1.0) / 100.0
            return (amt * delta, date)
        }
    }

    @IBAction func deleteBloodGlucoseData(_ sender: Any) {
        let glucoseType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!

        let predicate = HKQuery.predicateForSamples(
            withStart: Date.distantPast,
            end: Date.distantFuture,
            options: [])

        glucoseStore.healthStore.deleteObjects(of: glucoseType, predicate: predicate)
        { (success, count, error) -> Void in
            // TODO: Send this to the delegate
        }
    }
    
    @IBAction func highAndFallingBloodGlucose(_ sender: Any) {
        let rawValues = jitter(
            curve(-120, 110, -60 , 210, Easing.easeInOutCubic) +
            curve(-60, 210, -5, 160, Easing.easeInSine)
        )

        let glucoseStoreValues = rawValues.map { amt, date in
            return (
                HKQuantity(unit:HKUnit.milligramsPerDeciliterUnit(), doubleValue: amt),
                date,
                false)
        }
        
        deleteBloodGlucoseData(sender)
        glucoseStore.addGlucoseValues(glucoseStoreValues, device: nil) {
            (success, _, error) in
            if error != nil {
                self.abort((error?.localizedDescription)!)
            }
        }
        
        
    }
}

