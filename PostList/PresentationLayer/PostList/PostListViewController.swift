//
//  PostListViewController.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import UIKit
import Combine

class PostListViewController: UIViewController {
    private var viewModel = PostsViewModel()
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchModels()
    }
    
    private func bindViewModel() {
        // Observe changes in ViewModel's posts
        viewModel.$posts
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostDetailViewControllerSegue" {
            if let indexPath = sender as? IndexPath,
               let detailVC = segue.destination as? PostDetailViewController {
                let post = viewModel.posts[indexPath.row]
                detailVC.post = post
            }
        }
    }
    
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let post = viewModel.posts[indexPath.row]
        content.text = "\(post.id)"
        content.secondaryText = post.title
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.posts.count - 1 {
            viewModel.fetchModels()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "PostDetailViewControllerSegue", sender: indexPath)
    }
}
