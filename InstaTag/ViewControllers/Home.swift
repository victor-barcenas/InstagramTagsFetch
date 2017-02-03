//
//  Home.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 03/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class Home:UIViewController{
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var tagField: UITextField!
    
    var images:Array<(key: String, val: String)> = Array()
    var isStandardCell:Bool = false
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoom" {
            let zoom:ZoomedImage = segue.destination as! ZoomedImage
            zoom.selectedImage = selectedImage!
        }
    }
    
    @IBAction func searchTagAction(_ sender: Any) {
        images.removeAll()
        let tag:String = tagField.text!
        let token:String = UserDefaults.standard.object(forKey: "accesToken") as! String
        let url:String = Constants.Instagram.api + "tags/\(tag)/media/recent?&next_max_id=0&access_token=" + token
        RESTClient().GET(sender: self, url: url, delegate: self, service: .GetMediaByTag)
        tagField.text = ""
        tagField.resignFirstResponder()
    }
    
    @IBAction func editAction(_ sender: Any) {
        postsTableView.isEditing = !postsTableView.isEditing
    }
}

extension Home:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageUrl:(key: String, val: String) = images[indexPath.row]
        let placeholder:UIImage = UIImage(named: "placeholder")!
        if imageUrl.key == "thumb" {
            let standarCell:ThumbnailCell = tableView.dequeueReusableCell(withIdentifier: imageUrl.key) as! ThumbnailCell
            standarCell.postImage.af_setImage(
                withURL: URL(string: imageUrl.val)!,
                placeholderImage: placeholder,
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
            isStandardCell = false
            return standarCell
        }
        isStandardCell = true
        let thumbnailCell:StandarCell = tableView.dequeueReusableCell(withIdentifier: imageUrl.key) as! StandarCell
        thumbnailCell.postImage.af_setImage(
            withURL: URL(string: imageUrl.val)!,
            placeholderImage: placeholder,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        return thumbnailCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let imageUrl:(key: String, val: String) = images[indexPath.row]
        if imageUrl.key == "thumb" {
            let cell:ThumbnailCell = tableView.cellForRow(at: indexPath) as! ThumbnailCell
            selectedImage = cell.postImage.image
        }else{
            let cell:StandarCell = tableView.cellForRow(at: indexPath) as! StandarCell
            selectedImage = cell.postImage.image
        }
        performSegue(withIdentifier: "zoom", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isStandardCell{
            return 375
        }
        return 205
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = images[sourceIndexPath.row]
        images.remove(at: sourceIndexPath.row)
        images.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension Home:RESTClientDelegate{
    func successWithArray(response: Array<AnyObject>, service:ServiceType){
        print(response)
    }
    
    func successWithDictionary(response: Dictionary<String, AnyObject>, service:ServiceType){
        print(response["data"]!)
        let posts:Array<Dictionary<String,AnyObject>> = response["data"] as! Array<Dictionary<String,AnyObject>>
        for postDictionary in posts{
            let post:Post = Post(dictionary: postDictionary)
            if let standar = post.images["standard_resolution"]{
                images.append((key: "standar", val:standar["url"] as! String))
            }
            if let thumbnail = post.images["thumbnail"]{
                images.append((key: "thumb", val:thumbnail["url"] as! String))
                images.append((key: "thumb", val:thumbnail["url"] as! String))
            }
        }
        postsTableView.reloadData()
    }
    
    func errorWithNSError(error:Error){
        print(error.localizedDescription)
    }
}
