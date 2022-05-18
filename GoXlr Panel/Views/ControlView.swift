//
//  ControlView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//  Edited by Eino on 18/05/2022.
//


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

enum NoFlipEdge {
    case left, right
}

struct NoFlipPadding: ViewModifier {
    let edge: NoFlipEdge
    let length: CGFloat?
    @Environment(\.layoutDirection) var layoutDirection
    
    private var computedEdge: Edge.Set {
        if layoutDirection == .rightToLeft {
            return edge == .left ? .trailing : .leading
        } else {
            return edge == .left ? .leading : .trailing
        }
    }
    
    func body(content: Content) -> some View {
        content
            .padding(computedEdge, length)
    }
}

extension View {
    func padding(_ edge: NoFlipEdge, _ length: CGFloat? = nil) -> some View {
        self.modifier(NoFlipPadding(edge: edge, length: length))
    }
}

import SwiftUI
import ShellOut
import UniformTypeIdentifiers

struct ControlView: View {
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
    
    func ClientCommand(arg1: String, arg2: String) -> String {
        let task = Process()
        let pipe = Pipe()
        let bundle = Bundle.main
        let client = bundle.url(forResource: "goxlr-client", withExtension: nil)
        guard client != nil else {
            print("GoXLR-Client executable could not be found!")
            return("GoXLR-Client executable could not be found!")
        }
        task.executableURL = client!
        if arg1 != "" && arg2 != "" {
                task.arguments = [arg1, arg2]
        }
        if arg1 != "" && arg2 == "" {
            task.arguments = [arg1]
        }
        task.standardOutput = pipe
        task.standardError = pipe
        do {
            try task.run()
            print("Command '\(arg1)' executed successfully!")
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            return(output)
            
        } catch {
            print("Error running Command: \(error)")
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return(output)
    }
    
    func Daemon(command: String) {
        let task = Process()
        let pipe = Pipe()
        let bundle = Bundle.main
        let goxlrdaemon = bundle.url(forResource: "goxlr-daemon", withExtension: nil)
        task.executableURL = goxlrdaemon!
        task.standardOutput = pipe
        task.standardError = pipe
        if command == "start" {
            Task {
                do {
                    try task.run()
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: data, encoding: .utf8)!
                    print(output)
                    print("Daemon started successfully!")
                } catch {
                    print("Error launching Daemon: \(error)")
                }
            }
        }
        else if command == "stop" {
            do {
                let output = try shellOut(to: "/usr/bin/killall", arguments: ["goxlr-daemon"])
            print(output)
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                alertMessage = error.message
                showingAlert = true
                
            }
        }
        else {
        }
    }
    
