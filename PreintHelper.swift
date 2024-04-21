//
//  PreintHelper.swift
//
//
//  Created by hammam abdulaziz.
//  Copyright © 2020 Hammam Abdulaziz - devhammam@gmail.com All rights reserved.
//

import Foundation
import FirebaseCrashlytics
import SwiftUI

extension String {
    /// Supporting PrintHelper file
    ///
    /// - Author: Hammam Abdulaziz
    var logFilePath: String {
        let pathComponents = self.components(separatedBy: "/")
        let index = pathComponents.lastIndex(of: "SetupProject")
        return pathComponents.suffix(pathComponents.count - (index ?? 0)).joined(separator: " > ")
    }

}

/// A logger for my app, identical to the native `print` statement
///
/// This will help me to stop printing any thing to the console
/// if I want at any time to look for something important.
///
/// Also this function should be used for print statements that are always required for
/// debugging and shouldn't be removed as the print statement should not
/// exist in the production environment.
/// Reference for printing the file name and function name and line number from:
/// https://docs.swift.org/swift-book/ReferenceManual/Expressions.html
///
/// - Author: Hammam Abdulaziz
func logger<T>(_ items: T, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    Crashlytics.crashlytics().log("log from logger file=\(file.logFilePath) Function=\(function) Line=\(line) logger=\(items)")
    print("""
            \n==> ✍️ Log called from file: \(file.logFilePath)
            ==> 📝 Function name: \(function)
            ==> 📄 Line number: \(line)
            ==> 📄 column number: \(column)
            ===================== 📬 Begin 📬 =========================
            \(items)
            ====================== 📪 End 📪 ==========================
            """)
}

/// This function will be used for the network only.
/// - Author: Hammam Abdulaziz
func logNetwork<T>(_ items: T, separator: String = " ", file: String = #file, function: String = #function, line: Int = #line, terminator: String = "\n", needPrint: Bool = false, sendNonFatalError: Bool = false) {
    Crashlytics.crashlytics().log("log from netowrk log=\(items)")
    if needPrint {
        print("""
                    \n===================== 📟 ⏳ 📡 =========================
                    \(items)
                    ======================= 🚀 ⌛️ 📡 =========================
                    """, separator: separator, terminator: terminator)
    }
    
    if sendNonFatalError {
        logError(items, file: file, function: function, line: line)
    }
}

/// This function will be used for logging the errors to help doing
/// some modifiction like send send all the error to the backend ... etc.
/// - Author: Hammam Abdulaziz
func logError<T>(_ items: T, file: String = #file, function: String = #function, line: Int = #line) {
//    Crashlytics.crashlytics().record(error: NSError(domain: NSPOSIXErrorDomain, code: 1, userInfo: ["testO": "inside", "func": function]), userInfo: ["testI": "outside", "func": function])
    Crashlytics.crashlytics().record(exceptionModel: .init(name: "log error at \(ProjectConfiguration.shared.environment.rawValue)", reason: "file=\(file.logFilePath) Function=\(function) Line=\(line) error=\(items)"))
    print("""
            \n==> ‼️ Error log coming from file: \(file.logFilePath)
            ==> ‼️ Function name: \(function)
            ==> ‼️ Line number: \(line)
            ===================== ❌ Begin ❌ =========================
            \(items)
            ====================== ❌ End ❌ ==========================
            """)
}


struct ViewLogger: ViewModifier {
    let file: String
    let function: String
    let line: Int
    let column: Int
    
    func body(content: Content) -> some View {
        let fileName = file.components(separatedBy: "/").last
        content
            .onAppear {
                logger("\(fileName ?? file) OPENED>>>", file: file, function: function, line: line, column: column)
            }
            .onDisappear {
                logger("\(fileName ?? file) CLOSED<<<", file: file, function: function, line: line, column: column)
            }
    }
}

extension View {
    /// To log the status of hte views when the views opend or cloesed
    func logging(file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) -> some View {
        modifier(ViewLogger(file: file, function: function, line: line, column: column))
    }
}

enum ErrorDomains {
    case NSPOSIXErrorDomain // POSIX/BSD errors
    case NSCocoaErrorDomain // Cocoa errors
    case NSOSStatusErrorDomain // Mac OS 9/Carbon errors
    case NSMachErrorDomain // Mach errors
    case NSURLErrorDomain // URL loading system errors
    case NSStreamSOCKSErrorDomain // The error domain used by NSError when reporting SOCKS errors
    case NSStreamSocketSSLErrorDomain // The error domain used by NSError when reporting SSL errors
}

enum FirebaseErrorCode: Int {
    case test
}
