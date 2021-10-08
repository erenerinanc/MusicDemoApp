//
//  String+Ext.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 8.10.2021.
//

import Foundation

extension String {
    func resizeWidhtAndHeight(width: Int, height: Int) -> String {
        self.replacingOccurrences(of: "{w}", with: String(width)).replacingOccurrences(of: "{h}", with: String(height))
    }
}
