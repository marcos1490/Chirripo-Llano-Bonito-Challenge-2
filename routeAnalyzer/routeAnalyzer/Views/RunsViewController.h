//
//  RunsViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 12/1/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"


@interface RunsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Route *currentRoute;
@property (nonatomic, retain) NSArray *routeRuns;

@end
