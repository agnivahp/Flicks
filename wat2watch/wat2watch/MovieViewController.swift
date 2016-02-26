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
class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
                            self.tableView.reloadData()
                    }
                }
        })
                task.resume()
        func refreshControlAction(refreshControl: UIRefreshControl) {
            // let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            // let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
                                
                                self.movies = responseDictionary["results"] as! [NSDictionary]
                                
                                
                                self.tableView.reloadData()
                                refreshControl.endRefreshing()
                        }
                    }
                    
            })
        
        task2.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies{
            return movies.count
        }
        else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        

        let movie = movies![indexPath.row]
        if let posterPath = movie["poster_path"] as? String{
            //let posterPath = movie["poster_path"] as! String
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        else {
            let imageUrl = NSURL(string: "http://a.dilcdn.com/bl/wp-content/uploads/sites/8/2014/03/image5.jpg")
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
     //   let posterPath = movie["poster_path"] as! String
      //  let baseUrl = "http://image.tmdb.org/t/p/w500/"
        
        //let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
       
        cell.titleLabel.text = movie["title"] as! String
        cell.overviewLabel.text = movie["overview"] as! String
        print("Row \(indexPath.row)")
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
