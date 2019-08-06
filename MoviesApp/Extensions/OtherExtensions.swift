//
//  OtherExtensions.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 06/08/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String{
        return NSLocalizedString(self, comment: "")
    }
}
