//
//  AlbumDetailsViewController.swift
//  LatchCoding
//
//  Created by Utsha Guha on 9-7-18.
//  Copyright © 2018 Utsha Guha. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailsViewController: UIViewController{
    
    var albumDetails = NSDictionary()
    var copyright:String = "No copyright"
    @IBOutlet weak var albumPosterView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumReleaseDate: UILabel!
    @IBOutlet weak var albumCopyright: UILabel!
    @IBOutlet weak var albumAppstoreLink: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.albumName.text = String(describing: self.albumDetails[ConstantString.AlbumNameString]!)
        self.albumArtist.text = String(describing: self.albumDetails[ConstantString.AlbumArtistName]!)
        self.albumReleaseDate.text = String(describing: self.albumDetails[ConstantString.AlbumReleaseDateString]!)
        self.albumCopyright.text = copyright
        self.albumAppstoreLink.text = String(describing: self.albumDetails[ConstantString.AlbumURLString]!)
        self.getAlbumPoster(imageURL: String(describing: self.albumDetails[ConstantString.AlbumPosterURL]!))
    }
    
    func getAlbumPoster(imageURL:String){
        let myUrl = URL(string:imageURL)
        let request = URLRequest(url:myUrl!)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if error == nil{
                DispatchQueue.main.async {
                    let posterImage = UIImage(data: data!)
                    self.albumPosterView.image = posterImage
                }
            }
        }
        task.resume()
    }
}
