//
//  Welcome.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Welcome: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .opacity(0.1) // hack to prevent clickthrough at opactity 0
                    .edgesIgnoringSafeArea(.all)
                Rectangle()
                    .fill(Color.white)
                    
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                    .overlay(
                        VStack(alignment: .leading) {
                            Image("logo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                            Text("Welcome to Jewel!")
                                .font(.title)
                            ScrollView {
                                Text("Jewel helps you remember great albums that you don't want to lose within the 100's of other in your library")
                                    .padding(.bottom)
                                Text("Jewel gives you 8 slots to add any release from the Apple Music catalogue.  Add them as you remember them then when you're ready to listen they're there waiting for you!")
                                    .padding(.bottom)
                                Text("You can also 'borrow' a collection from a friend, or share your with them!  Switch between the collections with the icon in the top right.")
                                    .padding(.bottom)
                                Text("Your collection is for anything you wish - new releases, favourite albums, an upcoming roadtrip - start collecting now!")
                            }
                            Button(action: {
                                self.userData.preferences.firstTimeRun = false
                            }) {
                                Text("Start collection")
                            }
                        }
                            
                        .padding()
                        ,
                        alignment: .top
                )
                    
                    .cornerRadius(20)
                .shadow(radius: 5)
            }
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
