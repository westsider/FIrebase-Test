//
//  Show Trades.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 10/10/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import SciChart

class ShowTrades {
    
    let annotationGroup = SCIAnnotationCollection()
    
    func showTradesOnChart(currentBar: Int, signal: Double, high: Double, low: Double, close:Double)-> SCIAnnotationCollection {
        if(signal == 1) {
            print("\nLong signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createUpArrow(Date: currentBar, Entry: low) )
        }
        if(signal == -1) {
            print("\nShrt signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createDnArrow(Date: currentBar, Entry: high) )
        }
        
        if(signal == -2 || signal == 2) {
            print("\nExit signal: \(signal) on bar \(currentBar)")
            annotationGroup.add( createExit(Date: currentBar, Entry: close) )
        }
        return annotationGroup
    }
    
    func createUpArrow(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "triangleUp"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
    }
    
    func createDnArrow(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "triangleDown"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
    }
    
    func createExit(Date: Int, Entry:Double)-> SCICustomAnnotation {
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "exit"))
        customAnnotationGreen.x1=SCIGeneric(Date)
        customAnnotationGreen.y1=SCIGeneric(Entry)
        return customAnnotationGreen
    }
    
}

