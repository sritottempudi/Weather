//
//  WeatherView.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/11/23.
//

import UIKit

class WeatherView: UIView {
    let XIBName = "WeatherView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    var weatherInfo: WeatherInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(XIBName, owner: self, options: nil)
        contentView.pin(self)
        contentView.backgroundColor = .clear
        setupView()
    }
    
    func update(weatherInfo: WeatherInfo) {
        self.weatherInfo = weatherInfo
        setupView()
    }
    
    func setupView() {
        guard let weatherInfo = weatherInfo else {
            return
        }
        
        nameLabel.text = weatherInfo.name
        tempLabel.text = weatherInfo.main.temp.fahrenheit
        feelsLikeTempLabel.text = weatherInfo.main.feelsLike.fahrenheit
        maxTempLabel.text = weatherInfo.main.tempMax.fahrenheit
        minTempLabel.text = weatherInfo.main.tempMin.fahrenheit
        setupImageView()
    }
    
    // For the sake of time not using Image Downloader.
    func setupImageView() {
        guard let image = weatherInfo?.weather.first?.icon else {
            return
        }

        imageView.image = UIImage(named: image)
    }
}
