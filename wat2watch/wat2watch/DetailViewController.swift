//
//  DetailViewController.swift
//  wat2watch
//
//  Created by Agnivah Poddar on 3/6/16.
//  Copyright © 2016 Agnivah Poddar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
        
         let baseUrl = "http://image.tmdb.org/t/p/w500/"
        if let posterPath = movie["poster_path"] as? String{
           
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWithURL(imageUrl!)
          
        }
        else {
            let imageUrl = NSURL(string: "http://a.dilcdn.com/bl/wp-content/uploads/sites/8/2014/03/image5.jpg")
            posterImageView.setImageWithURL(imageUrl!)

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
