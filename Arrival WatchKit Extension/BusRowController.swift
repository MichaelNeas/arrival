//
//  BusRowController.swift
//  Arrival WatchKit Extension
//
//  Created by Michael Neas on 4/11/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import WatchKit

class BusRowController: NSObject {
    
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var busLabel: WKInterfaceLabel!
    @IBOutlet var busImage: WKInterfaceImage!
    
    var bus: Datum? {
        didSet {
            guard let bus = bus else { return }
            busLabel.setText(bus.attributes.name)
        }
    }
}
