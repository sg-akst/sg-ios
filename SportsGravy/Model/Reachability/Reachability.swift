//
//  Reachability.swift
//  SportsGravy
//
//  Created by CSS on 02/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import Foundation
import SystemConfiguration

let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"
 
enum ReachabilityStatus {
case notReachable
case reachableViaWiFi
case reachableViaWWAN
}
 

public class Reachability {

    private var networkReachability: SCNetworkReachability?
    private var notifying: Bool = false

    init?(hostName: String) {
        networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
        
        if networkReachability == nil {
        return nil
        }
    }
    
    init?(hostAddress: sockaddr_in) {
        var address = hostAddress
     
        guard let defaultRouteReachability = withUnsafePointer(to: &address, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
     
        networkReachability = defaultRouteReachability
     
       
        if networkReachability == nil {
            return nil
        }
    }
     static func networkReachabilityForInternetConnection() -> Reachability? {
         var zeroAddress = sockaddr_in()
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)
         return Reachability(hostAddress: zeroAddress)
     }
      
     static func networkReachabilityForLocalWiFi() -> Reachability? {
         var localWifiAddress = sockaddr_in()
         localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
         localWifiAddress.sin_family = sa_family_t(AF_INET)
         // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0 (0xA9FE0000).
         localWifiAddress.sin_addr.s_addr = 0xA9FE0000
      
         return Reachability(hostAddress: localWifiAddress)
     }
    
    func startNotifier() -> Bool {
     
        guard notifying == false else {
            return false
        }
     
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
     
        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            if let currentInfo = info {
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                if infoObject is Reachability {
                    let networkReachability = infoObject as! Reachability
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: networkReachability)
                }
            }
        }, &context) == true else { return false }
     
        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
     
        notifying = true
        return notifying
    }
    func stopNotifier() {
        if let reachability = networkReachability, notifying == true {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
            notifying = false
        }
    }
    deinit {
        stopNotifier()
    }
     private var flags: SCNetworkReachabilityFlags {
      
         var flags = SCNetworkReachabilityFlags(rawValue: 0)
      
         if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true {
             return flags
         }
         else {
             return []
         }
     }
    var currentReachabilityStatus: ReachabilityStatus {
     
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    var isReachable: Bool {
        switch currentReachabilityStatus {
        case .notReachable:
            return false
        case .reachableViaWiFi:
            
            return true
                
          case .reachableViaWWAN:
            return true
        }
    }
    
//    class func isConnectedToNetwork() -> Bool {
//
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            return false
//        }
//
//        /* Only Working for WIFI
//        let isReachable = flags == .reachable
//        let needsConnection = flags == .connectionRequired
//
//        return isReachable && !needsConnection
//        */
//
//        // Working for Cellular and WIFI
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        let ret = (isReachable && !needsConnection)
//
//        return ret
//
//    }
}
