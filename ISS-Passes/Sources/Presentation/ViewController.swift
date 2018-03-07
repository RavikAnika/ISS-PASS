/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2015 IBM Corp. All Rights Reserved.
 * 6949 - XXX
 *
 * IMPORTANT:  This IBM software is supplied to you by IBM
 * Corp. ("IBM") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit
import CoreLocation
import AKNetworking

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ViewController : UIViewController ,CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var locationManager:CLLocationManager?
    var listofPasses = [Pass]()
    @IBOutlet var tableview: UITableView!
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    fileprivate func bundle() -> Bundle {
        let bundle = Bundle(for: ViewController.self)
        return bundle
    }
    
    fileprivate func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: self.bundle(), compatibleWith: nil)
    }
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    func customNavigation() {
        let logo = self.image(named: "common_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //*************************
    // IBActions
    //*************************
    
    @IBAction func doSignOut(_ sender: AnyObject) {
        self.authenticationController?.signOut()
    }
    
  
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Override Self Methods
    //**************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.register(PassesTableviewCell.self, forCellReuseIdentifier: "PassesTableviewCell")
          setupLocationManager()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // Check if Device has location services avaiable
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.requestAlwaysAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        else {
            // Display errror message if the device is not supported.
            self.displayAlert(alertTitle: "Location Services", alertMessage: "The location services in the device is not enabled")
        }
    }
    
    // MARK: Generic message for Displaying the alert

    func displayAlert(alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
    // MARK: Location Manager Delegate methods
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
        if (status == CLAuthorizationStatus.authorizedAlways) {
            print("location always allowed to track")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Failed with error", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentlocation = locations[0];
        // pass the coordinates to the model
        
        Pass.getAllPasses(Lat: currentlocation.coordinate.latitude, long: currentlocation.coordinate.longitude) { (success, listofPasses, error) in
            if error != nil {
                self.displayAlert(alertTitle: "Unable to retrieve data", alertMessage: "Data not available")
            }
            else {
            DispatchQueue.main.async {
                self.listofPasses = listofPasses
                self.tableview.reloadData()
               }
            }
            // Errror handling if service returns error
           
        }
    }
    
    //--------- Alert messages ----
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: TableView Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listofPasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        if self.listofPasses.count > 0 {
            let passAtIndex = self.listofPasses[indexPath.row] as Pass
            cell?.textLabel!.text = "Duration: " + String(passAtIndex.duration!) as String
            cell?.textLabel?.textAlignment = NSTextAlignment.left
            cell?.detailTextLabel?.textAlignment = NSTextAlignment.right
            cell?.detailTextLabel!.text = "Risetime: " + String(passAtIndex.riseTime!) as String
            cell?.detailTextLabel?.textColor = UIColor.darkGray
        }
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
