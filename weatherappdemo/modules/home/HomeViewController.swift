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
    
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    
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
        let layout = weatherCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        layout.minimumLineSpacing = CGFloat(self.cellMarginSize)
        weatherCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
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

