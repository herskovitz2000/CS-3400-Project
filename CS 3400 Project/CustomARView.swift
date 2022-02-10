//
//  CustomARView.swift
//  CS 3400 Project
//
//  Created by Nathan Herskovitz on 12/5/21.
//

import RealityKit
import ARKit
import FocusEntity

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    
    //var items: [Model]
    
    
    required init(frame frameRect: CGRect){
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        //asynchronously load both models as soon as app launches
        let models = Models()
        models.all[0].asyncLoadModelEntity()
        models.all[1].asyncLoadModelEntity()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical]
        session.run(config)
        
        
    }
}
