//
//  ViewController.swift
//  AppleADay
//
//  Created by Alexander on 29/12/16.
//  Copyright (c) 2016 Zero to Hero. All rights reserved.
// kcal data is from here — http://1trenirovka.com/uprazhneniya/v-domashnih-usloviyah/skolko-kalorij-szhigaetsya-pri-fizicheskih-nagruzkah.html
// useful - https://www.raywenderlich.com/159019/healthkit-tutorial-swift-getting-started

import UIKit
import HealthKit
import AudioToolbox.AudioServices

@available(iOS 10.0, *)
class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    
    @IBOutlet weak var stairsClimbingLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var MeditationLabel: UILabel!
    
    let healthStore = HKHealthStore()
    
    var timersList = [String: Date]()
    var timers2List = [String: Timer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getHealthKitPermission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions

    @IBAction func setDefaultLabelText(_ sender: UIButton)
    {
        switch sender.currentTitle! {
        case "espresso":
            saveEspresso()
        case "water":
            saveWater()
        case "tea":
            saveTea()
        case "apple":
            saveApple()
        case "granat":
            saveGranat()
        case "multiVitaminMuscleTech":
            saveMultiVitaminMuscleTech()
        case "weiderProtein":
            saveWeiderProtein()
        case "black_cumin_oil":
            saveBlackCuminOil()

//        case "hand-stand":
//            saveHandStand()
        case "meditation":
            saveMeditation()
        case "press":
            savePress()
        case "push-ups":
            savePushUps()
        case "rope-jumping":
            saveRopeJumping()
        case "sex":
            saveSex()
        case "sit-ups":
            saveSitUps()
        case "stairs-climbing":
            saveStairsClimbing()
        case "swimming":
            saveSwimming()

        default:
            savePill() //"Супрадин"
        }
        
        if (sender.currentTitle! != "stairs-climbing" && sender.currentTitle! != "sex" && sender.currentTitle! != "meditation") {
            Alert(title: "Success",
              message: "The " + sender.currentTitle! + " was recorded in Apple Health",
              buttonText: "OK");
        }
    }
    
    func getHealthKitPermission() {
        // State the health data type(s) we want to write from HealthKit.
        let healthDataToWrite = Set(arrayLiteral:
            
            HKCategoryType.categoryType(forIdentifier: .sexualActivity)!,
            HKCategoryType.categoryType(forIdentifier: .mindfulSession)!,

            HKObjectType.workoutType(),
            
            HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,

            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!,
            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
            HKObjectType.quantityType(forIdentifier: .dietarySugar)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFiber)!,

            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .dietarySodium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryPotassium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            
            HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!,
            HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)!,
            HKObjectType.quantityType(forIdentifier: .dietaryThiamin)!, //b1
            HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)!, //b2
            HKObjectType.quantityType(forIdentifier: .dietaryNiacin)!,
            HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFolate)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)!,
            HKObjectType.quantityType(forIdentifier: .dietaryBiotin)!,
            HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCalcium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryIron)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCopper)!,
            HKObjectType.quantityType(forIdentifier: .dietaryIodine)!,
            HKObjectType.quantityType(forIdentifier: .dietaryZinc)!,
            HKObjectType.quantityType(forIdentifier: .dietaryManganese)!,
            HKObjectType.quantityType(forIdentifier: .dietarySelenium)!,
            HKObjectType.quantityType(forIdentifier: .dietaryMolybdenum)!
        )
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        // Request authorization to read and/or write the specific data.
        healthStore.requestAuthorization(toShare: healthDataToWrite, read: nil) { (success, error) -> Void in
            //print(success);
        }
    }
    
    func Alert(title:String,message:String,buttonText:String) -> Void {
        let alertController = UIAlertController(
            title:title,
            message:message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alertController.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func saveEspresso() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryEnergyConsumed] = [3.0, "kcal"]
        samplesList[.dietaryCarbohydrates] = [0.5, "g"]
        samplesList[.dietaryPotassium] = [34.5, "mg"]
        samplesList[.dietaryMagnesium] = [24.0, "mg"]
        samplesList[.dietaryFatTotal] = [0.1, "g"]
        samplesList[.dietaryCaffeine] = [63.6, "mg"]
        samplesList[.dietarySodium] = [4.2, "mg"]
        samplesList[.dietaryWater] = [30.0, "mL"]
        
        saveFoodSample(samplesList, 60, "Espresso")
    }
    
    func saveWater() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryWater] = [200.0, "mL"]
        saveFoodSample(samplesList, 60, "200 ml of water")
    }
    
    func saveTea() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryWater] = [340.0, " mL"]
        samplesList[.dietaryEnergyConsumed] = [3.4, "kcal"]
        samplesList[.dietarySodium] = [3.4 * 4, "mg"]
        samplesList[.dietaryPotassium] = [3.4 * 18.0, "mg"]
        samplesList[.dietaryCarbohydrates] = [3.4 * 0.2, "g"]
        samplesList[.dietaryProtein] = [3.4 * 0.1, "g"]
        samplesList[.dietaryCaffeine] = [3.4 * 11, "mg"]
        
        saveFoodSample(samplesList, 60, "Tea")
    }
    
    func saveApple() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryEnergyConsumed] = [47.0, "kcal"]
        samplesList[.dietaryFatTotal] = [0.3, "g"]
        samplesList[.dietaryFatSaturated] = [0.1, "g"]
        samplesList[.dietaryFatPolyunsaturated] = [0.1, "g"]
        samplesList[.dietaryCarbohydrates] = [25.0, "g"]
        samplesList[.dietaryFiber] = [4.4, "g"]
        samplesList[.dietarySugar] = [19.0, "g"]
        samplesList[.dietaryProtein] = [0.5, "g"]
        samplesList[.dietarySodium] = [1.8, "mg"] //Na
        samplesList[.dietaryPotassium] = [194.7, "mg"] //K
        samplesList[.dietaryMagnesium] = [9.1, "mg"] //Mg
        samplesList[.dietaryCalcium] = [10.9, "mg"] //Ca
        samplesList[.dietaryIron] = [0.2, "mg"] //Fe
        samplesList[.dietaryVitaminB6] = [0.1, "mg"] //B6
        samplesList[.dietaryVitaminC] = [8.4, "mg"]
        samplesList[.dietaryWater] = [156.0, "mL"]
        
        saveFoodSample(samplesList, 60, "Apple")
    }
    
    /* 100 ml of granat joice */
    func saveGranat() -> Void {
        let volume = 0.5
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryEnergyConsumed] = [volume * 83.0, "kcal"]
        samplesList[.dietaryFatTotal] = [volume * 1.2, "g"]
        samplesList[.dietaryFatSaturated] = [volume * 0.1, "g"]
        samplesList[.dietaryFatPolyunsaturated] = [volume * 0.1, "g"]
        samplesList[.dietaryFatMonounsaturated] = [volume * 0.1, "g"]
        samplesList[.dietarySodium] = [volume * 3.0, "mg"] //Na
        samplesList[.dietaryPotassium] = [volume * 236.0, "mg"] //Kalium
        samplesList[.dietaryCarbohydrates] = [volume * 19.0, "g"]
        samplesList[.dietaryFiber] = [volume * 4.0, "g"]
        samplesList[.dietarySugar] = [volume * 14.0, "g"]
        samplesList[.dietaryProtein] = [volume * 1.7, "g"]
        samplesList[.dietaryCalcium] = [volume * 10.0, "mg"] //Ca
        samplesList[.dietaryVitaminC] = [volume * 10.2, "mg"]
        samplesList[.dietaryIron] = [volume * 0.3, "mg"] //Fe
        samplesList[.dietaryVitaminB6] = [volume * 0.1, "mg"] //B6
        samplesList[.dietaryMagnesium] = [volume * 12.0, "mg"] //Mg
        
        samplesList[.dietaryVitaminE] = [volume * 0.6, "mg"]
        samplesList[.dietaryVitaminK] = [volume * 16.4, "mcg"]
        samplesList[.dietaryThiamin] = [volume * 0.1, "mg"] //B1
        samplesList[.dietaryRiboflavin] = [volume * 0.1, "mg"] //B2
        samplesList[.dietaryNiacin] = [volume * 0.3, "mg"]
        samplesList[.dietaryFolate] = [volume * 38.0, "mcg"]
        
        samplesList[.dietaryPhosphorus] = [volume * 36.0, "mg"] //P
        samplesList[.dietaryZinc] = [volume * 0.4, "mg"] //P
        samplesList[.dietaryCopper] = [volume * 0.2, "mg"] //P
        samplesList[.dietaryManganese] = [volume * 0.1, "mg"] //P
        samplesList[.dietarySelenium] = [volume * 0.5, "mcg"]
        samplesList[.dietaryPantothenicAcid] = [volume * 0.4, "mg"]
        
