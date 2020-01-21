//
//  HomeViewController.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import UIKit
import CoreLocation

protocol HomeViewInterface: ViewInterface {
    func updateWeatherData(weatherDetails: [CurrentWeather])
    func getNavigationController()->UINavigationController?
}

class HomeViewController: BaseViewController {
    
    //MARK:- Members
    var presenter:HomePresenterInterface!
    var weatherDetails:[CurrentWeather] = []
    var locationManager:CLLocationManager!
    var cityCountryCode:[String] = ["Pune,in","San Francisco,us"]
    
    var cellMarginSize:CGFloat = 16.0
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        setupUI()
        setupLocationManager()
    }
    
    func setupUI(){
        self.weatherCollectionView.delegate = self
        self.weatherCollectionView.dataSource = self
        self.weatherCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let widthSize = (self.view.frame.width-20)/(isDevicePhone ? 2 : 3)
        layout.itemSize = CGSize(width: widthSize, height: widthSize)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.weatherCollectionView!.collectionViewLayout = layout
    }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
        if CLLocationManager.locationServicesEnabled() {
            self.showSpinner()
            locationManager.requestLocation()
        }
    }
}

extension HomeViewController:HomeViewInterface{
    func getNavigationController() -> UINavigationController? {
        return self.navigationController
    }
    
    func updateWeatherData(weatherDetails: [CurrentWeather]) {
        self.weatherDetails = weatherDetails
        self.weatherCollectionView.reloadData()
    }
    
    
    func showSpinner() {
        self.view.showSpinner(color: .white)
    }
    
    func hideSpinner() {
        self.view.hideSpinner()
    }
}

//MARK: - Delegate UICollection and COllectionViewDelegateFlowlayout
extension HomeViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let weather = weatherDetails[exist: indexPath.row]{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            cell.setupData(detail:weather)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let weather = weatherDetails[exist: indexPath.row]{
            self.presenter.showCityWeatherDetails(city: weather)
        }
    }
}


//MARK: - Location Manager
extension HomeViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation) { (placemark, error) in
            
            guard let placemarks = placemark else {
                //something went wrong, check permission, navigate to settings
                self.hideSpinner()
                return
            }
            manager.stopUpdatingLocation()
            manager.delegate = nil
            let placemark = placemarks[0]
            if let city = placemark.locality, let country = placemark.isoCountryCode?.lowercased(){
                let cityAndCode = String(format: "%@,%@", city,country)
                if !self.cityCountryCode.contains(cityAndCode) {
                    self.cityCountryCode.append(cityAndCode)
                }
                self.presenter.getWeatherDetails(for: self.cityCountryCode)
            }else{
                // load without user location
                self.presenter.getWeatherDetails(for: self.cityCountryCode)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}

