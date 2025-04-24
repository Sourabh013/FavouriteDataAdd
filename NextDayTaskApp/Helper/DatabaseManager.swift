//
//  DatabaseManager.swift
//  NextDayTaskApp
//
//  Created by Sourabh Modi on 31/03/25.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    // Add Users
    func addUser(user: UserDetails) {
        if !isUserAlreadyFavorite(userID: user.id) {  // Avoid duplicate entries
                    let favoriteUserEntity = FavouriteUserDetailEntity(context: context)
                    favoriteUserEntity.id = Int64(user.id)
                    favoriteUserEntity.first_name = user.first_name
                    favoriteUserEntity.last_name = user.last_name
                    favoriteUserEntity.email = user.email
                    favoriteUserEntity.avtar = user.avatar
                    
                    do {
                        try context.save()
                        print("User added to favorites successfully")
                    } catch {
                        print("Failed to save user:", error.localizedDescription)
                    }
                } else {
                    print("User is already in favorites")
                }
    }
    // Fetch Users
    func fetchUserData() -> [FavouriteUserDetailEntity] {
        var userData: [FavouriteUserDetailEntity] = []
        
        do {
            userData = try context.fetch(FavouriteUserDetailEntity.fetchRequest())
        }catch {
            print("Error in fetching data")
        }
        return userData
    }
        // Remove all Users
    func removeAllFavorites() {
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: FavouriteUserDetailEntity.fetchRequest())

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All favorite users removed successfully")
        } catch {
            print("Error deleting all favorites:", error.localizedDescription)
        }
    }
    func isUserAlreadyFavorite(userID: Int) -> Bool {
           let fetchRequest: NSFetchRequest<FavouriteUserDetailEntity> = FavouriteUserDetailEntity.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "id == %d", userID)
           
           do {
               let results = try context.fetch(fetchRequest)
               return !results.isEmpty
           } catch {
               print("Error checking existing user:", error.localizedDescription)
               return false
           }
       }
}
