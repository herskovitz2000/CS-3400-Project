//
//  PlacementSettings.swift
//  CS 3400 Project
//
//  Last Modified by Nathan Herskovitz on 12/5/21.
//

import Combine
import RealityKit
import ARKit
import SwiftUI

class PlacementSettings: ObservableObject {
    //this property retains the cancellable object for the SceneEvents.update subscriber
    var sceneObserver: Cancellable?
    
}