//        HKQuantityTypeIdentifier.dietaryPantothenicAcid
        
        samplesList[.dietaryWater] = [volume * 77.9, "mL"]
        
        saveFoodSample(samplesList, 50, "Granat juice")
        
    }
    
    /* 100 ml of granat joice */
    func saveMultiVitaminMuscleTech() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryVitaminA] = [6.0, "mg"]
        samplesList[.dietaryVitaminC] = [135.0, "mg"]
        samplesList[.dietaryVitaminD] = [10.0, "mcg"]
        samplesList[.dietaryVitaminE] = [81.0, "mg"]
        samplesList[.dietaryThiamin] = [20.0, "mg"]
        samplesList[.dietaryRiboflavin] = [13.5, "mg"]
        samplesList[.dietaryNiacin] = [60.0, "mg"]
        samplesList[.dietaryVitaminB6] = [10.0, "mg"]
        samplesList[.dietaryFolate] = [300.0, "mcg"] //folic acid
        samplesList[.dietaryVitaminB12] = [100.0, "mcg"]
        samplesList[.dietaryBiotin] = [165.0, "mcg"]
        samplesList[.dietaryPantothenicAcid] = [80.0, "mg"]
        samplesList[.dietaryCalcium] = [152.0, "mg"] //Ca
        samplesList[.dietaryMagnesium] = [145.0, "mg"] //Mg
        samplesList[.dietaryZinc] = [9.5, "mg"]
        samplesList[.dietaryCopper] = [1.0, "mg"]
        samplesList[.dietaryManganese] = [7.0, "mg"]
        samplesList[.dietaryMolybdenum] = [10.0, "mcg"]
        samplesList[.dietaryPotassium] = [35.0, "mg"]
        
        saveFoodSample(samplesList, 60, "Mutli-vitamins")
    }


    
    func saveWeiderProtein() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryEnergyConsumed] = [110.0, "kcal"]
        samplesList[.dietaryFatTotal] = [0.5, "g"]
        samplesList[.dietaryFatSaturated] = [0.3, "g"]
        samplesList[.dietaryCarbohydrates] = [2.3, "g"]
        samplesList[.dietarySugar] = [2.0, "g"]
        samplesList[.dietaryProtein] = [24.0, "g"]
        samplesList[.dietaryVitaminB6] = [0.6, "mg"]
        samplesList[.dietaryCalcium] = [400.0, "mg"]
        
        saveFoodSample(samplesList, 60, "Weider protein")

    }
    

    func savePill() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        samplesList[.dietaryVitaminA] = [800.0, "mcg"]
        samplesList[.dietaryVitaminD] = [5.0, "mcg"]
        samplesList[.dietaryVitaminE] = [12.0, "mg"]
        samplesList[.dietaryVitaminK] = [25.0, "mcg"]
        samplesList[.dietaryThiamin] = [3.3, "mg"] //b1
        samplesList[.dietaryRiboflavin] = [4.2, "mg"] //b2
        samplesList[.dietaryNiacin] = [48.0, "mg"]
        samplesList[.dietaryPantothenicAcid] = [18.0, "mg"]
        samplesList[.dietaryVitaminB6] = [2.0, "mg"]
        samplesList[.dietaryFolate] = [200.0, "mcg"]
        samplesList[.dietaryVitaminB12] = [3.0, "mcg"]
        samplesList[.dietaryBiotin] = [50.0, "mcg"]
        samplesList[.dietaryVitaminC] = [180.0, "mg"]
        samplesList[.dietaryCalcium] = [120.0, "mg"]
        samplesList[.dietaryMagnesium] = [80.0, "mg"]
        samplesList[.dietaryIron] = [14.0, "mg"]
        samplesList[.dietaryCopper] = [1.0, "mg"]
        samplesList[.dietaryIodine] = [150.0, "mcg"]
        samplesList[.dietaryZinc] = [10.0, "mg"]
        samplesList[.dietaryManganese] = [2.0, "mg"]
        samplesList[.dietarySelenium] = [50.0, "mcg"]
        samplesList[.dietaryMolybdenum] = [50.0, "mcg"]
        
        saveFoodSample(samplesList, 60, "Supradin pill")
        
    }
    

    func saveBlackCuminOil() -> Void {
        var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
        let amount = 0.05 // 5 grams
        
        samplesList[.dietaryEnergyConsumed] = [345.0 * amount, "kcal"]
        samplesList[.dietaryFatTotal] = [15.0 * amount, "g"]
        samplesList[.dietaryFatSaturated] = [0.5 * amount, "g"]
        samplesList[.dietaryFatPolyunsaturated] = [1.7 * amount, "g"]
        samplesList[.dietaryFatMonounsaturated] = [10.0 * amount, "g"]
        samplesList[.dietarySodium] = [88.0 * amount, "mg"]
        samplesList[.dietaryPotassium] = [1.694 * amount, "mg"]
        samplesList[.dietaryCarbohydrates] = [52.0 * amount, "g"]
        samplesList[.dietaryFiber] = [40.0 * amount, "g"]
        samplesList[.dietaryProtein] = [16.0 * amount, "g"]
        samplesList[.dietaryVitaminA] = [135.0 * 0.3 * amount, "mcg"]
        samplesList[.dietaryVitaminB6] = [0.5 * amount, "mg"]
        samplesList[.dietaryVitaminC] = [21.0 * amount, "mg"]
        samplesList[.dietaryIron] = [18.5 * amount, "mg"]
        samplesList[.dietaryCalcium] = [1.196 * amount, "mg"]
        samplesList[.dietaryMagnesium] = [385 * amount, "mg"]

        saveFoodSample(samplesList, 60, "Black cumin oil")
    }
    
    func saveHandStand() -> Void {
        let duration = 30 //seconds
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 10.0) //10 pushups, approx.
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-duration)) as Date
        let metadata: [String: Bool] = [HKMetadataKeyIndoorWorkout: true]
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.gymnastics,
            start: startTime,
            end: endTime as Date,
            duration: TimeInterval(duration),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var samples: [HKQuantitySample] = []
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            samples.append(energyBurnedPerIntervalSample)
            
            self.healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }

    func savePress() -> Void {
        let duration = 30 //seconds
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0.5 * 10.0) //10 presses = 0.5 minute = 0.5 * 10 kcal/minute
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-duration)) as Date
        let metadata: [String: Bool] = [HKMetadataKeyIndoorWorkout: true]
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.coreTraining,
            start: startTime,
            end: endTime as Date,
            duration: TimeInterval(duration),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var samples: [HKQuantitySample] = []
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            samples.append(energyBurnedPerIntervalSample)
            
            self.healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }
    
    func savePushUps() -> Void {
        let duration = 30 //seconds
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0.5 * 17.0) //10 pushups = 0.5 mins * 17 kcal/minute
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-duration)) as Date
        let metadata: [String: Bool] = [HKMetadataKeyIndoorWorkout: true]
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.coreTraining,
            start: startTime,
            end: endTime as Date,
            duration: TimeInterval(duration),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var samples: [HKQuantitySample] = []
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            samples.append(energyBurnedPerIntervalSample)
            
            self.healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }
    
    func saveRopeJumping() -> Void {
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0.85) //100 jumps
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(-90) as Date
        let metadata: [String: Bool] = [
            HKMetadataKeyIndoorWorkout: true
        ]
        
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.jumpRope,
            start: startTime,
            end: endTime as Date,
            duration: 90,
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var samples: [HKQuantitySample] = []
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            samples.append(energyBurnedPerIntervalSample)
            
            self.healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }
    
    func timeToStr(time: TimeInterval) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var times: [String] = []
