//
//  RoutesViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/22/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RoutesViewController : UITableViewController<NSFetchedResultsControllerDelegate>{

    NSManagedObjectContext *managedObjectContext;
    NSIndexPath *currentSelectedIndexPath;

}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *routesInfo;
@property (nonatomic,retain) NSMutableDictionary *runsPerRoute;


@end
