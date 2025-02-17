//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//  Edited by Eino on 18/05/2022.
//

import SwiftUI
import ShellOut

struct AboutView: View {
    @State var tabName: String? = "About"
    
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                Text("About")
                    .font(.system(size: 45))
                Text("GoXlr Panel ( GoXlr on Macos )")
                    .font(.system(size: 20))
                    .fontWeight(.light)
                Text("Made with 💝 by Ade_Sky")
                    .font(.system(size: 15))
                    .fontWeight(.light)
                    .padding(.top, 1)
                    .padding(.bottom, 40)
                Text("With the help of the wonderfull work of :")
                    .font(.system(size: 15))
                    .fontWeight(.ultraLight)
                    .padding(.bottom, 20)
                Text("GoXlr-Utility")
                    .font(.system(size: 25))
                    .fontWeight(.light)
                    .underline()
                    .foregroundColor(.blue)
                    .onTapGesture {
                        NSWorkspace.shared.open(NSURL(string: "https://github.com/GoXLR-on-Linux/GoXLR-Utility")! as URL)
                            }
                Text("Made by :")
                    .font(.system(size: 20))
                    .fontWeight(.ultraLight)
                    .padding(.top, 1)
                    .padding(.bottom, 2)
            }
            HStack {
                Text("@FrostyCoolSlug (Craig McLure) |")
                    .font(.system(size: 15))
                    .fontWeight(.light)
                Text("@Dinnerbone (Nathan \"Dinnerbone\" Adams) |")
                    .font(.system(size: 15))
                    .fontWeight(.light)
                Text("@lm41 (lm41 Lars)")
                    .font(.system(size: 15))
                    .fontWeight(.light)
            }
            Text("3rd party licenses")
                .font(.system(size: 15))
                .fontWeight(.light)
                .underline()
                .foregroundColor(.blue)
                .padding(.top, 3)
                .onTapGesture {
                    NSWorkspace.shared.open(NSURL(string: "https://github.com/Adelenade/GoXlr-Macos/blob/main/LICENSE-3RD-PARTY")! as URL)
                }
            Text("©2022 Adélaïde Sky | MIT License")
                .padding(.top, 130)
                .onTapGesture {
                    NSWorkspace.shared.open(NSURL(string: "https://github.com/Adelenade/GoXlr-Macos/blob/main/LICENSE")! as URL)
                }
            
        }.navigationTitle(tabName!)
                
    }
}
