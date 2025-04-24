//
//  FavouriteUsersController.swift
//  NextDayTaskApp
//
//  Created by Sourabh Modi on 31/03/25.
//

import Foundation
import UIKit

class FavouriteUsersController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var userDetailsTableView: UITableView!
    var userDetailsArray: [FavouriteUserDetailEntity] = []
    let manager = DatabaseManager()
    var isFavouriteCon: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailsTableView.dataSource = self
        let uiNib: UINib = UINib(nibName: "UserDetailsTableCell", bundle: nil)
        userDetailsTableView.register(uiNib, forCellReuseIdentifier: "user_detail_cell")
        print("View Controller is launched.......")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDetailsArray = manager.fetchUserData()
        userDetailsTableView.reloadData()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func removeAllDataButtonAction(_ sender: Any) {
        let alert = UIAlertController(
                title: "Clear Favorites",
                message: "Are you sure you want to remove all favorite users?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Yes, Remove", style: .destructive, handler: { _ in
                self.manager.removeAllFavorites()
                
                // Optionally update UI after clearing
                self.userDetailsArray.removeAll()
                self.userDetailsTableView.reloadData()
                
                // Show confirmation alert
                self.showSuccessAlert()
            }))
            
            present(alert, animated: true, completion: nil)
    }
    // Function to show confirmation alert
    func showSuccessAlert() {
        let successAlert = UIAlertController(
            title: "Success",
            message: "All favorite users have been removed.",
            preferredStyle: .alert
        )
        
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        present(successAlert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = userDetailsTableView.dequeueReusableCell(withIdentifier: "user_detail_cell", for: indexPath) as! UserDetailsTableCell
        
        let userDetails = userDetailsArray[indexPath.row]
        userCell.firstNameLabel.text = userDetails.first_name
        userCell.lastNameLabel.text = userDetails.last_name
        userCell.emailLabel.text = userDetails.email
        if let imageURL = URL(string: userDetails.avtar!) {
            userCell.avtarImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
        userCell.isFavorite = true
        return userCell
    }
    
}
