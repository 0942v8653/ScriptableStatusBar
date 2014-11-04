import Cocoa

let notificationName = "io.github.0942v8653.ScriptableStatusBar"
let arguments = Process.arguments[1 ..< Process.arguments.count]

func postNotification(dict: Dictionary<String, AnyObject>) {
    NSDistributedNotificationCenter.defaultCenter()
        .postNotificationName(notificationName, object: nil, userInfo: dict, deliverImmediately: true)
}

func main() -> Bool {
    if arguments.count < 2 {
        return printUsage()
    }
    if arguments[0] == "set" {
        if arguments.count < 3 {
            return printUsage()
        }
        let identifier = arguments[1]
        let string = arguments[2]
        var menuItems = [String: String]()
        for i in arguments[3 ..< arguments.count] {
            if let r = i.rangeOfString(":") {
                menuItems[i.substringToIndex(r.startIndex)] = i.substringFromIndex(r.endIndex)
            } else {
                menuItems[i] = "__disabled__"
            }
        }
        setStatusBarItem(identifier, string, menuItems)
    } else if arguments[0] == "remove" {
        removeStatusBarItem(arguments[1])
    }
    
    return true
}

func setStatusBarItem(identifier: String, title: String, menuItems: Dictionary<String, String>) {
    postNotification([
        "action": "set",
        "identifier": identifier,
        "title": title,
        "menuItems": menuItems
    ])
}

func removeStatusBarItem(identifier: String) {
    postNotification([
        "action": "remove",
        "identifier": identifier
    ])
}

func printUsage() -> Bool {
    println("Usage: ")
    println("    sbar set <id> <string> [menuitem:command] [...]")
    println("    sbar remove <id>")
    return false
}

main()