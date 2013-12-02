//
//  DynamicRouteMapViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar on 12/1/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "DynamicRouteMapViewController.h"
#import "AppDelegate.h"
#import "GPSPoint.h"
#import <QuartzCore/QuartzCore.h>

@interface DynamicRouteMapViewController ()

@property (nonatomic, retain) GMSMutablePath *path;
@property (nonatomic, retain) GMSPolyline *polyline;
@property (nonatomic, assign) BOOL autoCenter;

@end

@implementation DynamicRouteMapViewController
@synthesize draggableView;
@synthesize startDate, stopDate;
@synthesize routeTracked;
@synthesize isTracking;
@synthesize routeGPSUpdates;
@synthesize locationManager;
@synthesize mapView;
@synthesize currentRun;
@synthesize managedObjectContext;
@synthesize positionMarker;
@synthesize myLocation;
@synthesize speed,timer;
@synthesize stopWatchTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	routeGPSUpdates = [[NSMutableArray alloc]init];
	mapView.delegate = self;
	if (!locationManager){
		locationManager = [[CLLocationManager alloc] init];
    }
    
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
	// Set a movement threshold for new events.
	locationManager.distanceFilter = 25; // meters
    
	draggableView.layer.cornerRadius = 25.0;
	draggableView.layer.masksToBounds = YES;
    
	isTracking = NO;
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	managedObjectContext = appDelegate.managedObjectContext;
    
	[self startTrackingRoute];
     [self startTimer];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
#pragma mark - Timer methods

-(void) startTimer{
    self.startDate = [NSDate date];
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];

}
-(void)stopTimer{

    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    [self updateTimer];

}
- (void)updateTimer
{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
	[dateFormatter setLocale:enUSLocale];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    timer.text = timeString;
}


#pragma mark - View Dragg methods
float startX = 0;
float startY = 0;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    
	if ([touch view] == draggableView) {
		CGPoint location = [touch locationInView:self.view];
		startX = location.x - draggableView.center.x;
		startY = location.y - draggableView.center.y;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch view] == draggableView) {
		CGPoint location = [touch locationInView:self.view];
        
        
		location.x = location.x - startX;
		location.y = location.y - startY;
		draggableView.center = location;
	}
}

#pragma mark - Tracking Actions
- (void)startTrackingRoute {
	[locationManager startUpdatingLocation];
	positionMarker = [[GMSMarker alloc] init];
	_path = [GMSMutablePath path];
	positionMarker.title = @"Current Position";
	positionMarker.map = mapView;
	isTracking = YES;
	_autoCenter = YES;
    
	currentRun = [NSEntityDescription
	              insertNewObjectForEntityForName:@"Run"
                  inManagedObjectContext:managedObjectContext];
	NSDate *now = [[NSDate alloc] init];
	double timestamp = [now timeIntervalSince1970];
    
	currentRun.unique = [NSString stringWithFormat:@"%.f", timestamp];
	currentRun.startDate = now;
	currentRun.endDate = now;
	currentRun.myRoute = routeTracked;
    
   
    
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
}

- (void)stopTrackingRoute:(id)sender {
	[locationManager stopUpdatingLocation];
	isTracking = NO;
    
    
	NSDate *now = [[NSDate alloc] init];
	currentRun.endDate = now;
    
	currentRun.totalTime = [NSNumber numberWithDouble:[now timeIntervalSinceDate:currentRun.startDate]];
	//NSLog(@"%f", [now timeIntervalSinceDate:currentRun.startDate]);
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
	[self storePoints];
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)storePoints {
	for (CLLocation *location in routeGPSUpdates) {
		GPSPoint *newPoint = [NSEntityDescription
		                      insertNewObjectForEntityForName:@"GPSPoint"
                              inManagedObjectContext:managedObjectContext];
        
		newPoint.date = location.timestamp;
		newPoint.lat = [NSNumber numberWithDouble:location.coordinate.latitude];
		newPoint.lng = [NSNumber numberWithDouble:location.coordinate.longitude];
		newPoint.myRun = currentRun;
        
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
	}
}

- (void)centerMapToLocation:(id)sender {
	[myLocation setHidden:YES];
	_autoCenter = YES;
	CLLocation *location = [routeGPSUpdates lastObject];
    
	[mapView animateToLocation:location.coordinate];
}

#pragma mark - Location Services



- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
	CLLocation *location = [locations lastObject];
    
    //	NSLog(@"latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
	[routeGPSUpdates addObject:location];
	[_path addCoordinate:location.coordinate];
	_polyline = nil;
	_polyline = [GMSPolyline polylineWithPath:_path];
	_polyline.strokeWidth = 10.f;
	_polyline.geodesic = YES;
	_polyline.map = mapView;
    
	positionMarker.position = location.coordinate;
	if (_autoCenter) {
		[mapView animateToLocation:location.coordinate];
		[mapView animateToZoom:16];
	}
	if (location.speed < 0) {
		speed.text = @"Speed N/A";
	}
	else {
		int speedKPH = (int)(location.speed * 3.6);
		NSNumber *number = [NSNumber numberWithInt:speedKPH];
        
		NSNumberFormatter *formatter = [NSNumberFormatter new];
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
		speed.text = [NSString stringWithFormat:@"%@ KM/H", [formatter stringFromNumber:number]];
	}
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
	if (gesture) {
		_autoCenter = NO;
		[myLocation setHidden:NO];
	}
}

@end
