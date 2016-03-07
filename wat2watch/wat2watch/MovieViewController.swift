//
//  MovieViewController.swift
//  wat2watch
//
//  Created by Agnivah Poddar on 2/19/16.
//  Copyright © 2016 Agnivah Poddar. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Foundation
import SystemConfiguration

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
 
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkView: network!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var caution: UIImageView!
  
    @IBOutlet var onTap: UITapGestureRecognizer!
    
   // var index: NSIndexPath
    var movies: [NSDictionary]?
   var filteredData: [NSDictionary]?
    var endpoint: String!
    
   
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            let isReachable = flags == .Reachable
            let needsConnection = flags == .ConnectionRequired
            
            return isReachable && !needsConnection
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            networkView.hidden = true
            
            
        } else {
            networkView.hidden = false
            //tableView.hidden = true
           
           
        }

        
       // tableView.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                 MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = self.movies
                            self.tableView.reloadData()
                          //  filteredData = movies["title"] as! String
                    }
                }
        })
                task.resume()
    }
        func refreshControlAction(refreshControl: UIRefreshControl) {
            if Reachability.isConnectedToNetwork() == true {
                networkView.hidden = true
                
            

             let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
             let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
            let request2 = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            let session2 = NSURLSession(
               configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            let task2: NSURLSessionDataTask = session2.dataTaskWithRequest(request2,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                print("response: \(responseDictionary)")
                                
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                
                                self.filteredData = self.movies
                                self.tableView.reloadData()
                                refreshControl.endRefreshing()
                        }
                    }
                    
            })
                self.tableView.alpha = 1.0
            task2.resume()
            }
            else {
                networkView.hidden = false
                self.networkView.alpha = 1.0
               // tableView.hidden = true
                self.tableView.alpha = 0.3
                self.tableView.reloadData()
                
                refreshControl.endRefreshing()
            }
               }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredData{
            return filteredData!.count
        }
        else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
       

        let movie = movies![indexPath.row]
       
       // if let posterPath = movie["poster_path"] as? String{
        if let posterPath = (filteredData![indexPath.row])["poster_path"] as? String{
            //let posterPath = movie["poster_path"] as! String
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            let imageUrl = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            //cell.posterView.setImageWithURL(imageUrl!)
            cell.posterView.setImageWithURLRequest(imageUrl,placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })

        }
        else {
            let imageUrl = NSURL(string: "http://a.dilcdn.com/bl/wp-content/uploads/sites/8/2014/03/image5.jpg")
                    }
        
     //   let posterPath = movie["poster_path"] as! String
      //  let baseUrl = "http://image.tmdb.org/t/p/w500/"
        
        //let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
       
      //  cell.titleLabel.text = movie["title"] as! String
        //cell.overviewLabel.text = movie["overview"] as! String
        cell.titleLabel?.text = (filteredData![indexPath.row])["title"] as! String
        cell.overviewLabel?.text = (filteredData![indexPath.row])["overview"] as! String
        print("Row \(indexPath.row)")
        return cell
    }
    
   /* func searchBar(searchBar: UISearchBar, textDidChange searchText: String, indexPath: NSIndexPath) {
        let data = (movies![index.row])["title"] as! [String]
        filteredData = searchText.isEmpty ? movies : (movies![indexPath.row])["title"]!.filter({(dataString: (String)) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
    } */
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies!.filter({(movie: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
            if (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                print(movie["title"])
                    return true
                } else {
                
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepare for segue called")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
    }

    
}

  /*  func onTap(sender: AnyObject) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }*/




//doubts

//older data to vanish

