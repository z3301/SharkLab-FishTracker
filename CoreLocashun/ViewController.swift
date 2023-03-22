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
    
    // console
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    // buttons
    @IBOutlet weak var fishingBoatButton: UIButton!
    @IBOutlet weak var sailboatButton: UIButton!
    @IBOutlet weak var powerBoatButton: UIButton!
    @IBOutlet weak var tarponButton: UIButton!
    @IBOutlet weak var sharkButton: UIButton!
    @IBOutlet weak var nurseSharkButton: UIButton!
    @IBOutlet weak var eagleRayButton: UIButton!
    @IBOutlet weak var stingrayButton: UIButton!
    @IBOutlet weak var dolphinButton: UIButton!
    @IBOutlet weak var turtleButton: UIButton!
    @IBOutlet weak var fishSchoolButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    // timer vars
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    // csv vars
    var sFileName:String = ""
    var documentDirectoryPath:String = ""
    var documentURL:URL = URL(fileURLWithPath: "")
    var output = OutputStream.toMemory()
    var csvWriter = CHCSVWriter.init(forWritingToCSVFile: "")
    var arrOfData = [[String]]()
    
    //
    var lat:String! = ""
    var long:String! = ""
    var date = Date()
    var today = ""
    var now = ""
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    @IBAction func startStopTapped(_ sender: Any)
    {
        // pause functionality
        //        if(timerCounting)
        //        {
        //            timerCounting = false
        //            timer.invalidate()
        //            //            startStopButton.setTitle("Start", for: .normal)
        //            //            startStopButton.setTitleColor(UIColor.white, for: .normal)
        //        }
        //        else
        //        {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            
            // csv vars
            let now = Date()
            let fileName = now.formatted(Date.ISO8601FormatStyle().dateSeparator(.omitted).timeSeparator(.omitted))
            sFileName = "\(fileName).csv"
            documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
            output = OutputStream.toMemory()
            csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
                // csv header row
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
        }
//    }
    
    @IBAction func resetTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Stop Timer?", message: "Stopping the timer will save the file and reset the app. Are you sure you want to do that?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //do nothing
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            
            // build the CSV and close out the file
            for(elements) in self.arrOfData.enumerated() {
                self.csvWriter?.writeField(elements.element[0]) // DATE
                self.csvWriter?.writeField(elements.element[1]) // TIME
                self.csvWriter?.writeField(elements.element[2]) // LAT
                self.csvWriter?.writeField(elements.element[3]) // LONG
                self.csvWriter?.writeField(elements.element[4]) // FISHING BOAT
                self.csvWriter?.writeField(elements.element[5]) // SAILBOAT
                self.csvWriter?.writeField(elements.element[6]) // POWER BOAT
                self.csvWriter?.writeField(elements.element[7]) // TARPON
                self.csvWriter?.writeField(elements.element[8]) // SHARK
                self.csvWriter?.writeField(elements.element[9]) // NURSE SHARK
                self.csvWriter?.writeField(elements.element[10]) // EAGLE RAY
                self.csvWriter?.writeField(elements.element[11]) // STINGRAY
                self.csvWriter?.writeField(elements.element[12]) // DOLPHIN
                self.csvWriter?.writeField(elements.element[13]) // TURTLE
                self.csvWriter?.writeField(elements.element[14]) // FISH SCHOOL
                self.csvWriter?.writeField(elements.element[15]) // NOTES
                self.csvWriter?.finishLine()
            }
            self.csvWriter?.closeStream()
            let buffer = (self.output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
            do {
                try buffer.write(to: self.documentURL)
            }
            catch {
            }
            
            // reset the display
            self.count = 0
            self.timer.invalidate()
            self.timerDisplay.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
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
        
        // vars
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)

        // blank row
        arrOfData.append([today,now,lat,long,"","","","","","","","","","","",""])
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

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
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
    
    @IBAction func addFishingBoat(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"1","","","","","","","","","","",""])
    }
    
    @IBAction func addSailboat(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","1","","","","","","","","","",""])
    }
    
    @IBAction func addPowerBoat(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","1","","","","","","","","",""])
    }
    
    @IBAction func addTarpon(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","1","","","","","","","",""])
    }
    
    @IBAction func addShark(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","1","","","","","","",""])
    }
    
    @IBAction func addNurseShark(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","1","","","","","",""])
    }
    
    @IBAction func addEagleRay(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","1","","","","",""])
    }
    
    @IBAction func addStingray(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","","1","","","",""])
    }
    
    @IBAction func addDolphin(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","","","1","","",""])
    }
    
    @IBAction func addTurtle(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","","","","1","",""])
    }
    
    @IBAction func addFishSchool(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","","","","","1",""])
    }
    
    @IBAction func addNote(_ sender: Any) {
        lat = latitude.text
        long = longitude.text
        date = Date()
        today = date.formatted(date: .numeric, time: .omitted)
        now = date.formatted(date: .omitted, time: .complete)
        arrOfData.append([today,now,lat,long,"","","","","","","","","","","","1"])
    }
    
    
    
    
    
    
    
}
