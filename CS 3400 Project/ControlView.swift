//
//  ControlView.swift
//  CS 3400 Project
//
//  Created by Nathan Herskovitz on 12/4/21.
//

import SwiftUI

struct ControlView: View{
    //gives ControlView access to isControlsVisible
    @Binding var isControlsVisible: Bool
    //gives ControlView access to showSettings
    @Binding var showSettings: Bool
    @Binding var placeBoardPressed: Bool
    var body: some View {
        VStack {
            ControlVisibilityToggleButton(isControlsVisible: $isControlsVisible)
            
            Spacer()
            if isControlsVisible {
                ControlButtonBar(isControlsVisible: $isControlsVisible, showSettings: $showSettings, placeBoardPressed: $placeBoardPressed)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var isControlsVisible: Bool
    var body: some View {
        HStack {
            
        }
    }
}

//code for three buttons in control bar located at bottom of the screen
struct ControlButtonBar: View {
    //gives ControlButtonBar access to isControlsVisible
    @Binding var isControlsVisible: Bool
    //gives ControlButtonBar access to showSettings
    @Binding var showSettings: Bool
    //create boolean state placeBoardPressed
    @Binding var placeBoardPressed: Bool
    
    let models = Models()
    
    var body: some View {
        HStack {

            //place/remove dartboard button
            ControlButton(systemIconName: "target") {
                print("Place/ Remove Target Button Pressed")
                //when target button is pressed, the controls will disappear until the user places the board
                //self.isControlsVisible.toggle()
                //place dart board
                placeBoardPressed = true
            }
            
            Spacer()
            
            //throw dart button
            ControlButton(systemIconName: "arrow.up") {
                print("Throw dart button pressed")
            }
            
            Spacer()
            
            //show settings button
            ControlButton(systemIconName: "slider.horizontal.3") {
                print("Settings Button Pressed.")
                self.showSettings.toggle()
            }.sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings)
            }
            
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color.black
                        .opacity(0.25))
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
    }
}
