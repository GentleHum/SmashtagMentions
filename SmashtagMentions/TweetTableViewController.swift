//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Mike Vork on 12/30/16.
//  Copyright © 2016 Mike Vork. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    private struct Storyboard {
        static let tweetCellIdentifier = "tweet"
        static let mentionsSequeIdentifier = "Show Mentions"
    }
    
    private var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? = SearchList.searchTexts.first {
        didSet {
            tweets.removeAll()
            searchForTweets()
            self.navigationItem.title = searchText
            if searchText != nil {
                SearchList.add(searchText!)
            }
        }
    }
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText, !query.isEmpty {
            return TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets() { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async() {
// zap, fix                   let lastRequest = weakSelf?.lastTwitterRequest
//                    if let lastRequest = weakSelf?.lastTwitterRequest, request == lastRequest {
                    if !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, at: 0)
                    }
//                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // remove empty rows at bottom of table
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            self.searchTextField.delegate = self
            self.searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchText = textField.text
        return true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Storyboard.mentionsSequeIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? MentionsTableViewController {
                    destination.tweet = tweets[indexPath.section][indexPath.row]
                }
            }
        }
    }


}
