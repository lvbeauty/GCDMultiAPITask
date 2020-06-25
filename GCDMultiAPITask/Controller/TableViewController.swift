//
//  TableViewController.swift
//  GCDMultiAPITask
//
//  Created by Tong Yi on 6/20/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController
{
    let viewModel = ViewModel()
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    func setupViewModel()
    {
        viewModel.updateAIHandler = {
            self.tableView.reloadData()
            if self.activityIndicator.isAnimating
            {
                self.activityIndicator.stopAnimating()
            }
            else if let rC = self.refreshControl, rC.isRefreshing
            {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setupUI()
    {
        self.title = "GCD Multi-Task"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = activityIndicator
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refreshHandler), for: .valueChanged)
    }
    
    @objc func refreshHandler()
    {
        viewModel.dataSource = []
        tableView.reloadData()
        viewModel.MultiGroupTasksForFetchingData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
        cell.updateCellImage(image: nil)
        cell.configureCell(user: viewModel.dataSource[indexPath.row])
        viewModel.loadImage(row: indexPath.row) { (image) in
            cell.updateCellImage(image: image)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95
    }
}
