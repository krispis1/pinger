//
//  PingIp.swift
//  Pinger
//
//  Created by Macbook on 2020-11-15.
//

import Foundation

class IpPinger {
    
    var queue = OperationQueue()
    var globalIndex = 0
    var hitIps = [Int]()
    
    func ping(index: Int) {
        if globalIndex == 1000 {
            return
        }
        print("Next rotation: \(globalIndex)")
        //print("IP index on start: \(index)")
        //print(queue.operationCount)
        let pinger = try? SwiftyPing(host: "192.168.1.\(index)", configuration: PingConfiguration(interval: 3, with: 3), queue: DispatchQueue.global())
        pinger?.observer = { (response) in
            if response.ipHeader == nil {
                print("********************")
                print("not reachable \(response.ipAddress!)")
                if response.sequenceNumber == (pinger?.targetCount)!-1 {
                    var toAdd = true
                    if !scannedIps.isEmpty {
                        for x in 0...scannedIps.count-1 {
                            if scannedIps[x].ip == "192.168.1.\(index)" {
                                toAdd = false
                                scannedIps[x].statusImg = #imageLiteral(resourceName: "unreachable")
                                scannedIps[x].status = false
                                DispatchQueue.main.async {
                                    tableView.reloadData()
                                }
                            }
                        }
                    }
                    if toAdd && index > 0 {
                        let tempBlock = IpBlock(ip: "192.168.1.\(index)", statusImg: #imageLiteral(resourceName: "unreachable"), status: false, ipEnd: index)
                        scannedIps.append(tempBlock)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
                    pinger?.haltPinging(resetSequence: true)
                    print("done")
                    if self.globalIndex+1 <= 254 {
                        print("Index: \(index)")
                        print("********************")
                        self.globalIndex += 1
                        if self.globalIndex != 1000 {
                            self.ping(index: self.globalIndex)
                        }
                    }
                }
            } else {
                if !self.hitIps.contains(index) {
                    self.hitIps.append(index)
                }
                var toAdd = true
                if !scannedIps.isEmpty {
                    for x in 0...scannedIps.count-1 {
                        if scannedIps[x].ip == "192.168.1.\(index)" {
                            toAdd = false
                            scannedIps[x].statusImg = #imageLiteral(resourceName: "reachable")
                            scannedIps[x].status = true
                            DispatchQueue.main.async {
                                tableView.reloadData()
                            }
                        }
                    }
                }
                if toAdd && index > 0 {
                    let tempBlock = IpBlock(ip: "192.168.1.\(index)", statusImg: #imageLiteral(resourceName: "reachable"), status: true, ipEnd: index)
                    scannedIps.append(tempBlock)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
                print("HIT \(response.ipAddress!)")
                pinger?.haltPinging(resetSequence: true)
                self.queue.cancelAllOperations()
                print("done")
                if index+self.queue.maxConcurrentOperationCount <= 254 {
                    if index > self.queue.maxConcurrentOperationCount {
                        self.globalIndex = self.hitIps[self.hitIps.count-1]
                    } else {
                        self.globalIndex = self.queue.maxConcurrentOperationCount
                    }
                    if self.globalIndex != 1000 {
                        self.concurrentPing(it: self.globalIndex-self.queue.maxConcurrentOperationCount+1, diff: 0, firstRun: false)
                    }
                } else {
                    self.globalIndex = self.hitIps[self.hitIps.count-1]
                    let diff = self.globalIndex+self.queue.maxConcurrentOperationCount - 254
                    if self.globalIndex != 1000 {
                        self.concurrentPing(it: self.globalIndex-self.queue.maxConcurrentOperationCount+1, diff: diff, firstRun: false)
                    }
                }
            }
        }
        pinger?.targetCount = 1
        try? pinger?.startPinging()
    }
    
    func concurrentPing(it: Int, diff: Int, firstRun: Bool) {
        var indexToRemove = [Int]()
        if !hitIps.isEmpty {
            for x in 0...hitIps.count-1 {
                if hitIps[x] < it {
                    indexToRemove.append(x)
                }
            }
            for x in indexToRemove {
                hitIps.remove(at: x)
            }
            indexToRemove.removeAll()
        }
        let ignoredIndex = hitIps
        for x in ignoredIndex {
            print("IGNORED IP: \(x)")
        }
        queue.maxConcurrentOperationCount = 10
        if firstRun {
            globalIndex = queue.maxConcurrentOperationCount
        }
        
        DispatchQueue.global().sync {
            if !ignoredIndex.isEmpty {
                if diff == 0 {
                    for index in it...it+queue.maxConcurrentOperationCount-1+ignoredIndex.count {
                        if !ignoredIndex.contains(index) {
                            queue.addOperation {
                                self.ping(index: index)
                            }
                        }
                    }
                } else {
                    for index in it...it+queue.maxConcurrentOperationCount-1+ignoredIndex.count-diff {
                        if !ignoredIndex.contains(index) {
                            queue.addOperation {
                                self.ping(index: index)
                            }
                        }
                    }
                }
            } else {
                if diff == 0 {
                    for index in it...it+queue.maxConcurrentOperationCount-1 {
                        queue.addOperation {
                            self.ping(index: index)
                        }
                    }
                } else {
                    for index in it...it+queue.maxConcurrentOperationCount-1-diff {
                        queue.addOperation {
                            self.ping(index: index)
                        }
                    }
                }
            }
        }

        queue.waitUntilAllOperationsAreFinished()
    }
    
    func stopPinging() {
        globalIndex = 1000
        hitIps.removeAll()
        queue.cancelAllOperations()
    }
    
}
