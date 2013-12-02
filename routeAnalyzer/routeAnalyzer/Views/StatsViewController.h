//
//  StatsViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 11/30/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface StatsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *routeRuns;
@property (nonatomic,retain) Route *currentRoute;

@property (nonatomic,retain) IBOutlet UILabel *fastestRun;
@property (nonatomic,retain) IBOutlet UILabel *slowestRun;
@property (nonatomic,retain) IBOutlet UILabel *averageRun;
@property (nonatomic,retain) IBOutlet UILabel *runsNumber;

@property (nonatomic,retain) IBOutlet UITableViewCell *fastestCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *slowestestCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *showRunsCell;



@end
