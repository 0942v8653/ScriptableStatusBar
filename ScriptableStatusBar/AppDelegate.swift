import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItems = [String: NSStatusItem]()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSDistributedNotificationCenter.defaultCenter()
            .addObserver(self, selector: Selector("recievedDistributedNotification:"), name: "io.github.0942v8653.ScriptableStatusBar", object: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func recievedDistributedNotification(notification: NSNotification) {
        print(notification)
        let dict = notification.userInfo as! Dictionary<String, AnyObject>
        let identifier = dict["identifier"] as! String
        if dict["action"] as! String == "remove" {
            self.removeStatusBarItem(identifier)
        } else {
            self.setStatusBarItem(identifier,
                title: dict["title"] as! String,
                menuItems: dict["menuItems"] as! Dictionary<String, String>)
        }
    }
    
    func removeStatusBarItem(identifier: String) {
        if let item = statusBarItems.removeValueForKey(identifier) {
            NSStatusBar.systemStatusBar().removeStatusItem(item)
        }
    }
    
    func setStatusBarItem(identifier: String, title: String, menuItems: Dictionary<String, String>) {
        let previousItem = statusBarItems[identifier]
        var statusItem: NSStatusItem!
        if previousItem != nil {
            statusItem = previousItem!
        } else {
            // for some reason NSVariableStatusItemLength doesn't show up, so here's a quick hack
            statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1.0)
        }
        statusItem.title = title
        if menuItems.count > 0 {
            print(menuItems)
            let menu = NSMenu(title: title)
            menu.autoenablesItems = false
            for (menuItemTitle, shellScript) in menuItems {
                let menuItem = NSMenuItem(title: menuItemTitle, action: Selector("menuItemClicked:"), keyEquivalent: "")
                if shellScript == "__disabled__" {
                    menuItem.enabled = false
                } else {
                    menuItem.representedObject = shellScript
                }
                menu.addItem(menuItem)
            }
            statusItem.menu = menu
        }
        statusBarItems[identifier] = statusItem
    }
    
    func menuItemClicked(item: NSMenuItem) {
        if let command = item.representedObject as? String {
            NSTask.launchedTaskWithLaunchPath("/bin/bash", arguments: ["-c", command])
        }
    }
}

