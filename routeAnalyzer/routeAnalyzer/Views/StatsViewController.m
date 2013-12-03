//
//  StatsViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar on 11/30/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "StatsViewController.h"
#import "StaticRouteMapViewController.h"
#import "Run.h"
#import "RunsViewController.h"
#import "DynamicRouteMapViewController.h"
#import "ChartViewController.h"

@interface StatsViewController ()
@property Run *selectedRun;
@property NSString *mapViewTitle;
@property NSArray *route;

@end

@implementation StatsViewController
@synthesize managedObjectContext, currentRoute, routeRuns;
@synthesize fastestRun, slowestRun, averageRun, runsNumber;
@synthesize fastestCell,slowestestCell,showRunsCell,showGraphCell;


- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self getRouteInformation];
}

- (NSString *)timeFromTimeInterval:(NSNumber *)interval {
	NSTimeInterval timeInterval = [interval doubleValue];
	NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
	[dateFormatter setLocale:enUSLocale];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
	return [dateFormatter stringFromDate:timerDate];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)getRouteInformation {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Run"
	                                          inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
	                          @"myRoute =  %@", currentRoute];
    
	[fetchRequest setPredicate:predicate];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
	fetchRequest.sortDescriptors = @[sortDescriptor];
    
	NSError *error;
	NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest
	                                                          error:&error];
	if (array == nil) {
		NSLog(@"%@", [error description]);
	}
	else {
		routeRuns = array;
		[self updateRouteInfo];
	}
}

- (void)updateRouteInfo {
	// NSLog(@"There are %d runs on %@",[routeRuns count],currentRoute.name);
	fastestRun.text = [self timeFromTimeInterval:[routeRuns valueForKeyPath:@"@min.totalTime"]];
	slowestRun.text =  [self timeFromTimeInterval:[routeRuns valueForKeyPath:@"@max.totalTime"]];
	averageRun.text = [self timeFromTimeInterval:[routeRuns valueForKeyPath:@"@avg.totalTime"]];
	runsNumber.text = [NSString stringWithFormat:@"%d", [routeRuns count]];
    if ([routeRuns count] == 0) {
        [fastestCell setAccessoryType:UITableViewCellAccessoryNone];
        [fastestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [slowestestCell setAccessoryType:UITableViewCellAccessoryNone];
        [slowestestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [showRunsCell setAccessoryType:UITableViewCellAccessoryNone];
        [showRunsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [showGraphCell setAccessoryType:UITableViewCellAccessoryNone];
        [showGraphCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {

        [fastestCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [fastestCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        [slowestestCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [slowestestCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        [showRunsCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [showRunsCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        [showGraphCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [showGraphCell setSelectionStyle:UITableViewCellSelectionStyleDefault];

    }
    

}


#pragma mark - Tableview delegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		self.selectedRun = [routeRuns firstObject];
		self.mapViewTitle = @"Fastest Run";
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPSPoint"
		                                          inManagedObjectContext:self.managedObjectContext];
		[fetchRequest setEntity:entity];
        
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
		                          @"myRun =  %@", self.selectedRun];
        
		[fetchRequest setPredicate:predicate];
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
		fetchRequest.sortDescriptors = @[sortDescriptor];
        
		NSError *error;
		NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest
		                                                          error:&error];
		if (array == nil) {
			NSLog(@"%@", [error description]);
		}
		else {
			self.route = array;
			[self performSegueWithIdentifier:@"show map" sender:self];
		}
	}
	else if (indexPath.row == 2) {
		self.selectedRun = [routeRuns lastObject];
		self.mapViewTitle = @"Slowest Run";
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPSPoint"
		                                          inManagedObjectContext:self.managedObjectContext];
		[fetchRequest setEntity:entity];
        
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
		                          @"myRun =  %@", self.selectedRun];
        
		[fetchRequest setPredicate:predicate];
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
		fetchRequest.sortDescriptors = @[sortDescriptor];
        
		NSError *error;
		NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest
		                                                          error:&error];
		if (array == nil) {
			NSLog(@"%@", [error description]);
		}
		else {
			self.route = array;
			[self performSegueWithIdentifier:@"show map" sender:self];
		}
	}
	else if (indexPath.row == 3) {
        self.selectedRun = nil;
        self.mapViewTitle = @"";
        if ([routeRuns count] > 0) {
            [self performSegueWithIdentifier:@"detailed runs" sender:self];
        }
		
	}
    else if (indexPath.row == 4){
        [self performSegueWithIdentifier:@"show graph" sender:self];
    
    }

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"show track view"]) {
		UINavigationController *navController = segue.destinationViewController;
		DynamicRouteMapViewController *destination = (DynamicRouteMapViewController *)[navController topViewController];
		destination.managedObjectContext = self.managedObjectContext;
		destination.routeTracked = self.currentRoute;
        destination.title = self.currentRoute.name;
	}
	else if ([segue.identifier isEqualToString:@"detailed runs"]) {
		RunsViewController *destination = segue.destinationViewController;
		destination.currentRoute = self.currentRoute;
	}
    else if([segue.identifier isEqualToString:@"show graph"]){
        
        ChartViewController *destination = segue.destinationViewController;
        destination.routeRuns = self.routeRuns;
        destination.title = @"Bar Chart";
    
    }
	else {
		StaticRouteMapViewController *destination = segue.destinationViewController;
		destination.title = self.mapViewTitle;
		destination.route = self.route;
	}
}

@end
