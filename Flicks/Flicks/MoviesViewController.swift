//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Prasanthi Relangi on 2/5/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    @IBOutlet weak var networkELabel: UILabel!
    var endPoint: NSString!
    
    //variables for searchBar support
    var searchActive : Bool = false
    var filtered:[NSDictionary] = []
    var movieTitles: [String] = []
    var picCollectionViewEnabled: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set tableViews dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        //Set collectionViews dataSource and delegate
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        
        //Set up searchBar delegate
        searchBar.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //Make network call
        fetchData()
        
        let collectionImage = UIImage(named:"Grid-24")
        let rightBarButton = UIBarButtonItem(image: collectionImage, style: UIBarButtonItemStyle.Plain, target: self, action: "displayCollectionView")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    
    func displayCollectionView() {
        picCollectionViewEnabled = !picCollectionViewEnabled
        
        if(picCollectionViewEnabled) {
            movieCollectionView.hidden = false
            tableView.hidden = true
            movieCollectionView.reloadData()
        }
        else {
            tableView.hidden = false
            movieCollectionView.hidden = true
            tableView.reloadData()
            
        }
        
    }
    
    func refreshControlAction(refreshControl:UIRefreshControl ) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            
                            self.tableView.reloadData()
                            
                            refreshControl.endRefreshing()
                            
                    }
                }
                if let networkError = error {
                    self.networkELabel.hidden = false
                    self.networkELabel.text = "Network Error!!"
                    self.tableView.hidden = true
                    
                    
                    
                }
        });
        task.resume()
        
    }
    

    func fetchData() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            
                            self.tableView.reloadData()
                            
                            
                    }
                }
                if let networkError = error {
                    self.networkELabel.hidden = false
                    self.networkELabel.text = "Network Error!!"
                    self.tableView.hidden = true
                    
                    
                    
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_movies_count()-> Int {
        if searchActive == true {
            return filtered.count
        }
        else if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
        
    }
    
    //********* Table View methods ********
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get_movies_count()
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        var movie:NSDictionary = [:]
        if(searchActive) {
            movie = filtered[indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = "\(title)"
        cell.overviewLabel.text = "\(overview)"
        
        //Set the selection style to None; 
        cell.selectionStyle = .None
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let smallImageBaseUrl = "https://image.tmdb.org/t/p/w45"
            let largeImageBaseUrl = "https://image.tmdb.org/t/p/original"
            let smallImageUrl = NSURL(string: smallImageBaseUrl + posterPath)
            let largeImageUrl = NSURL(string: largeImageBaseUrl+posterPath)
            
            let smallImageRequest = NSURLRequest(URL: smallImageUrl!)
            let largeImageRequest = NSURLRequest(URL: largeImageUrl!)
            
            cell.movieImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.movieImageView.alpha = 0.0
                    cell.movieImageView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        cell.movieImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.movieImageView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    cell.movieImageView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                                    cell.movieImageView.image = smallImage

                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
                    cell.movieImageView.image = nil

            })
            
            //let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            //cell.movieImageView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image that you include as an asset
            cell.movieImageView.image = nil
        }
        
        

        
        
        return cell
    }
    
    //****** COLLECTION VIEW METHODS *********
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return get_movies_count()
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.row]
        cell.picTitle.text = movie["title"] as? String
        
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            cell.picView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image that you include as an asset
            cell.picView.image = nil
        }
        
        return cell
        
    }

    //Search Bar functions
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = movies!.filter({ (text) -> Bool in
            let tmp: NSString = text["title"] as! NSString
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        //print("Filtered count \(filtered.count)")
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath:NSIndexPath
        var tableCell:UITableViewCell
        var collectionCell:UICollectionViewCell
        
        
        if(picCollectionViewEnabled) {
            collectionCell = sender as! UICollectionViewCell
            indexPath = movieCollectionView.indexPathForCell(collectionCell)!
        }
        else {
            
            tableCell = sender as! UITableViewCell
            indexPath = tableView.indexPathForCell(tableCell)!
        }
        
        
        
        let movie = movies![indexPath.row]
        let detailVC = segue.destinationViewController as! MovieDetailsViewController
        detailVC.movie = movie
        
    }
    

}
