//
//  BidState.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 5/1/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit

// BidState singleton
public class BidState {
    
    private static let myInstance = BidState()
    private var ongoingBid: Bid?
    private var gotResponse: Bool
    
    init() {
        ongoingBid = nil
        gotResponse = false
    }
    
    static func sharedInstance () -> BidState {
        return myInstance
    }
    
    func setOngoingBid (inBid: Bid) {
        ongoingBid = inBid.copy() as? Bid // copies over the dictionary
    }
    
    func getOngoingBid () -> Bid? {
        return ongoingBid
    }
    
    func resetOngoingBid () {
        ongoingBid = nil
    }
    
    func isOngoingBid () -> Bool {
        return (ongoingBid != nil)
    }
    
    func isSameAsOngoingBid (bidId: String?) -> Bool {
        
        if (ongoingBid == nil || bidId == nil) {
            return false
        }
        
        return (ongoingBid!.id == bidId)
    }
    
    func setGotResponse () {
        gotResponse = true
    }
    
    func didGetReponse () -> Bool {
        return gotResponse
    }
}