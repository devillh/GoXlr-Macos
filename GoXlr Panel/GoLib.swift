//
//  GoLib.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 5/12/22.
//  Edited by Eino on 18/05/2022.
//

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

import Foundation
import SwiftUI
import ShellOut
import UniformTypeIdentifiers

func ClientCommand(arg1: String, arg2: String) -> String {
    let task = Process()
    let pipe = Pipe()
    let bundle = Bundle.main
    let client = bundle.url(forResource: "goxlr-client", withExtension: nil)

    guard client != nil else {
        print("GoXlr-Client executable could not be found!")
        return("GoXlr-Client executable could not be found!")
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

func ComplexClientCommand(arg1: String, arg2: String, arg3: String, arg4: String) -> String {
    let task = Process()
    let pipe = Pipe()
    let bundle = Bundle.main
    let client = bundle.url(forResource: "goxlr-client", withExtension: nil)

    guard client != nil else {
        print("GoXlr-Client executable could not be found!")
        return("GoXlr-Client executable could not be found!")
    }
    task.executableURL = client!
    if arg1 != "" && arg2 != "" && arg3 == "" && arg4 == ""{
            task.arguments = [arg1, arg2]
    }
    if arg1 != "" && arg2 != "" && arg3 != "" && arg4 != "" {
        task.arguments = [arg1, arg2, arg3, arg4]
    }
    if arg1 != "" && arg2 != "" && arg3 != "" && arg4 == "" {
        task.arguments = [arg1, arg2, arg3]
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
    let goXlrDaemon = bundle.url(forResource: "goxlr-daemon", withExtension: nil)

    task.executableURL = goXlrDaemon!
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
        }
    }
    else {
    }
}

func GetGoXlrRouting() -> Array<Bool> {
    var returnValue: Array<Bool> = []
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let information = output.components(separatedBy: "\n")
        if information.count <= 2 {
                return([false])
        }
        //mic -> stream
        if String(information[35])[19] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //mic -> chat
        if String(information[37])[19] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //mic -> headphones
        if String(information[34])[19] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //mic -> line out
        if String(information[36])[19] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //mic -> sampler
        if String(information[38])[19] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        
        //chat -> stream
        if String(information[35])[29] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //chat -> headphones
        if String(information[34])[29] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //chat -> line out
        if String(information[36])[29] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //chat -> sampler
        if String(information[38])[29] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //music -> stream
        if String(information[35])[37] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //music -> chat
        if String(information[37])[37] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //music -> headphones
        if String(information[34])[37] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //music -> line-out
        if String(information[36])[37] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //music -> sampler
        if String(information[38])[37] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //game -> stream
        if String(information[35])[44] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //game ->chat
        if String(information[37])[44] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //game ->headphones
        if String(information[34])[44] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //game ->line-out
        if String(information[36])[44] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //game -> sampler
        if String(information[38])[44] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //console -> stream
        if String(information[35])[53] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //console -> chat
        if String(information[37])[53] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //console -> headphones
        if String(information[34])[53] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //console ->line out
        if String(information[36])[53] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //console -> sampler
        if String(information[38])[53] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //line-in -> stream
        if String(information[35])[62] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //line-in -> chat
        if String(information[37])[62] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //line-in -> headphones
        if String(information[34])[62] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //line-in -> line-out
        if String(information[36])[62] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //line-in -> sampler
        if String(information[38])[62] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //system -> stream
        if String(information[35])[71] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //system -> chat
        if String(information[37])[71] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //system -> headphones
        if String(information[34])[71] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //system -> line-out
        if String(information[36])[71] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //system -> sampler
        if String(information[38])[71] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}

        //sampler -> stream
        if String(information[35])[81] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //sampler ->chat
        if String(information[37])[81] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //sampler -> headphones
        if String(information[34])[81] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
        //sampler -> lineOut
        if String(information[36])[81] == "X" {returnValue.append(true)}
        else {returnValue.append(false)}
    }
    return(returnValue)
}

func GetGoXlrState() -> Array<String> {
    var returnValue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
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
        let volHeadphones = String(String(information[26]).components(separatedBy: " ")[2].dropLast(1))
        returnValue.append(volHeadphones)
        let volMicMonitor = String(String(information[27]).components(separatedBy: " ")[2].dropLast(1))
        returnValue.append(volMicMonitor)
        let volLineOut = String(String(information[28]).components(separatedBy: " ")[2].dropLast(1))
        returnValue.append(volLineOut)
    }
    return(returnValue)
}

func LoadProfile(url: String) {
    ClientCommand(arg1: "--load-profile", arg2: url)
}

func SaveProfile() {
    ClientCommand(arg1: "--save-profile", arg2: "")
}

func GoXlrConnected() -> String {
    if ClientCommand(arg1: "--status", arg2: "").contains("Error: Could not connect to the GoXLR daemon process") {
        return("no")
    }
    else if ClientCommand(arg1: "--status", arg2: "").contains("Error: Multiple GoXLR devices are connected, please specify which one to control") {
        return("no")
    }
    else {
        return("yes")
    }
}

func LaunchDaemon() {
    Daemon(command:"start")
    if ClientCommand(arg1: "--status", arg2: "").contains("Error: Could not connect to the GoXLR daemon process") {
        sleep(1)
    }
}

func ToggleRouting(chanIn: String, chanOut: String, state: Bool) {
    var status = ""
    if state {
        status = "true"
    }
    if state == false {
        status = "false"
    }
    print(ComplexClientCommand(arg1: "router", arg2: chanIn, arg3: chanOut, arg4: status))
}

func cBool(i: String) -> Bool {
    if i == "true" {return(true)}
    else if i == "false" {return(false)}
    else {return false}
}

