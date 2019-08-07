//
//  ChangeCityViewController.swift
//  Geo Location
//
//  Created by Vj Ay on 06/05/19.
//  Copyright © 2019 Vj Ay. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate{
    
    func userEnteredNewCityName(city : String)
}


class ChangeCityViewController: UIViewController {


    
    @IBOutlet weak var cityTextBox: UITextField!
    
    
    var delegate : ChangeCityDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    @IBAction func getCityWeather(_ sender: Any) {
        
        let cityName = cityTextBox.text!
        
       delegate?.userEnteredNewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
}
