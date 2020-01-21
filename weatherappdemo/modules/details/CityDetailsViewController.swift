//
//  CityDetailsViewController.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import UIKit
protocol CityDetailViewInterface:ViewInterface {
    func updateForecastData(forecastResponse:ForecastWeatherResponse)
}
class CityDetailsViewController: BaseViewController {
    
    var presenter:CityDetailPresenterInterface!
    var curreWeather:CurrentWeather!
    
    var forecastedWeather:[CurrentWeather] = []
    
    //MARK:- IBOutlets
    @IBOutlet weak var forecastCollection: UICollectionView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidtyLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = curreWeather.name
        setupUI()
        setupCollectionView()
        presenter.getForecast(for: curreWeather.name)
    }
    
    func setupUI(){
        if let main = curreWeather.main{
            temperature.text = "\(main.temperature) ℃"
            pressureLabel.text = "\(main.pressure) hPa"
            humidtyLabel.text = "\(main.humidity)%"
        }
        if let wind = curreWeather.wind{
            windLabel.text = "\(wind.speed)m/S"
        }
        if let icon = curreWeather.icons[exist: 0]{
            weatherImage.downloadImage(from: ApiConstants.BASE_URL_IMAGE.replacingOccurrences(of: "%@", with: icon.icon))
        }
    }
    
    func setupCollectionView(){
        self.forecastCollection.delegate = self
        self.forecastCollection.dataSource = self
        self.forecastCollection.register(UINib(nibName: "CityDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CityDetailCollectionViewCell")
        let layout = forecastCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat(5)
        forecastCollection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension CityDetailsViewController: CityDetailViewInterface{
    func updateForecastData(forecastResponse: ForecastWeatherResponse) {
        self.forecastedWeather = forecastResponse.list ?? []
        self.forecastCollection.reloadData()
    }
    
    func showSpinner() {
        //as we are calling api for collectionView only , show spinner on collectionoView
        self.forecastCollection.showSpinner(color: .white)
    }
    
    func hideSpinner() {
        self.forecastCollection.hideSpinner()
    }
}

extension CityDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastedWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let weather = forecastedWeather[exist: indexPath.row]{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityDetailCollectionViewCell", for: indexPath) as! CityDetailCollectionViewCell
            cell.bindData(weather:weather)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let cellCount = floor(CGFloat(width / 100)) // 100 is estimated width size
        var itemSize = CGSize()
        itemSize.width = (width - (5 * (cellCount-1)) - 5) / cellCount
        return itemSize
    }
}
