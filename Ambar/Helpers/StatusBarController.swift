//
//  StatusBarController.swift
//  Ambar
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
  
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 200.0)
        
        if let statusBarButton = statusItem.button {
            statusItem.button?.title = "Home - °C | CO2: - ppm"
            
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [statusItem] _ in
          statusItem.button?.title = "cica"
          self.getMeasurement()
          debugPrint("asd")
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            eventMonitor?.start()
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
  
  func getMeasurement() {
    if let url = URL(string: "http://aircare.home.adamharis.com/api/measurements") {
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
          if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString.station_name)
          }
        }
      }.resume()
    }
  }
}
