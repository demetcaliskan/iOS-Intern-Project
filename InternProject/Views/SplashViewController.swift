//
//  SplashViewController.swift
//  InternProject
//
//  Created by Demet Çalışkan on 21.01.2021.
//

import UIKit
import Network

class SplashViewController: UIViewController {
    @IBOutlet weak var connectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MonitorNetwork()
        // Do any additional setup after loading the view.
    }
    
    
    
    func MonitorNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.connectionLabel.text = "Internet is connected."
                }
            }
            else {
                DispatchQueue.main.async {
                    self.connectionLabel.text = "Internet is not connected."
                }
            }
        }
        
    }

}

