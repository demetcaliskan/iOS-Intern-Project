//
//  SplashViewController.swift
//  InternProject
//
//  Created by Demet Çalışkan on 21.01.2021.
//

import UIKit
import Network
import Firebase

class SplashViewController: UIViewController {
    @IBOutlet weak var connectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MonitorNetwork()
        setupRemoteConfigDefaults()
        updateLabelWithRC()
        fetchRemoteConfig()
    }
    
    func updateLabelWithRC() {
        let labelText = RemoteConfig.remoteConfig().configValue(forKey: "labelText").stringValue ?? ""
        
        connectionLabel.text = labelText
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.performSegue(withIdentifier: "splashToHome", sender: nil)
        }
        
    }
    
    func setupRemoteConfigDefaults() {
        let defaultValues = ["labelText": "Default Text" as NSObject]
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func fetchRemoteConfig() {
        updateLabelWithRC()
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0, completionHandler: {
            [unowned self] (status, error) in
            guard error == nil else {
                print("WE HAVE AN ERROR!!!")
                return
            }
            
            print("Success!")
            RemoteConfig.remoteConfig().activate(completion: nil)
            self.updateLabelWithRC()
        })
    }
    
    
    
    func MonitorNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    print("Internet is connected.")
                }
            }
            else {
                DispatchQueue.main.async {
                    print("Internet is not connected.")
                    let alert = UIAlertController(title: "Attention", message: "Internet is not connected.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    

}
