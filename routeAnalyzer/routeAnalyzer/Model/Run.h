//
//  Run.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 11/30/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPSPoint, Route;

@interface Run : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSSet *myGPSPoints;
@property (nonatomic, retain) Route *myRoute;
@end

@interface Run (CoreDataGeneratedAccessors)

- (void)addMyGPSPointsObject:(GPSPoint *)value;
- (void)removeMyGPSPointsObject:(GPSPoint *)value;
- (void)addMyGPSPoints:(NSSet *)values;
- (void)removeMyGPSPoints:(NSSet *)values;

@end
