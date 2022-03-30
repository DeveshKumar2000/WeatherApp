//
//  ViewController.swift
//  WeatherApp
//
//  Created by Devesh Kumar Singh on 25/03/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 50
        return view
    }()
    var jsonCityParsedData: [CityInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let err = fetchDataFromJson(){
            let ac = UIAlertController(title: title, message: err, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    present(ac, animated: true)
        }
        
        view.backgroundColor = UIColor.systemMint
        self.navigationItem.title = "Weather App"
        tableView.register(UITableViewCell
                            .self,forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        addContraints()
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRow = selectedRow {
            tableView.deselectRow(at: selectedRow, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = jsonCityParsedData[indexPath.row].city
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonCityParsedData.count;
    }
    func addContraints(){
        var constraints = [NSLayoutConstraint]()
        
        //tableView constarints
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        
        constraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        tableView.rowHeight = 50
        NSLayoutConstraint.activate(constraints)
    }
    func fetchDataFromJson() -> String?{
        if let fileLocation = Bundle.main.url(forResource: "csvjson", withExtension: "json"){
            do{
                let data = try Data(contentsOf: fileLocation)
                let jsonData = try JSONDecoder().decode([CityInfo].self, from: data)
                self.jsonCityParsedData = jsonData
                
            }catch{
                let error = error
                return error.localizedDescription
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WeatherAppView()
        print(indexPath.row)
        let cityInfo = jsonCityParsedData[indexPath.row]
        if let lat = cityInfo.lat{
            vc.lat = lat
        }
        if let long = cityInfo.lng{
            vc.long = long
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

