//
//  ViewController.swift
//  CoreLocashun
//
//  Created by Daniel Zimmerman on 3/15/23.
//

import UIKit
import Foundation
import CoreLocation
import CSV
import SwiftUI

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    var locationGlobal:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        startStopButton.setTitleColor(UIColor.green, for: .normal)
        setupLocationManager()
    }
    
    @IBAction func startStopTapped(_ sender: Any)
    {
        if(timerCounting)
        {
            timerCounting = false
            timer.invalidate()
            //            startStopButton.setTitle("Start", for: .normal)
            //            startStopButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            timerCounting = true
            //            startStopButton.setTitle("Pause", for: .normal)
            //            startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            
            let sFileName = "test.csv"
            
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
            
            let output = OutputStream.toMemory()
            
            let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
            
                csvWriter?.writeField("DATE")
                csvWriter?.writeField("TIME")
                csvWriter?.writeField("LATITUDE")
                csvWriter?.writeField("LONGITUDE")
                csvWriter?.writeField("FISHING BOAT")
                csvWriter?.writeField("SAILBOAT")
                csvWriter?.writeField("POWERBOAT")
                csvWriter?.writeField("TARPON")
                csvWriter?.writeField("SHARK")
                csvWriter?.writeField("NURSE SHARK")
                csvWriter?.writeField("EAGLE RAY")
                csvWriter?.writeField("STINGRAY")
                csvWriter?.writeField("DOLPHIN")
                csvWriter?.writeField("TURTLE")
                csvWriter?.writeField("FISH SCHOOL")
                csvWriter?.writeField("NOTES")
                csvWriter?.finishLine()
            
                // array to add data
                var arrOfData = [[String]]()
                
                arrOfData.append(["3/26/23","13:56:01","37.785834","-122.406417","","","","","","","1","","","","",""])
                arrOfData.append(["3/26/23","13:56:02","37.785834","-122.406417","","","1","","","","","","","","",""])
                arrOfData.append(["3/26/23","13:56:03","37.785834","-122.406417","","","","","","1","","","","","",""])
            
                for(elements) in arrOfData.enumerated() {
                    csvWriter?.writeField(elements.element[0]) // DATE
                    csvWriter?.writeField(elements.element[1]) // TIME
                    csvWriter?.writeField(elements.element[2]) // LAT
                    csvWriter?.writeField(elements.element[3]) // LONG
                    csvWriter?.writeField(elements.element[4]) // FISHING BOAT
                    csvWriter?.writeField(elements.element[5]) // SAILBOAT
                    csvWriter?.writeField(elements.element[6]) // POWER BOAT
                    csvWriter?.writeField(elements.element[7]) // TARPON
                    csvWriter?.writeField(elements.element[8]) // SHARK
                    csvWriter?.writeField(elements.element[9]) // NURSE SHARK
                    csvWriter?.writeField(elements.element[10]) // EAGLE RAY
                    csvWriter?.writeField(elements.element[11]) // STINGRAY
                    csvWriter?.writeField(elements.element[12]) // DOLPHIN
                    csvWriter?.writeField(elements.element[13]) // TURTLE
                    csvWriter?.writeField(elements.element[14]) // FISH SCHOOL
                    csvWriter?.writeField(elements.element[15]) // NOTES
                    csvWriter?.finishLine()
                }
                csvWriter?.closeStream()
                
            let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
            
            do {
                try buffer.write(to: documentURL)
            }
            catch {
            }
        }
    }
    @IBAction func resetTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Stop Timer?", message: "Stopping the timer will save the file and reset the app. Are you sure you want to do that?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //do nothing
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            self.timerDisplay.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
//            self.startStopButton.setTitle("Start", for: .normal)
//            self.startStopButton.setTitleColor(UIColor.white, for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func timerCounter() -> Void
    {
        // timer code
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerDisplay.text = timeString
        
        // csv code
        csv.
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    

    let locationManager = CLLocationManager()
    var now = Date()

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //            if location.horizontalAccuracy > 0 {
            //                locationManager.stopUpdatingLocation()
            let longitude1 = location.coordinate.longitude
            let latitude1 = location.coordinate.latitude
            
            latitude.text = String(latitude1)
            longitude.text = String(longitude1)
            
            print("latitude = \(latitude1), longitude = \(longitude1)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed, \(error)")
    }
    
}
