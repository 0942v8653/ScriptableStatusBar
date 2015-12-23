/// Swift Migrator:
///
/// This file contains one or more places using either an index
/// or a range with ArraySlice. While in Swift 1.2 ArraySlice
/// indices were 0-based, in Swift 2.0 they changed to match the
/// the indices of the original array.
///
/// The Migrator wrapped the places it found in a call to the
/// following function, please review all call sites and fix
/// incides if necessary.
@available(*, deprecated=2.0, message="Swift 2.0 migration: Review possible 0-based index")
private func __reviewIndex__<T>(value: T) -> T {
    return value
}

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
    if arguments[arguments.startIndex] == "set" {
        if arguments.count < 3 {
            return printUsage()
        }
        let identifier = arguments[arguments.startIndex + 1]
        let string = arguments[arguments.startIndex + 2]
        var menuItems = [String: String]()
        let xw = __reviewIndex__(4...arguments.count)
        for i in arguments[xw] {
            print("argument", i)
            if let r = i.rangeOfString(":") {
                menuItems[i.substringToIndex(r.startIndex)] = i.substringFromIndex(r.endIndex)
            } else {
                menuItems[i] = "__disabled__"
            }
        }
        setStatusBarItem(identifier, title: string, menuItems: menuItems)
    } else if arguments[arguments.startIndex] == "remove" {
        removeStatusBarItem(arguments[arguments.startIndex + 1])
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
    print("Usage: ")
    print("    sbar set <id> <string> [menuitem:command] [...]")
    print("    sbar remove <id>")
    return false
}

main()