//
//  ViewController.swift
//  MyGlamm
//
//  Created by C711091 on 12/12/19.
//  Copyright © 2019 icici. All rights reserved.
//

import UIKit

protocol tableDataUpdate {
    func loadData(arrData:[ResturantDataModel],alertflag:Bool)

}

class ViewController: UIViewController {
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableViewZ: UITableView!
    var resturantData:[ResturantDataModel]=[]
    let apiObj = APIManager()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func searchButtonEvent(_ sender: Any) {
        self.resturantData.removeAll()
        
        
        if (searchTextField!.text!.isEmpty)
        {
            self.alert(msg: "City Should not empty")
            
            
        } else {
            let searchFieldData = self.searchTextField.text!
            
             DispatchQueue.main.async {
                self.tableViewZ.isHidden=true
                self.activityIndicatorShow()
            }
            
            DispatchQueue.global(qos: .background).async {
                self.apiObj.datafetch(text: searchFieldData)
                self.apiObj.delegate=self
            }
        }
        
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorHide()
        self.tableViewZ.isHidden=true
        tableViewZ.delegate=self
        tableViewZ.dataSource=self
        tableViewZ.register(UINib(nibName: "CellForTableView", bundle: nil), forCellReuseIdentifier: "restroCellId")

        }
    
    override func viewDidAppear(_ animated: Bool) {
  
        }
    
}


extension ViewController:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resturantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
      let cell = tableViewZ.dequeueReusableCell(withIdentifier: "restroCellId") as? CellForTableView
        cell?.restroLabel?.text = resturantData[indexPath.row].name
        cell?.rating_label?.text = resturantData[indexPath.row].aggregate_rating
        
        cell?.ratingText?.text = resturantData[indexPath.row].rating_text
        cell!.tag = indexPath.row
        cell!.restroImage.image=nil
        
        aniamtedRow(rowImage: cell!.restroImage)
        
        print("cell Return\(indexPath.row)")
        
        if(self.resturantData[indexPath.row].thumb != ""){
       
   
            var urlRequest = URLRequest(url: URL(string: self.resturantData[indexPath.row].thumb)!)
                urlRequest.httpMethod = "GET"
        
                let cache =  URLCache.shared
                if let data = cache.cachedResponse(for: urlRequest)?.data,let image = UIImage(data: data)
                {
                   cell!.restroImage.image=image
                }
                else{
                    let session = URLSession.shared
                    var imageData:UIImage?
        
                    let group = DispatchGroup()
                    group.enter()
        
                    DispatchQueue.global(qos: .background).async {
                        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
                            print(data!)
                            imageData = UIImage(data: data!)!
                            group.leave()

                        })
                        task.resume()
        
        
                    }
        
                    // does not wait. But the code in notify() gets run
                    // after enter() and leave() calls are balanced
        
            group.notify(queue: .main) {

            DispatchQueue.main.async {
            cell!.restroImage.image=imageData
            }
                        
            }
            }
            
        }
        else{
            cell!.restroImage?.image = UIImage.init(named: "Nodata")
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      //  if (shownIndexes.contains(indexPath) == false) {
         //   shownIndexes.append(indexPath)
        
            cell.transform = CGAffineTransform(translationX: 0, y: 50)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
            UIView.commitAnimations()
       // }
        print("willDisplay Index\(indexPath.row)")
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         print("didEndDisplaying  Index\(indexPath.row)")
    }
    
    
    
}


extension ViewController : tableDataUpdate{
    
    func loadData(arrData: [ResturantDataModel],alertflag:Bool) {

        if(alertflag == false)
        {
        self.resturantData=arrData

            self.activityIndicatorHide()
            print("delegate....")
            self.tableViewZ.isHidden=false
            self.tableViewZ.reloadData()
        }
        else{
        print("alert")
            self.activityIndicatorHide()

            self.alert(msg:"Something went wrong")
       
    }
    }
    
    func alert(msg:String)
    {
        
        let alert = UIAlertController(title: " Meaasge ", message:msg ,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
        }
        
    
    
    func activityIndicatorHide()  {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func activityIndicatorShow()  {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func aniamtedRow( rowImage:UIImageView)
    {
        UIView.animate(withDuration: 0.0, animations: {() -> Void in
            rowImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                rowImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    
 
}
