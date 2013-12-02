//
//  AddRouteViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/25/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "AddRouteViewController.h"
#import "AppDelegate.h"
#import "Route.h"


@implementation AddRouteViewController
@synthesize name = _name;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    
	UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(viewTouched:)];
	[self.view addGestureRecognizer:singleFingerTap];
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	managedObjectContext = appDelegate.managedObjectContext;
	_name.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addRoute:(id)sender {
	[self addRouteWithName:[_name text]];
}

- (void)addRouteWithName:(NSString *)routeName {
	if (routeName.length > 0) {
		Route *route = [NSEntityDescription
		                insertNewObjectForEntityForName:@"Route"
                        inManagedObjectContext:managedObjectContext];
		route.name = routeName;
        
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
			                                               message:[error localizedDescription]
			                                              delegate:nil
			                                     cancelButtonTitle:@"Ok"
			                                     otherButtonTitles:nil];
			[alert show];
		}
		else {
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Empty Route Name"
		                                               message:@"The route name can't be empty"
		                                              delegate:nil
		                                     cancelButtonTitle:@"Ok"
		                                     otherButtonTitles:nil];
		[alert show];
	}
}

- (void)viewTouched:(UITapGestureRecognizer *)gesture {
	[self.view endEditing:YES];
}

#pragma mark - UITextFields delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self addRouteWithName:[_name text]];
	return NO;
}

@end
