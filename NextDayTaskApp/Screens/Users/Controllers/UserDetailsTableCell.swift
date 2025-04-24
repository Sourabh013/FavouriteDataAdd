//
//  UserDetailsTableCell.swift
//  NextDayTaskApp
//
//  Created by Sourabh Modi on 31/03/25.
//

import UIKit

protocol UserDetailsTableCellDelegate: AnyObject {
    func didTapFavoriteButton(for cell: UserDetailsTableCell)
}

class UserDetailsTableCell: UITableViewCell {

    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    weak var delegate: UserDetailsTableCellDelegate?
    var userDetails: UserDetails?
    var isFavorite: Bool = false {
            didSet {
                updateFavoriteButtonAppearance()
            }
        }
    var isFavouriteCon: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDesign(view: containerView)
        avtarImageView.layer.cornerRadius = 8
        avtarImageView.layer.masksToBounds = true
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favouriteButtonAction(_ sender: Any) {
        isFavorite.toggle()
               updateFavoriteButtonAppearance()
               delegate?.didTapFavoriteButton(for: self)
    }
    // Set favourite button colour
    func updateFavoriteButtonAppearance() {
        favoriteButtonOutlet.tintColor = isFavorite ? .red : .gray
       }
    func viewDesign(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
    }
}

