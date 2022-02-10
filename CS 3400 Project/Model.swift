//
//  Model.swift
//  CS 3400 Project
//
//  Created by Nathan Herskovitz on 12/6/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case dartboard
    case dart
    
    var label: String {
        get {
            switch self {
            case .dartboard:
                return "dartboard"
            case .dart:
                return "dart"
            }
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
        //self.asyncLoadModelEntity()
        
    }
    
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case.finished:
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded")
            })
    }
}

struct Models {
    var all: [Model] = []
    
    init() {
        let dartboard = Model(name: "dartboard", category: .dartboard, scaleCompensation: 0.50/100)
        let dart = Model(name: "dart", category: .dart, scaleCompensation: 0.50/100)
        
        self.all += [dartboard, dart]
        
    }
    
    func get (category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
}
