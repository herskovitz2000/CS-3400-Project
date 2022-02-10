//
//  ContentView.swift
//  CS 3400 Project
//
//  Last Modified by Nathan Herskovitz on 12/3/21.
//

import SwiftUI
import RealityKit
import Combine


var sceneEventsUpdateSubscription: Cancellable!//this struct controls what is on the screen. When app launches will go into AR view and have a control bar on the bottom to place/move datboard, throw darts, and adjust settings
struct ContentView : View {
    //creates a boolean state called isControlsVisible
    @State private var isControlsVisible: Bool = true
    //creates a boolean state called showSettings
    @State private var showSettings: Bool = false
    
    @State var placeBoardPressed: Bool = false

    var body: some View {
        //Initial test to see if project is set up correctly
        //Text("Hello World")
        
        ZStack(alignment: .bottom) {
            //ARView will take up majority of screen
            ARViewContainer(placeBoardPressed: $placeBoardPressed)
            
            //control view is located on the bottom of the screen and contains buttons for placing/moving the dart board, throwing the dart, and opening the settings
            ControlView(isControlsVisible: $isControlsVisible, showSettings: $showSettings, placeBoardPressed: $placeBoardPressed)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    //@EnvironmentObject var placementSettings: PlacementSettings
    @Binding var placeBoardPressed: Bool
    let models = Models()
    let entity = try? Entity.loadModel(named: "dartboard.usdz")
    let entity2 = try? Entity.loadModel(named: "dart.usdz")
    
    
    func makeUIView(context: Context) -> CustomARView {
        
        let arView = CustomARView(frame: .zero)
        
        //subscribe to SceneEvents.update
        sceneEventsUpdateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { (event) in
            self.updateScene(for: arView)
        }
        
        self.updateScene(for: arView)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    private func updateScene(for arView: CustomARView){
        
        //print("update scene method called")
        //only display focus entity when dart board is not placed
        //arView.focusEntity?.isEnabled = (boolean state value that will be toggled when dart board is placed/removed)
        //models.all[0].asyncLoadModelEntity()
        
        
        //add dart board to scene if user presses palce board button
        //self.place(dartBoard, in: arView)
        
        if placeBoardPressed == true {
            self.placeDartBoard(entity!, in:arView)
            self.placeDart(entity2!, in:arView)
            placeBoardPressed = false
            
        }
        
    }
    
    public func placeDartBoard(_ modelEntity: ModelEntity, in arView: ARView){
        
    //1. create clone of dart board model entity
        //let clonedEntity = modelEntity.clone(recursive: true)
        
    //2. enable translation and rotation gestures
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: modelEntity)
        
    //rotate cloned entity
        let radians = 90.0 * Float.pi / 180.0
        
        modelEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: -1, y: 0, z: 0))
        
    //3. create an anchorEntity and add clonedEntity to the anchorEntity
        let anchorEntity = AnchorEntity(plane: .vertical)
        anchorEntity.addChild(modelEntity)
        
    //4. Add the anchorEntity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
    print("Added model entity to scene")
        
    }
    
    public func placeDart(_ modelEntity: ModelEntity, in arView: ARView) {
        //let clonedEntity = modelEntity.clone(recursive: true)
        
        modelEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: modelEntity)
        
        if let currentFrame = arView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.3
            let transform = simd_mul(currentFrame.camera.transform, translation)
            let anchorEntity = AnchorEntity(world: transform)
            anchorEntity.addChild(modelEntity)
            
            arView.scene.addAnchor(anchorEntity)
        }
        
        
        
    }
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
@Binding var placeBoardPressed: Bool
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
            .environmentObject(SessionSettings())
    }
}
#endif
 
