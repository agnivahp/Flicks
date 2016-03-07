//
//  network.swift
//  wat2watch
//
//  Created by Agnivah Poddar on 2/26/16.
//  Copyright © 2016 Agnivah Poddar. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class network: UITableViewCell {

    
    
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            let isReachable = flags == .Reachable
            let needsConnection = flags == .ConnectionRequired
            
            return isReachable && !needsConnection
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
