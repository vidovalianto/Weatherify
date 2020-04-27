//
//  CoreDataManager.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/26/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import CoreData
import Foundation
import UIKit

public class CoreDataManager {
    public static let shared = CoreDataManager()

    @Published
    public var cities = [String]()

    private init() { self.fetchCoreData() }

    public func fetchCoreData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext =
          appDelegate.persistentContainer.viewContext

        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "FavoriteCity")

        do {
            let cities = try managedContext.fetch(fetchRequest)
            self.cities = cities.map({ city -> String in
                city.value(forKey: "name") as! String
            })
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