func FirstGetRouting() -> Array<Bool> {
    LaunchDaemon()
    return(GetGoXlrRouting())
}

func RoutingSectionsList() -> [SectionsList] {
    LaunchDaemon()
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let information = output.components(separatedBy: "\n")

        if information.count <= 2 {
            let sectionsList: [SectionsList] = [
                SectionsList(label: "", enabled: false),
                SectionsList(label: "", enabled: false)
            ]
            return(sectionsList)
        }

        let sections: [SectionsList] = [
            SectionsList(label: "micStream", enabled: {if String(information[35])[19] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "micChat", enabled: {if String(information[37])[19] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "micHead", enabled: {if String(information[34])[19] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "micLine", enabled: {if String(information[36])[19] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "micSampler", enabled: {if String(information[38])[19] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "chatStream", enabled: {if String(information[35])[29] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "chatHead", enabled: {if String(information[34])[29] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "chatLine", enabled: {if String(information[36])[29] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "chatSampler", enabled: {if String(information[38])[29] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "musicStream", enabled: {if String(information[35])[37] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "musicChat", enabled: {if String(information[37])[37] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "musicHead", enabled: {if String(information[34])[37] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "musicLine", enabled: {if String(information[36])[37] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "musicSampler", enabled: {if String(information[38])[37] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "gameStream", enabled: {if String(information[35])[44] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "gameChat", enabled: {if String(information[37])[44] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "gameHead", enabled: {if String(information[34])[44] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "gameLine", enabled: {if String(information[36])[44] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "gameSampler", enabled: {if String(information[38])[44] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "consoleStream", enabled: {if String(information[35])[53] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "consoleChat", enabled: {if String(information[37])[53] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "consoleHead", enabled: {if String(information[34])[53] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "consoleLine", enabled: {if String(information[36])[53] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "consoleSampler", enabled: {if String(information[38])[53] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "lineInStream", enabled: {if String(information[35])[62] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "lineInChat", enabled: {if String(information[37])[62] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "lineInHead", enabled: {if String(information[34])[62] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "lineInLine", enabled: {if String(information[36])[62] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "lineInSampler", enabled: {if String(information[38])[62] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "systemStream", enabled: {if String(information[35])[71] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "systemChat", enabled: {if String(information[37])[71] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "systemHead", enabled: {if String(information[34])[71] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "systemLine", enabled: {if String(information[36])[71] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "systemSampler", enabled: {if String(information[38])[71] == "X" {return(true)} else {return(false)}}()),
            
            
            SectionsList(label: "samplerStream", enabled: {if String(information[35])[81] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "samplerChat", enabled: {if String(information[37])[81] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "samplerHead", enabled: {if String(information[34])[81] == "X" {return(true)} else {return(false)}}()),
            SectionsList(label: "samplerLine", enabled: {if String(information[36])[81] == "X" {return(true)} else {return(false)}}()),
        ]
        return(sections)
    }
}

func GetFadersAssignment() -> Array<String> {
    var returnValue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let information = output.components(separatedBy: "\n")
        if information.count <= 2 {
                return(["nil"])
        }
        let faderA = String(information[14]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnValue.append(faderA)

        let faderB = String(information[15]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnValue.append(faderB)

        let faderC = String(information[16]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnValue.append(faderC)

        let faderD = String(information[17]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnValue.append(faderD)
    }
    return(returnValue)
}

func GetMuteBehaviours() -> Array<String> {
    var returnValue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let information = output.components(separatedBy: "\n")
        if information.count <= 2 {
                return(["nil"])
        }
        var muteFaderA = String(information[14]).components(separatedBy: " ")[6]
        if muteFaderA == "All" {muteFaderA = "all"} else if muteFaderA == "ToStream" {muteFaderA = "to-stream"} else if muteFaderA == "ToVoiceChat" {muteFaderA = "to-voice-chat"} else if muteFaderA == "ToPhones" {muteFaderA = "to-phones"} else if muteFaderA == "ToLineOut" {muteFaderA = "to-line-out"}
        returnValue.append(muteFaderA)
        
        var muteFaderB = String(information[15]).components(separatedBy: " ")[6]
        if muteFaderB == "All" {muteFaderB = "all"} else if muteFaderB == "ToStream" {muteFaderB = "to-stream"} else if muteFaderB == "ToVoiceChat" {muteFaderB = "to-voice-chat"} else if muteFaderB == "ToPhones" {muteFaderB = "to-phones"} else if muteFaderB == "ToLineOut" {muteFaderB = "to-line-out"}
        returnValue.append(muteFaderB)

        var muteFaderC = String(information[16]).components(separatedBy: " ")[6]
        if muteFaderC == "All" {muteFaderC = "all"} else if muteFaderC == "ToStream" {muteFaderC = "to-stream"} else if muteFaderC == "ToVoiceChat" {muteFaderC = "to-voice-chat"} else if muteFaderC == "ToPhones" {muteFaderC = "to-phones"} else if muteFaderC == "ToLineOut" {muteFaderC = "to-line-out"}
        returnValue.append(muteFaderC)

        var muteFaderD = String(information[17]).components(separatedBy: " ")[6]
        if muteFaderD == "All" {muteFaderD = "all"} else if muteFaderD == "ToStream" {muteFaderD = "to-stream"} else if muteFaderD == "ToVoiceChat" {muteFaderD = "to-voice-chat"} else if muteFaderD == "ToPhones" {muteFaderD = "to-phones"} else if muteFaderD == "ToLineOut" {muteFaderD = "to-line-out"}
        returnValue.append(muteFaderD)
    }
    return(returnValue)
}
