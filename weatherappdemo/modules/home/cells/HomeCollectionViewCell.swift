//
//  HomeCollectionViewCell.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var seprator: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        cityName.text = ""
        minLabel.text = ""
        maxLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(detail:CurrentWeather){
        if let iconDetail = detail.icons[exist: 0]{
            let iconUrl = ApiConstants.BASE_URL_IMAGE.replacingOccurrences(of: "%@", with: iconDetail.icon)
            icon.downloadImage(from: iconUrl)
        }
        cityName.text = detail.name
        if let minTemp = detail.main?.minTemp {
            minLabel.text = "\(minTemp) ℃"
        }else{
            minLabel.text = ""
        }
        if let maxTemp = detail.main?.maxTemp {
            maxLabel.text = " \(maxTemp) ℃"
        }else{
            maxLabel.text = ""
        }
        
        if (maxLabel.text ?? "").isEmpty || (minLabel.text ?? "").isEmpty{
            seprator.text = ""
        }else{
            seprator.text = "/"
        }
    }
}
