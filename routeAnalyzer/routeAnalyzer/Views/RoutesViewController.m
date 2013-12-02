//
//  RoutesViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/22/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "RoutesViewController.h"
#import "AppDelegate.h"
#import "Route.h"
#import "Run.h"
#import "StatsViewController.h"


@interface RoutesViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RoutesViewController
@synthesize routesInfo, managedObjectContext;
@synthesize runsPerRoute;


- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	self.runsPerRoute = [[NSMutableDictionary alloc]init];
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	managedObjectContext = appDelegate.managedObjectContext;
	NSError *error;
    
	if (![[self fetchedResultsController] performFetch:&error]) {

		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



- (void)viewWillAppear {
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.fetchedResultsController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"showStats"]) {
		StatsViewController *destination = segue.destinationViewController;
		destination.managedObjectContext = self.managedObjectContext;
		Route *selectedRoute = [self.fetchedResultsController objectAtIndexPath:currentSelectedIndexPath];
		destination.currentRoute = selectedRoute;
		destination.title = selectedRoute.name;
	}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"routeCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	[self configureCell:cell atIndexPath:indexPath];
    
    
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Route *route = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Run"
	                                          inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
	                          @"myRoute =  %@", route];
    
	[fetchRequest setPredicate:predicate];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalTime" ascending:YES];
	fetchRequest.sortDescriptors = @[sortDescriptor];
    
	NSError *error;
	NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest
	                                                          error:&error];
	if (array == nil) {
		NSLog(@"%@", [error description]);
		cell.detailTextLabel.text = @"";
	}
	else {
		[runsPerRoute setObject:array forKey:route.name];
        
		if ([array count] == 1) {
			cell.detailTextLabel.text = @"1 run";
		}
		else {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d runs", [array count]];
		}
	}
    
	cell.textLabel.text = route.name;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the managed object.
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
		NSError *error;
		if (![context save:&error]) {

			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

		}
	}
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	currentSelectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"showStats"
                              sender:self];
}

#pragma mark - Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
    
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route"
	                                          inManagedObjectContext:self.managedObjectContext];
    
	[fetchRequest setEntity:entity];
    
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
	                                                               ascending:YES];
    
	NSArray *sortDescriptors = @[nameDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	// Create and initialize the fetch results controller.
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
	                                                                managedObjectContext:self.managedObjectContext
	                                                                  sectionNameKeyPath:nil
	                                                                           cacheName:nil];
	_fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
	UITableView *tableView = self.tableView;
    
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
            
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray
			                                   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray
			                                   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

@end
