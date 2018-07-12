//
//  ViewController.swift
//  LatchCoding
//
//  Created by Utsha Guha on 9-7-18.
//  Copyright © 2018 Utsha Guha. All rights reserved.
//

import UIKit
import CoreData

struct ConstantString {
    static let AlbumEntity                  = "Album"
    static let AlbumEntityAttribute         = "albumData"
    static let CopyrightDefaultString       = "No Copyright"
    static let BlankString                  = ""
    static let FetchAlbumURL                = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/50/non-explicit.json"
    static let AlbumDetailsSegue            = "getDetails"
    static let ResponseFeedString           = "feed"
    static let ResponseResultsString        = "results"
    static let CopyrightString              = "copyright"
    static let IdString                     = "id"
    static let AlbumCellID                  = "albumCellId"
    static let AlbumPosterURL               = "artworkUrl100"
    static let AlbumNameString              = "name"
    static let AlbumArtistName              = "artistName"
    static let AlbumReleaseDateString       = "releaseDate"
    static let AlbumURLString               = "url"
    static let FailedString                 = "Failed"
    static let FailedSaveString             = "Failed saving"
}



class ViewController: UIViewController,UITableViewDataSource {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var testimage: UIImageView!
    var albumArray:[Dictionary<String,Any>] = []
    var copyright:String = ConstantString.CopyrightDefaultString
    var sortOnline = [String]()
    var sortOffline = [String]()
    
    let constantString:String = ConstantString.BlankString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ConstantString.AlbumEntity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0 {
                self.fetchTopAlbums()
            }
            else{                
                self.fetchOfflineRecord(fetchOnlineRecord: fetchOnlineRecord)
            }
        } catch {
            print(ConstantString.FailedString)
        }
        do {
            try context.save()
        } catch {
            print(ConstantString.FailedSaveString)
        }
    }
        
    func fetchOfflineRecord(fetchOnlineRecord: ([Dictionary<String,Any>]) -> ()) {
        var offlineArray:[Dictionary<String,Any>] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ConstantString.AlbumEntity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let myData = data.value(forKey: ConstantString.AlbumEntityAttribute) as! Data
                let responseDictionary = try? JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String, Any>
                let feedDictionary:Dictionary = responseDictionary?[ConstantString.ResponseFeedString] as! Dictionary<String,Any>
                    
                self.albumArray .removeAll()
                    
                self.albumArray = (feedDictionary[ConstantString.ResponseResultsString] as! [Dictionary<String, Any>]?)!
                
                offlineArray = self.albumArray
                if (self.albumTableView != nil) {
                    self.albumTableView.reloadData()
                }
                
            }
        } catch {
            
            print(ConstantString.FailedString)
        }
        do {
            try context.save()
        } catch {
            print(ConstantString.FailedSaveString)
        }
        fetchOnlineRecord(offlineArray)
    }
    
    func fetchOnlineRecord(offlineArray: [Dictionary<String,Any>]) {
        var onlineArray:[Dictionary<String,Any>] = []
        let urlString:String = ConstantString.FetchAlbumURL
        let myUrl = URL(string:urlString)
        let request = URLRequest(url:myUrl!)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if error == nil{
                self.activityIndicator.stopAnimating()
                let responseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                let feedDictionary:Dictionary = responseDictionary?[ConstantString.ResponseFeedString] as! Dictionary<String,Any>
                onlineArray = (feedDictionary[ConstantString.ResponseResultsString] as! [Dictionary<String, Any>]?)!
                self.copyright = feedDictionary[ConstantString.CopyrightString] as! String
                self.sortOffline = offlineArray.sorted(by: {(i,j) in
                    let d1 = String(describing: i[ConstantString.IdString]!)
                    let d2 = String(describing: j[ConstantString.IdString]!)
                    return Int(d1)!<Int(d2)!
                }).map{
                    return String(describing: $0[ConstantString.IdString]!)
                }
                
                self.sortOnline = onlineArray.sorted(by: {(i,j) in
                    let d1 = String(describing: i[ConstantString.IdString]!)
                    let d2 = String(describing: j[ConstantString.IdString]!)
                    return Int(d1)!<Int(d2)!
                }).map{
                    return String(describing: $0[ConstantString.IdString]!)
                }
                if self.sortOffline == self.sortOnline{
                    print("Same")
                }
                else{
                    self.albumArray.removeAll()
                    self.albumArray = onlineArray
                    self.albumTableView.reloadData()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: ConstantString.AlbumEntity, in: context)
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: ConstantString.AlbumEntity)
                    request.returnsObjectsAsFaults = false
                    do {
                        let result = try context.fetch(request)
                        if result.count>0{
                            context.delete(result.first as! NSManagedObject)
                        }
                    } catch {
                        print(ConstantString.FailedString)
                    }
                    
                    let newAlbum = NSManagedObject(entity: entity!, insertInto: context)
                    newAlbum.setValue(data, forKey: ConstantString.AlbumEntityAttribute)
                    do {
                        try context.save()
                    } catch {
                        print(ConstantString.FailedSaveString)
                    }
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTopAlbums() {
        //activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let urlString:String = ConstantString.FetchAlbumURL
        let myUrl = URL(string:urlString)
        let request = URLRequest(url:myUrl!)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if error == nil{
                self.activityIndicator.stopAnimating()
                let responseDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                let feedDictionary:Dictionary = responseDictionary?[ConstantString.ResponseFeedString] as! Dictionary<String,Any>
                self.albumArray = (feedDictionary[ConstantString.ResponseResultsString] as! [Dictionary<String, Any>]?)!
                if (self.albumTableView != nil)
                {
                    self.albumTableView.reloadData()
                }
                self.copyright = feedDictionary[ConstantString.CopyrightString] as! String
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: ConstantString.AlbumEntity, in: context)
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: ConstantString.AlbumEntity)
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    if result.count>0{
                        context.delete(result.first as! NSManagedObject)
                    }
                } catch {
                    print(ConstantString.FailedString)
                }
                
                let newAlbum = NSManagedObject(entity: entity!, insertInto: context)
                newAlbum.setValue(data, forKey: ConstantString.AlbumEntityAttribute)
                do {
                    try context.save()
                } catch {
                    print(ConstantString.FailedSaveString)
                }
            }
        }
        task.resume()
    }
    
    /***********************************************************************/
    
    // Method Description: Table View Datasource methods
    
    /***********************************************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ArtistCellViewModel = tableView .dequeueReusableCell(withIdentifier: ConstantString.AlbumCellID, for: indexPath) as! ArtistCellViewModel
        var album:[String:Any] = self.albumArray[indexPath.row]
        let albumPosterURL:String = (album[ConstantString.AlbumPosterURL] as! String?)!
        let myUrl = URL(string:albumPosterURL)
        let request = URLRequest(url:myUrl!)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if error == nil{
                DispatchQueue.main.async {
                    let posterImage = UIImage(data: data!)!
                    cell.albumThumbnail.image = posterImage
                    cell.albumNameField?.text = album[ConstantString.AlbumNameString] as! String?
                    cell.artistNameField?.text = album[ConstantString.AlbumArtistName] as! String?
                }
            }
        }
        task.resume()
        return cell
    }
    /***********************************************************************/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConstantString.AlbumDetailsSegue {
            let vc = segue.destination as! AlbumDetailsViewController
            let selectedObject = self.albumArray[(self.albumTableView.indexPathForSelectedRow?.row)!] as NSDictionary
            vc.albumDetails = selectedObject
            vc.copyright = copyright
        }
    }
}