    func GetGoXlrState() -> Array<String> {
        var returnValue = [""]
        do {
            let output = ClientCommand(arg1: "", arg2: "")
            print(output)
            let information = output.components(separatedBy: "\n")
            if information.count <= 2 {
                    return(["nil"])
            }
            let type = String(String(information[1]).suffix(5).prefix(4))
            returnValue.append(type)
            let profile = String(information[13])
            returnValue.append(profile)
            let faderA = String(information[14]).components(separatedBy: " ")[3].dropLast(1).lowercased()
            returnValue.append(faderA)
            let faderB = String(information[15]).components(separatedBy: " ")[3].dropLast(1).lowercased()
            returnValue.append(faderB)
            let faderC = String(information[16]).components(separatedBy: " ")[3].dropLast(1).lowercased()
            returnValue.append(faderC)
            let faderD = String(information[17]).components(separatedBy: " ")[3].dropLast(1).lowercased()
            returnValue.append(faderD)
            let volMic = String(String(information[18]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volMic)
            let volLineIn = String(String(information[19]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volLineIn)
            let volConsole = String(String(information[20]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volConsole)
            let volSystem = String(String(information[21]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volSystem)
            let volGame = String(String(information[22]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volGame)
            let volChat = String(String(information[23]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volChat)
            let volSample = String(String(information[24]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volSample)
            let volMusic = String(String(information[25]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volMusic)
            let volHeadphone = String(String(information[26]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volHeadphone)
            let volMonitorMic = String(String(information[27]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volMonitorMic)
            let volLineOut = String(String(information[28]).components(separatedBy: " ")[2].dropLast(1))
            returnValue.append(volLineOut)
            
        }
        return(returnValue)
    }
    

=======
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
    @State private var mic: Double = 0
    @State private var chat: Double = 0
    @State private var music: Double = 0
    @State private var game: Double = 0
    @State private var console: Double = 0
    @State private var lineIn: Double = 0
    @State private var lineOut: Double = 0
    @State private var system: Double = 0
    @State private var sample: Double = 0
    @State private var bleep: Double = 0
    @State private var headphones: Double = 0
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
    @State private var micMonitor: Double = 0
    
    @State var tabName: String? = "Mixer"
=======
    @State private var micmonitor: Double = 0
    @State var showFileChooser = false
    @State var tabname: String? = "Mixer"
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift

    let profiletype = UTType(filenameExtension: "goxlr")
    @State private var showingAlert = false
    let usrPath = FileManager.default.homeDirectoryForCurrentUser

    @State private var selectedSliderA: String = "/"
    @State private var selectedSliderB: String = "/"
    @State private var selectedSliderC: String = "/"
    @State private var selectedSliderD: String = "/"
    
    @State private var selectedmutea: String = "/"
    @State private var selectedmuteb: String = "/"
    @State private var selectedmutec: String = "/"
    @State private var selectedmuted: String = "/"
    @State private var alertMessage = "Unspecified error"
    let graycolor =  Color(white: 130, opacity: 0.03)
    func SelectsUpdate() {
        let state = GetFadersAssignement()
        if state[0] != "nil" {
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
            selectedSliderA = String(state[3])
            selectedSliderB = String(state[4])
            selectedSliderC = String(state[5])
            selectedSliderD = String(state[6])
            if state[3] == "lineIn" {
                selectedSliderA = "line-in"
            }
            if state[4] == "lineIn" {
                selectedSliderB = "line-in"
            }
            if state[5] == "lineIn" {
                selectedSliderC = "line-in"
            }
            if state[6] == "lineIn" {
                selectedSliderD = "line-in"
            }
            if state[3] == "lineOut" {
                selectedSliderA = "line-out"
            }
            if state[4] == "lineOut" {
                selectedSliderB = "line-out"
            }
            if state[5] == "lineOut" {
                selectedSliderC = "line-out"
            }
            if state[6] == "lineOut" {
=======
            selectedSliderA = String(state[1])
            selectedSliderB = String(state[2])
            selectedSliderC = String(state[3])
            selectedSliderD = String(state[4])
            if state[1] == "linein" {
                selectedSliderA = "line-in"
            }
            if state[2] == "linein" {
                selectedSliderB = "line-in"
            }
            if state[3] == "linein" {
                selectedSliderC = "line-in"
            }
            if state[4] == "linein" {
                selectedSliderD = "line-in"
            }
            if state[1] == "lineout" {
                selectedSliderA = "line-out"
            }
            if state[2] == "lineout" {
                selectedSliderB = "line-out"
            }
            if state[3] == "lineout" {
                selectedSliderC = "line-out"
            }
            if state[4] == "lineout" {
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                selectedSliderD = "line-out"
            }
        }
    }
    func MuteUpdate() {
        let mute = GetMuteBehaviours()
        selectedmutea = mute[1]
        selectedmuteb = mute[2]
        selectedmutec = mute[3]
        selectedmuted = mute[4]
    }
    func InitialUpdate() {
        let state = GetGoXlrState()
        if state[0] != "nil" {
            SelectsUpdate()
            MuteUpdate()
            var volume = 0
            volume = (Int(state[7]) ?? 0) * 255 / 100
            mic = Double(volume)
            volume = (Int(state[12]) ?? 0) * 255 / 100
            chat = Double(volume)
            volume = (Int(state[14]) ?? 0) * 255 / 100
            music = Double(volume)
            volume = (Int(state[11]) ?? 0) * 255 / 100
            game = Double(volume)
            volume = (Int(state[9]) ?? 0) * 255 / 100
            console = Double(volume)
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
            volume = (Int(state[12]) ?? 0) * 255 / 100
            lineIn = Double(volume)
            volume = (Int(state[13]) ?? 0) * 255 / 100
            lineOut = Double(volume)
            volume = (Int(state[14]) ?? 0) * 255 / 100
=======
            volume = (Int(state[8]) ?? 0) * 255 / 100
            linein = Double(volume)
            volume = (Int(state[17]) ?? 0) * 255 / 100
            lineout = Double(volume)
            volume = (Int(state[10]) ?? 0) * 255 / 100
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
            system = Double(volume)
            volume = (Int(state[13]) ?? 0) * 255 / 100
            sample = Double(volume)
            volume = (Int(state[15]) ?? 0) * 255 / 100
            headphones = Double(volume)
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
            volume = (Int(state[17]) ?? 0) * 255 / 100
            micMonitor = Double(volume)
=======
            volume = (Int(state[16]) ?? 0) * 255 / 100
            micmonitor = Double(volume)
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
        }
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10){
                        VStack(){
                            Slider(value: $mic, in: 0...255){ newProgress in
                                
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                                let roundedVal = String(format: "%.0f", mic)
                                print(ClientCommand(arg1: "--mic-volume", arg2:  roundedVal))
=======
                                let roundedvalue = String(format: "%.0f", mic)
                                print(ComplexClientCommand(arg1: "volume", arg2:  "mic", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                                    
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Mic")
                        }
                        VStack(){
                            Slider(value: $chat, in: 0...255){ newProgress in
                                
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                                let roundedVal = String(format: "%.0f", chat)
                                print(ClientCommand(arg1: "--chat-volume", arg2:  roundedVal))
=======
                                let roundedvalue = String(format: "%.0f", chat)
                                print(ComplexClientCommand(arg1: "volume", arg2:  "chat", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Chat")
                        }
                        VStack(){
                        Slider(value: $music, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                            let roundedVal = String(format: "%.0f", music)
                            print(ClientCommand(arg1: "--music-volume", arg2:  roundedVal))
=======
                            let roundedvalue = String(format: "%.0f", music)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "music", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                            
                        Text("Music")
                        }
                        VStack(){
                        Slider(value: $game, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                            let roundedVal = String(format: "%.0f", game)
                            print(ClientCommand(arg1: "--game-volume", arg2:  roundedVal))
=======
                            let roundedvalue = String(format: "%.0f", game)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "game", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Game")
                        }
                        VStack(){
                        Slider(value: $console, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                            let roundedVal = String(format: "%.0f", console)
                            print(ClientCommand(arg1: "--console-volume", arg2:  roundedVal))
=======
                            let roundedvalue = String(format: "%.0f", console)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "console", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Console")
                        }
                        VStack(){
                        
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                        Slider(value: $lineIn, in: 0...255){ newProgress in
                            let roundedVal = String(format: "%.0f", lineIn)
                            print(ClientCommand(arg1: "--line-in-volume", arg2:  roundedVal))
=======
                        Slider(value: $linein, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", linein)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "line-in", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Line-In")
                            
                        }
                        VStack(){
                        
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                        Slider(value: $lineOut, in: 0...255){ newProgress in
                            let roundedVal = String(format: "%.0f", lineOut)
                            print(ClientCommand(arg1: "--line-out-volume", arg2:  roundedVal))
=======
                        Slider(value: $lineout, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", lineout)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "line-out", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Line-Out")
                            
                        }
                        VStack(){
                            Slider(value: $system, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                                let roundedVal = String(format: "%.0f", system)
                                print(ClientCommand(arg1: "--system-volume", arg2:  roundedVal))
=======
                                let roundedvalue = String(format: "%.0f", system)
                                print(ComplexClientCommand(arg1: "volume", arg2:  "system", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("System")
                        }
                        VStack(){
                            Slider(value: $sample, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                                let roundedVal = String(format: "%.0f", sample)
                                print(ClientCommand(arg1: "--sample-volume", arg2:  roundedVal))
=======
                                let roundedvalue = String(format: "%.0f", sample)
                                print(ComplexClientCommand(arg1: "volume", arg2:  "sample", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Sample")
                        }.padding(.right, 60)
                        
                Group() {
                    VStack(){
                        Slider(value: $headphones, in: 0...255){ newProgress in
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                            let roundedVal = String(format: "%.0f", headphones)
                            print(ClientCommand(arg1: "--headphones-volume", arg2:  roundedVal))
=======
                            let roundedvalue = String(format: "%.0f", headphones)
                            print(ComplexClientCommand(arg1: "volume", arg2:  "headphones", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                    Text("Headphones")
                    }
                    VStack(){
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
                        Slider(value: $micMonitor, in: 0...255){ newProgress in
                            let roundedVal = String(format: "%.0f", micMonitor)
                                print(ClientCommand(arg1: "--mic-monitor-volume", arg2:  roundedVal))
=======
                        Slider(value: $micmonitor, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", micmonitor)
                                print(ComplexClientCommand(arg1: "volume", arg2:  "mic-monitor", arg3: roundedvalue, arg4:""))
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                    Text("Mic Monitor")
                    }
                }
                
                    }
                    .padding(.top, 40)
                    .onAppear(perform: InitialUpdate)
        }
        
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Text("Fader A")
                Picker("", selection: $selectedSliderA) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderA, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "channel", arg3:"a", arg4: self.selectedSliderA))
                        SelectsUpdate()
                })
                .padding()
            Text("Mute")
                Picker("", selection: $selectedmutea) {
                    Text("To All").tag("all")
                    Text("To Stream").tag("to-stream")
                    Text("To Chat").tag("to-voice-chat")
                    Text("To Headphones").tag("to-phones")
                    Text("To Line-Out").tag("to-line-out")
                }.onChange(of: self.selectedmutea, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "mute-behaviour", arg3:"a", arg4: self.selectedmutea))
                    SelectsUpdate()
                })
            
            }.padding()
                .background(graycolor)
            VStack(){
                Text("Fader B")
                Picker("", selection: $selectedSliderB) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }

                }.onChange(of: self.selectedSliderB, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "channel", arg3:"b", arg4: self.selectedSliderB))
                    SelectsUpdate()
            })
                .padding()
            Text("Mute")
                Picker("", selection: $selectedmuteb) {
                    Text("To All").tag("all")
                    Text("To Stream").tag("to-stream")
                    Text("To Chat").tag("to-voice-chat")
                    Text("To Headphones").tag("to-phones")
                    Text("To Line-Out").tag("to-line-out")
                }.onChange(of: self.selectedmuteb, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "mute-behaviour", arg3:"b", arg4: self.selectedmuteb))
                    SelectsUpdate()
                })
            
            }.padding()
                .background(graycolor)
            VStack(){
                Text("Fader C")
                Picker("", selection: $selectedSliderC) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderC, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "channel", arg3:"c", arg4: self.selectedSliderC))
                    SelectsUpdate()
            })
                .padding()
            Text("Mute")
                Picker("", selection: $selectedmutec) {
                    Text("To All").tag("all")
                    Text("To Stream").tag("to-stream")
                    Text("To Chat").tag("to-voice-chat")
                    Text("To Headphones").tag("to-phones")
                    Text("To Line-Out").tag("to-line-out")
                }.onChange(of: self.selectedmutec, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "mute-behaviour", arg3:"c", arg4: self.selectedmutec))
                    SelectsUpdate()
                })
            }.padding()
                .background(graycolor)
            VStack(){
                Text("Fader D")
                Picker("", selection: $selectedSliderD) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderD, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "channel", arg3:"d", arg4: self.selectedSliderD))
                    SelectsUpdate()
            })
                .padding()
            Text("Mute")
                Picker("", selection: $selectedmuted) {
                    Text("To All").tag("all")
                    Text("To Stream").tag("to-stream")
                    Text("To Chat").tag("to-voice-chat")
                    Text("To Headphones").tag("to-phones")
                    Text("To Line-Out").tag("to-line-out")
                }.onChange(of: self.selectedmuted, perform: { newValue in
                    print(ComplexClientCommand(arg1: "faders", arg2:  "mute-behaviour", arg3:"d", arg4: self.selectedmuted))
                    SelectsUpdate()
                })
            }.padding()
                .background(graycolor)
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.left, 70)
        .padding(.right, 70)
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
<<<<<<< HEAD:GoXlr Panel/ControlView.swift
            Text("Is the daemon installed?")
        }.navigationTitle(tabName!)
=======
            Text("Is the daemon installed ?")
        }.navigationTitle(tabname!)
            .fileImporter(isPresented: $showFileChooser, allowedContentTypes: [profiletype!], onCompletion: { result in
                print("Picked: \(result)")
                do{
                    var fileUrl = try result.get()
                    fileUrl = fileUrl.deletingPathExtension()
                    let strfileUrl = fileUrl.path
                    LoadProfile(url: strfileUrl)
                    
                } catch{
                                
                    print ("error reading")
                    print (error.localizedDescription)
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {showFileChooser.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }
>>>>>>> aa06427b64bab99a554f500bb2d215ca4e8d9ad9:GoXlr Panel/Views/ControlView.swift
    }
}
