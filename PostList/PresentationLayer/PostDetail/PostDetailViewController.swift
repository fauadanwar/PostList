//
//  PostDetailViewController.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            titleLabel.text = post.title
            // Configure other UI elements with post details
        }
    }
}

