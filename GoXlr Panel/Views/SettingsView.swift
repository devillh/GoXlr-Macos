//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//  Edited by Eino on 18/05/2022.
//

import SwiftUI
import ShellOut
import SimplyCoreAudio
import CoreAudio
let simplyCA = SimplyCoreAudio()

struct SettingsView: View {
    @State var tabName: String? = "Settings"
    @State private var showingAlert = false
    @State private var showingReminder = false
    @State private var alertMessage = "Unspecified error"
    let usrPath = FileManager.default.homeDirectoryForCurrentUser

    
    var body: some View {
        
        Button("Launch Daemon") {
            do {
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-daemon", arguments: [""])
            print(output)
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                alertMessage = error.message
                showingAlert = true
                
            }
        }.padding(19)
        Text("⬇︎ If these buttons worked well once, do not click on them twice︎ ⬇︎")
            .bold()
            .italic()
            .padding()
        Button("Create audio outputs") {
            showingReminder = true
            
        }
        .alert("Please put the GoXLR as default system output", isPresented: $showingReminder) {
                    Button("Yes", role: .cancel) {
<<<<<<< HEAD:GoXlr Panel/SettingsView.swift
                        let goXlr = simplyCA.defaultOutputDevice
                        let system = simplyCA.createAggregateDevice(masterDevice: goXlr!, secondDevice: goXlr, named: "System", uid: "system")
=======
                        
                        let goxlr = simplyCA.defaultOutputDevice
                        let system = simplyCA.createAggregateDevice(masterDevice: goxlr!, secondDevice: goxlr, named: "System", uid: "system")
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/SettingsView.swift
                        system?.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: Scope.output)
                        let game = simplyCA.createAggregateDevice(masterDevice: goXlr!, secondDevice: goXlr, named: "Game", uid: "game")
                        game?.setPreferredChannelsForStereo(channels: StereoPair(left: 3, right: 4), scope: Scope.output)
                        let chat = simplyCA.createAggregateDevice(masterDevice: goXlr!, secondDevice: goXlr, named: "Chat", uid: "chat")
                        chat?.setPreferredChannelsForStereo(channels: StereoPair(left: 5, right: 6), scope: Scope.output)
                        let music = simplyCA.createAggregateDevice(masterDevice: goXlr!, secondDevice: goXlr, named: "Music", uid: "music")
                        music?.setPreferredChannelsForStereo(channels: StereoPair(left: 7, right: 8), scope: Scope.output)
                        let sample = simplyCA.createAggregateDevice(masterDevice: goXlr!, secondDevice: goXlr, named: "Sample", uid: "sample")
                        sample?.setPreferredChannelsForStereo(channels: StereoPair(left: 9, right: 10), scope: Scope.output)
                        print("Done")
                    }
        } message: {
            Text("Is the GoXLR the default output?")
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        Button("Install the daemon") {
            alertMessage = "Not yet implemented, you have to install it manually!"
            showingAlert=true
        }.navigationTitle(tabName!)
    }
}
