//
//  String+DateFormatter.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

extension String {
    func dayDateFormat() -> String {
        let df = DateFormatter()

        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateFormatted = df.date(from: self) else { return ""}

        df.dateFormat = "EEEE"
        return df.string(from: dateFormatted)
    }
}
