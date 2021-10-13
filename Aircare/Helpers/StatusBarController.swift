import AppKit
import Alamofire
import SwiftyJSON

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
            statusBarButton.target = self
        }
        
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [statusItem] _ in
          AF.request("http://\(apiHost)/api/measurements")
            .responseJSON { response in
              let json = try! JSON(data: response.data!)
              statusItem.button?.title = "Home - \(json["data"]["Temperature"]) °C | CO2: \(json["data"]["CO2"])  ppm"
            }
        }
    }
}
