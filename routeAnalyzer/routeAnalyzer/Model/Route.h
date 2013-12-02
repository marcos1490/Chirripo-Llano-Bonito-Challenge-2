//
//  Route.h
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/22/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run;

@interface Route : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *myRuns;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addMyRunsObject:(Run *)value;
- (void)removeMyRunsObject:(Run *)value;
- (void)addMyRuns:(NSSet *)values;
- (void)removeMyRuns:(NSSet *)values;

@end
