//
//  Authorization.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import AppKit

var _authorizer : MacAuthorizer?
extension Session {
    
    public func authorizeWithViewController(window: NSWindow, completionHandler: () -> Void) {
        if (_authorizer != nil) {
            fatalError("You are currently authorizing.")
            return
        }
        
        _authorizer = MacAuthorizer(configuration: self.configuration)
        _authorizer?.authorize(window, completionHandler: { (accessToken, error) -> Void in
            //
            _authorizer = nil
        })
    }
}

class MacAuthorizer : Authorizer {
    var windowController : AuthorizationWindowController?
    
    func authorize(window: NSWindow, completionHandler: (String?, NSError?) -> Void) {
        self.completionHandler = completionHandler
        self.windowController = AuthorizationWindowController(windowNibName: "AuthorizationWindowController")
        self.windowController?.authorizationURL = self.authorizationURL
        self.windowController?.redirectURL = self.redirectURL
        self.windowController?.delegate = self
        NSApp.beginSheet(windowController!.window!, modalForWindow: window, modalDelegate: self, didEndSelector: nil, contextInfo: nil)
    }
    
    override func finilizeAuthorization(accessToken: String?, error: NSError?) {
        NSApp.endSheet(windowController!.window!)
        self.windowController!.window!.orderOut(self)
        super.finilizeAuthorization(accessToken, error: error)
    }
}
