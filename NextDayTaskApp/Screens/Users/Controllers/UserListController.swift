//
//  ViewController.swift
//  NextDayTaskApp
//
//  Created by Sourabh Modi on 31/03/25.
//

import UIKit
import Foundation
import SDWebImage

class UserListController: UIViewController, UITableViewDataSource, UserDetailsTableCellDelegate, UITableViewDelegate {
    

    @IBOutlet weak var userListTableView: UITableView!
    var userDetailsArray: [UserDetails] = []
    let databaseManager = DatabaseManager()
    var favoriteUsers: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserDetails()
        userListTableView.dataSource = self
        userListTableView.delegate = self
        let uiNib: UINib = UINib(nibName: "UserDetailsTableCell", bundle: nil)
        userListTableView.register(uiNib, forCellReuseIdentifier: "user_detail_cell")
        print("View Controller is launched.......")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListTableView.reloadData()
    }
    @IBAction func seeFavouriteButtonAction(_ sender: Any) {
         let favoriteUserCon = storyboard?.instantiateViewController(withIdentifier: "favourite_users_con") as! FavouriteUsersController
        favoriteUserCon.isFavouriteCon = true
        present(favoriteUserCon, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = userListTableView.dequeueReusableCell(withIdentifier: "user_detail_cell", for: indexPath) as! UserDetailsTableCell
        
        let userDetails = userDetailsArray[indexPath.row]
        userCell.firstNameLabel.text = userDetails.first_name
        userCell.lastNameLabel.text = userDetails.last_name
        userCell.emailLabel.text = userDetails.email
        if let imageURL = URL(string: userDetails.avatar) {
            userCell.avtarImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
        userCell.userDetails = userDetails
        userCell.delegate = self
        userCell.isFavorite = favoriteUsers.contains(userDetails.id)
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCell = userListTableView.dequeueReusableCell(withIdentifier: "user_detail_cell", for: indexPath) as! UserDetailsTableCell
        
        userCell.contentView.backgroundColor = .white
            
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Implement delegate for add favourite icon
    func didTapFavoriteButton(for cell: UserDetailsTableCell) {
        guard let indexPath = userListTableView.indexPath(for: cell) else { return }
            let user = userDetailsArray[indexPath.row]

            if favoriteUsers.contains(user.id) {
                favoriteUsers.remove(user.id)
            } else {
                if !databaseManager.isUserAlreadyFavorite(userID: user.id) {
                    favoriteUsers.insert(user.id)
                    databaseManager.addUser(user: user)
                    showAlert(for: user)
                } else {
                    print("User is already in favorites, no need to add again.")
                }
            }
        }

        func showAlert(for user: UserDetails) {
            let alert = UIAlertController(title: "Added to Favorites", message: "\(user.first_name) \(user.last_name) has been added.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    // Get user data from API and store in local DB
    func getUserDetails() {
        print("Get User data is called......")
        let getUserData = GetUserDetails()
        getUserData.getUserData { result in
            switch result {
            case .success(let response):
                print("Get user data is successfull",response.data.count)
                self.userDetailsArray = response.data
                DispatchQueue.main.async {
                    self.userListTableView.reloadData()
                }
                print("Count of user Data array",self.userDetailsArray.count)
            case .failure(let error):
                print("Error in getting user data",error.localizedDescription)
            }
        }
    }
}

