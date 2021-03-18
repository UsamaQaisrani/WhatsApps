//
//  CommentViewController.swift
//  WhatsApps
//
//  Created by Usama on 22/02/2021.
//

import UIKit

class CommentViewController: UIViewController {
    
    //MARK:- Class Properties
    var commentInfo: UserInfo?
    var videoID: String?
    var myCommentsArray: [CommentModel]?
    
    //MARK:- @IBOutlers
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    //MARK:- Base Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        initialSetup()
        tableVIew.delegate = self
        tableVIew.dataSource = self
    }
}

//MARK:- Class Methods
extension CommentViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
}
extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCommentsArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.configureCell(comment: myCommentsArray?[indexPath.row] ?? CommentModel())
        return cell
    }
    
    func loadComments(){
        let videoViewModel = VideoViewModel()
        videoViewModel.getCommentsFromFirebase(videoID: videoID ?? "") { (commentsArray) in
            self.myCommentsArray = commentsArray
            self.tableVIew.reloadData()
        }
    }
  
    fileprivate func initialSetup(){
        loadComments()
    }
}
    //MARK:- @IBActions
extension CommentViewController{
    
    @IBAction func postButtonPressed(_ sender: Any) {
        let comment = commentTextField.text
        if comment == ""{
            print("Please Write Something")
        }
        
        else {
            let year = Date().get(.year)
            let month = Date().get(.month)
            let day = Date().get(.day)
            let hour = Date().get(.hour)
            let minute = Date().get(.minute)
            
        let commentData = CommentModel(imageURL: commentInfo?.imageURL ?? "", userID: commentInfo?.id ?? "", commentID: "", userName: commentInfo?.firstName ?? "", commentMessage: comment!, commentTime: "\(day)/\(month)/\(year) \(hour):\(minute)")
            let videoViewModel = VideoViewModel(commentModel: commentData )
            videoViewModel.postComment(videoID: videoID ?? "")
            loadComments()
        }
        
        commentTextField.text = ""
    }
}
//MARK:-Date Extension
extension Date {
    func get(_ type: Calendar.Component)-> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return (t < 10 ? "0\(t)" : t.description)
    }
}