//        if hours > 0 {
//            times.append("\(hours)")
//        }
//        if minutes > 0 {
//            times.append("\(minutes)")
//        }
        times.append(String(format: "%02d", minutes))
        times.append(String(format: "%02d", seconds))
            
        return times.joined(separator: ":")
    }
    
    @objc func fire()
    {
        let time = Date().timeIntervalSince(timersList["meditation"]!)
        MeditationLabel.text = timeToStr(time: time)
        
        // on 7 minutes it beeps
        if (Int(time) == 7*60) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    func saveMeditation() -> Void {
        if (nil == timersList["meditation"]) {
            timersList["meditation"] = Date()
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(fire),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.commonModes)
            timer.tolerance = 0.1
            timers2List["meditation"] = timer
            MeditationLabel.text = "00:00"
            return
        }
        
        timers2List["meditation"]?.invalidate()
        MeditationLabel.text = ""
        let startDate = timersList["meditation"]
        timersList["meditation"] = nil
        let endDate = Date()
        
        let meditationActivity = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)

        let sample = HKCategorySample(
            type: meditationActivity!,
            value: HKCategoryValue.notApplicable.rawValue,
            start: startDate!,
            end: endDate
        )
        
        healthStore.save(sample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error ?? "error!")
            }
        })
        
        Alert(title: "Success",
              message: "A meditation was recorded in Apple Health",
              buttonText: "OK");
    }
    
    func saveSex() -> Void {
        if (nil == timersList["sex"]) {
            timersList["sex"] = Date()
            sexLabel.text = "ON"
            return
        }
        
        sexLabel.text = ""
        let startDate = timersList["sex"]
        timersList["sex"] = nil
        let endDate = Date()
        
        let sexualActivity = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sexualActivity)
        let metadata: [String: String]? = [HKMetadataKeySexualActivityProtectionUsed: "NO"]
        
        let sexSample = HKCategorySample(
            type: sexualActivity!,
            value: HKCategoryValue.notApplicable.rawValue,
            start: startDate!,
            end: endDate,
            metadata: metadata
        )
        
        healthStore.save(sexSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error ?? "error!")
            }
        })
        
        Alert(title: "Success",
              message: "A sex was recorded in Apple Health",
              buttonText: "OK");
    }
    
    func saveSitUps() -> Void {
        let duration = 30 //seconds
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 10 * 0.5) //10 sit-ups
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-duration)) as Date
        let metadata: [String: Bool] = [HKMetadataKeyIndoorWorkout: true]
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.functionalStrengthTraining,
            start: startTime,
            end: endTime as Date,
            duration: TimeInterval(duration),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var samples: [HKQuantitySample] = []
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            samples.append(energyBurnedPerIntervalSample)
            
            self.healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }
    

    func saveWorkout(type: HKWorkoutActivityType, durationInSeconds: Int, title: String, samplesList: [HKQuantityTypeIdentifier: Array<Any>], _ metadata: [String: Any]) {
        
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-durationInSeconds))
        
        let samples = buildIndexedSamplesList(samplesList, title, startTime, endTime)
        
        let energyBurned = samples[.activeEnergyBurned] != nil ? samples[.activeEnergyBurned] : nil;
        let distance = samples[.distanceWalkingRunning] != nil ? samples[.distanceWalkingRunning] : nil;
        let workout = HKWorkout(
            activityType: type,
            start: startTime as Date,
            end: endTime as Date,
            duration: TimeInterval(durationInSeconds),
            totalEnergyBurned: energyBurned != nil ? energyBurned?.quantity : nil,
            totalDistance: distance != nil ? distance?.quantity : nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var flatSamples = [HKQuantitySample]()
            for (_, sample) in samples {
                flatSamples.append(sample)
            }
            
            self.healthStore.add(
                flatSamples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }

    
    func saveContinuousWorkout(type: HKWorkoutActivityType, startDate: Date, endDate: Date,  title: String, samplesList: [HKQuantityTypeIdentifier: Array<Any>], _ metadata: [String: Any]) {
        let di = DateInterval(start: startDate, end: endDate);
        
        let samples = buildIndexedSamplesList(samplesList, title, startDate as NSDate, endDate as NSDate)
        
        let energyBurned = samples[.activeEnergyBurned] != nil ? samples[.activeEnergyBurned] : nil;
        let distance = samples[.distanceWalkingRunning] != nil ? samples[.distanceWalkingRunning] : nil;
        let workout = HKWorkout(
            activityType: type,
            start: startDate,
            end: endDate,
            duration: di.duration,
            totalEnergyBurned: energyBurned != nil ? energyBurned?.quantity : nil,
            totalDistance: distance != nil ? distance?.quantity : nil,
            metadata: metadata
        )
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            var flatSamples = [HKQuantitySample]()
            for (_, sample) in samples {
                flatSamples.append(sample)
            }
            
            self.healthStore.add(
                flatSamples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
        }
    }

    func saveStairsClimbing() -> Void {
        if (nil == timersList["StairsClimbing"]) {
            timersList["StairsClimbing"] = Date()
            stairsClimbingLabel.text = "ON"
            return
        }
        
        stairsClimbingLabel.text = ""
        let startDate = timersList["StairsClimbing"]
        timersList["StairsClimbing"] = nil
        let endDate = Date()
        var floorsCount:Int = 0
        
        showInputDialog(title: "Floors",
                        subtitle: "Please enter the floors count.",
                        actionTitle: "Count this",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Floors",
                        inputKeyboardType: UIKeyboardType.numberPad)
        {
            (floorsCountString:String?) in
                print("The new number is \(floorsCountString ?? "")")
                floorsCount = Int(floorsCountString!)!
                if (0 == floorsCount) {
                    print("Floors count is 0")
                    return
                }
            
                let components = Calendar.current.dateComponents([.second], from: startDate!, to: endDate)
            
                let timeInHours:Double = Double(components.second!) / 3600.0
                var samplesList =  [HKQuantityTypeIdentifier: Array<Any>]()
                samplesList[.activeEnergyBurned] = [265.0 * timeInHours, "kcal"]
                samplesList[.distanceWalkingRunning] = [7.0 * Double(floorsCount), "m"]
                samplesList[.flightsClimbed] = [Double(floorsCount), "count"]
            
                var metadata: [String: Any] = [HKMetadataKeyIndoorWorkout: true]
            
                let elevation = HKQuantity(unit: HKUnit.meter(), doubleValue: 3.0 * Double(floorsCount))
                metadata[HKMetadataKeyElevationAscended] = elevation
            
                self.saveContinuousWorkout(type: .stairs, startDate: startDate!, endDate: endDate, title: "Stairs", samplesList: samplesList, metadata)
        }
    }
    
    @available(iOS 10.0, *)
    func saveSwimming() -> Void {
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 80.0) //I spend 8-10 min for 250 metres approx.
        let distance = HKQuantity(unit: HKUnit.meter(), doubleValue: 250.0)
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(-600) as Date
        
        let metadata: [String: Bool] = [
            HKMetadataKeyIndoorWorkout: true,
            HKMetadataKeyCoachedWorkout: false
        ]
        
        let workout = HKWorkout(
            activityType: HKWorkoutActivityType.swimming,
            start: startTime,
            end: endTime as Date,
            duration: 600,
            totalEnergyBurned: energyBurned,
            totalDistance: distance,
            metadata: metadata
        )
        
        let healthStore = HKHealthStore()
        
        healthStore.save(workout) { (success, error) in
            if( error != nil ) {
                print(error ?? "error!")
                return;
            }
            
            // Add optional, detailed information for each time interval
            var samples: [HKQuantitySample] = []
            
            let distanceType = HKObjectType.quantityType(
                forIdentifier: .distanceSwimming
            )
            
            let distancePerIntervalSample = HKQuantitySample(
                type: distanceType!,
                quantity: distance,
                start: startTime,
                end: endTime as Date
            )
            
            samples.append(distancePerIntervalSample)
            
            let energyBurnedType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
            
            let energyBurnedPerIntervalSample = HKQuantitySample(
                type: energyBurnedType!,
                quantity: energyBurned,
                start: startTime,
                end: endTime as Date
            )
            
            samples.append(energyBurnedPerIntervalSample)
            
            healthStore.add(
                samples,
                to: workout) { (success, error) -> Void in
                    if( error != nil ) {
                        print(error ?? "error!")
                        return;
                    }
            }
            
        }
    }

  
    func buildSamplesList(_ list: [HKQuantityTypeIdentifier: Array<Any>], _ title: String, _ start: NSDate, _ end: NSDate) -> [HKSample] {
        var samplesArray = [HKSample]()
        for (identifier, item) in list {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
                continue
            }
            let unit = HKUnit(from: item[1] as! String)
            let quantity = HKQuantity(unit: unit, doubleValue: item[0] as! Double)
            
            let metadata: [String: String]? = ["Title": title]
            
            let sample = HKQuantitySample(
                type: quantityType,
                quantity: quantity,
                start: start as Date,
                end: end as Date,
                metadata: metadata
            )
            
            samplesArray.append(sample);
        }
        return samplesArray
    }
    
    func buildIndexedSamplesList(_ list: [HKQuantityTypeIdentifier: Array<Any>], _ title: String, _ start: NSDate, _ end: NSDate) -> [HKQuantityTypeIdentifier: HKQuantitySample] {
        var result = [HKQuantityTypeIdentifier: HKQuantitySample]()
        
        for (identifier, item) in list {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
                continue
            }
            let unit = HKUnit(from: item[1] as! String)
            let quantity = HKQuantity(unit: unit, doubleValue: item[0] as! Double)
            
            let metadata: [String: String]? = ["Title": title]
            
            let sample = HKQuantitySample(
                type: quantityType,
                quantity: quantity,
                start: start as Date,
                end: end as Date,
                metadata: metadata
            )
            
            result[identifier] = sample
        }
        return result
    }
    
    func saveFoodSample(_ samplesList: [HKQuantityTypeIdentifier: Array<Any>], _ durationInSeconds: Int, _ title: String) {
        let endTime = NSDate()
        let startTime = endTime.addingTimeInterval(TimeInterval(-durationInSeconds))
        
        let samples = buildSamplesList(samplesList, title, startTime, endTime)
        
        let foodType: HKCorrelationType = HKObjectType.correlationType(forIdentifier: .food)!
        let foodMetadata: [String: String]? = [HKMetadataKeyFoodType: title]
        
        let foodCorrelation : HKCorrelation = HKCorrelation(
            type: foodType,
            start: startTime as Date,
            end: endTime as Date,
            objects: NSSet(array: samples) as! Set<HKSample>,
            metadata: foodMetadata
        )
        
        healthStore.save(foodCorrelation, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error ?? "error!")
            }
        })
    }
    
    func processData(_ list: [HKQuantityTypeIdentifier: Array<Any>], _ title: String) {
        let samplesArray = buildSamplesList(list, title, NSDate(), NSDate())
        
        for sample in samplesArray {
            healthStore.save(sample, withCompletion: { (success, error) -> Void in
                if( error != nil ) {
                    print(error ?? "error!")
                }
            })
        }
    }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

