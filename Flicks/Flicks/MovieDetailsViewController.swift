//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Prasanthi Relangi on 2/5/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieFullResImage: UIImageView!
    var movie:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movie)
        let title = movie["title"] as! NSString
        let overview = movie["overview"] as! NSString
        
        overviewLabel.text = overview as String
        titleLabel.text = title as String
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            movieFullResImage.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image that you include as an asset
            movieFullResImage.image = nil
        }

        // Do any additional setup after loading the view.
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
