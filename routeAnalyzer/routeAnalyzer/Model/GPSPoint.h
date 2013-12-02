//
//  GPSPoint.h
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/22/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run;

@interface GPSPoint : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) Run *myRun;

@end
