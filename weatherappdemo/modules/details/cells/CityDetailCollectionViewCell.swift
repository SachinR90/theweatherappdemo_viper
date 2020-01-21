//
//  CityDetailCollectionViewCell.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import UIKit

class CityDetailCollectionViewCell: UICollectionViewCell {
    let dateFormatter = DateFormatter()
    @IBOutlet weak var forecastIconImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        temperature.text = ""
        timeLabel.text = ""
        dateLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(weather:CurrentWeather){
        if let icon = weather.icons[exist:0]{
            let url = ApiConstants.BASE_URL_IMAGE.replacingOccurrences(of: "%@", with: icon.icon)
            forecastIconImage.downloadImage(from: url)
        }
        if let main = weather.main{
            temperature.text = "\(main.temperature) ℃"
        }
        let date = Date(timeIntervalSinceNow: weather.date)
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)
        dateLabel.text = day
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        timeLabel.text = time
    }
}
