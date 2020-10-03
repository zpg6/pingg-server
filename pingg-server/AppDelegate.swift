//
//  AppDelegate.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import Cocoa
import SwiftUI
import Firebase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        
        FirebaseApp.configure()
        
        let credentials = readPropertyList()
        
        if  let email = credentials.email,
            let pass = credentials.password {
            
            print("found email=\(email), password=\(pass)")
            
            Auth.auth().signIn(withEmail: email, password: pass) { (result, err) in
                
                if let err = err {
                    print("❌\n\n" + err.localizedDescription + "\n\n❌")
                }
                
                if let result = result, !result.user.uid.isEmpty {
                    
                    CloudStorage.setup()
                    
                    let contentView = ContentView(admin: result.user.uid)

                    // Create the window and set the content view.
                    self.window = NSWindow(
                        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                        backing: .buffered, defer: false)
                    self.window.isReleasedWhenClosed = false
                    self.window.center()
                    self.window.setFrameAutosaveName("Main Window")
                    self.window.contentView = NSHostingView(rootView: contentView)
                    self.window.makeKeyAndOrderFront(nil)
                    
                } else {
                    
                    print("unable to authenticate")
                    //NSControl().sendAction(#selector(NSXPCConnection.suspend), to: NSApplication.shared)
                    
                }
                
            }

        } else {
            print("unable to get credentials")
            //NSControl().sendAction(#selector(NSXPCConnection.suspend), to: NSApplication.shared)
        }
        
        WebServer.startup()

    }
    
    func readPropertyList() -> (email: String?, password: String?) {
             
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        if let plistPath = Bundle.main.path(forResource: "Env", ofType: "plist") { //the path of the data
            let plistXML = FileManager.default.contents(atPath: plistPath)! //the data in XML format
            do { //convert the data to a dictionary and handle errors.
                plistData = try PropertyListSerialization.propertyList(from: plistXML,options: .mutableContainersAndLeaves,format: &format) as! [String:AnyObject]
                
                if let email = plistData["email"] as? String,
                   let password = plistData["password"] as? String {
                    
                    return (email,password)
                    
                } else {
                    print("unable to extract plist data")
                    return (nil,nil)
                }
                
            }
            catch{ // error condition
                print("Error reading plist: \(error), format: \(format)")
                return (nil,nil)
            }
        } else {
            print("error establishing plist path")
            return (nil,nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

