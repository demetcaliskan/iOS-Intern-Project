//
//  HomeViewController.swift
//  InternProject
//
//  Created by Demet Çalışkan on 21.01.2021.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let url = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/data.json"
    let urlForImages = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/"
    
    var fetchedItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData(from: url)
        
        startAnimation()
        
    }
    
    private func startAnimation(){
        let animationView: UIView = UIView(frame: view.frame)
        animationView.backgroundColor = UIColor.black
        let loading = NVActivityIndicatorView(frame: .zero, type: .pacman, color: .yellow, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.backgroundColor = UIColor.black
        animationView.addSubview(loading)
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 100),
            loading.heightAnchor.constraint(equalToConstant: 100),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            loading.stopAnimating()
            animationView.isHidden = true
        }
    }
    
    private func getData(from url: String) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if(error != nil) {
                print("ERROR!")
            } else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:Any]
                    let jsonArray = fetchedData["items"] as! [[String:Any]]

                    for json in jsonArray {
                        let title = json["title"] as! String
                        var url = json["url"] as! String
                        url = self.urlForImages + url
                        
                        self.fetchedItems.append(Item(title: title, url: url))
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("ERROR!")
                }
            }
        }
        task.resume()
        
        for item in fetchedItems {
            print(item.title + " " + item.url)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        let imgURL = self.fetchedItems[indexPath.row].url
        
        cell.label.text = self.fetchedItems[indexPath.row].title
        cell.imgView.sd_setImage(with: URL(string: imgURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
}

class Item {
    var title: String
    var url: String
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
}
