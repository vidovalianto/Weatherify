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

    public func removeCity(for name: String) {
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
            cities.forEach({ city in
                let cityName = city.value(forKey: "name") as! String
                if name == cityName {
                    managedContext.delete(city)
                }
            })
            try managedContext.save()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }

        self.fetchCoreData()
    }

    public func saveCity(for name: String) {
        if CoreDataManager.shared.cities.contains(name) || name.trimmingCharacters(in: .whitespaces).isEmpty { return }

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "FavoriteCity",
                                       in: managedContext)!

        let city = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        // 3
        city.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        self.fetchCoreData()
    }
}
