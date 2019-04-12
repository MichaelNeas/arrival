//
//  BusInterfaceController.swift
//  Arrival WatchKit Extension
//
//  Created by Michael Neas on 4/11/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import WatchKit
import Foundation


class BusInterfaceController: WKInterfaceController {
    @IBOutlet weak var busTable: WKInterfaceTable!
    //var buses = ["Yellow", "Green", "Blue", "Red", "Purple", "Black"].map { Bus(name: $0) }
    var datum: [Datum] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        MBTAAPI.shared.fetchStops() { (result: Result<Stops, MBTAAPI.APIServiceError>) in
            switch result {
            case .success(let stopResponse):
                DispatchQueue.main.async{
                    self.datum = stopResponse.data
                    self.busTable.setNumberOfRows(self.datum.count, withRowType: "BusRow")
                    for index in 0..<self.busTable.numberOfRows {
                        guard let controller = self.busTable.rowController(at: index) as? BusRowController else { continue }
                        controller.bus = self.datum[index]
                    }
                }
                
                print(stopResponse.data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        //let bus = buses[rowIndex]
        //print(bus)
        //presentController(withName: "Bus", context: bus)
    }
}
