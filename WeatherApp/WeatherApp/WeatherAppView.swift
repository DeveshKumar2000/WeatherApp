//
//  WeatherAppView.swift
//  WeatherApp
//
//  Created by Devesh Kumar Singh on 25/03/22.
//

import UIKit
class WeatherAppView: UIViewController {
    let miniView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemIndigo
        view.layer.cornerRadius = 17
        return view
    }()
    var cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    let temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    let dayAndDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    let imageDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    var lat: Float64?
    var long: Float64?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOfWeatherApp()
        view.backgroundColor = UIColor.systemTeal
        view.addSubview(miniView)
        miniView.addSubview(image)
        miniView.addSubview(cityName)
        miniView.addSubview(temperature)
        miniView.addSubview(imageDescription)
        miniView.addSubview(dayAndDate)
        
        addContraints()
    }
    
    func setDataOfWeatherApp(){
        if latLongErrorHandling(){
            return
        }
        miniView.isHidden = true
        fetchWeatherData {[weak self](WeatherInfo) in
            DispatchQueue.main.async{
                print(WeatherInfo.data?[0] ?? "nil")
                if WeatherInfo.data?[0] == nil{
                    let ac = UIAlertController(title: self?.title, message: "Data Cannot Be Fetched. Please Try Agin", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                    return
                }
                self?.name = WeatherInfo.data?[0].cityName ?? ""
                self?.cityName.text = self?.name ?? ""
                self?.temperature.text = String(WeatherInfo.data?[0].temperature ?? 0.0) + "°C"
                self?.imageDescription.text =  WeatherInfo.data?[0].weather?.description ?? ""
                let imageCode = WeatherInfo.data?[0].weather?.icon ?? ""
                self?.image.image = UIImage(named: imageCode)
                self?.dayAndDate.text = self?.processTimeAndDate(WeatherInfo.data?[0].dateTime)
                self?.miniView.isHidden = false
            }
            
        }
    }
    func latLongErrorHandling() -> Bool{
        if lat == nil || long == nil {
            let ac = UIAlertController(title: self.title, message: "Lattitude And longitude data cannot Be fetched. Please Try Agin", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(ac, animated: true)
            return true
        }
        return false
    }
    func processTimeAndDate(_ date: String?) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d, yyyy"
        if let date  = date{
            if let date = dateFormatterGet.date(from: date + ":00") {
                return dateFormatterPrint.string(from: date)
            }
        }
        return ""
    }
    func addContraints(){
        var constraints = [NSLayoutConstraint]()
        
        //dayAndDate Constraints
        constraints.append(dayAndDate.centerXAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(dayAndDate.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(dayAndDate.widthAnchor.constraint(equalToConstant: 300))
        constraints.append(dayAndDate.topAnchor.constraint(equalTo: imageDescription.safeAreaLayoutGuide.bottomAnchor, constant: 10))
        
        //imageDescription Constraints
        constraints.append(imageDescription.centerXAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(imageDescription.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(imageDescription.widthAnchor.constraint(equalToConstant: 300))
        constraints.append(imageDescription.topAnchor.constraint(equalTo: image.safeAreaLayoutGuide.bottomAnchor, constant: 07))
        
        //temperature Constraints
        constraints.append(temperature.centerXAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(temperature.heightAnchor.constraint(equalToConstant: 40))
        
        constraints.append(temperature.widthAnchor.constraint(equalToConstant: 300))
        constraints.append(temperature.topAnchor.constraint(equalTo: cityName.safeAreaLayoutGuide.bottomAnchor, constant: 15))
        
        
        //cityName Constraints
        constraints.append(cityName.centerXAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(cityName.heightAnchor.constraint(equalToConstant: 30))
        
        constraints.append(cityName.widthAnchor.constraint(equalToConstant: 300))
        constraints.append(cityName.topAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.topAnchor, constant: 27))
        
        //image Constraints
        constraints.append(image.centerXAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(image.heightAnchor.constraint(equalToConstant: 170))
        
        constraints.append(image.widthAnchor.constraint(equalToConstant: 170))
        constraints.append(image.centerYAnchor.constraint(equalTo: miniView.safeAreaLayoutGuide.centerYAnchor))
        
        //miniView constraints
        constraints.append(miniView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(miniView.heightAnchor.constraint(equalToConstant: 400))
        
        constraints.append(miniView.widthAnchor.constraint(equalToConstant: 350))
        constraints.append(miniView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    func fetchWeatherData(completeionHandle: @escaping ((WeatherAppResponse) -> Void
    )){
        if let url = URL(string: "https://api.weatherbit.io/v2.0/current?lat=\(lat!)&lon=\(long!)&key=a274fe0971354e818d3302786fdd1479"){
            //here forcely unwrapped because it is handled before calling function
            URLSession.shared.dataTask(with: url) { (data,response,error) in
                guard let data = data else {return}
                do{
                    let postData = try JSONDecoder().decode(WeatherAppResponse.self, from: data)
                    completeionHandle(postData)
                }catch{
                    let error = error
                    print(error.localizedDescription)
                }
            }.resume()
        }
        
    }
    
}
