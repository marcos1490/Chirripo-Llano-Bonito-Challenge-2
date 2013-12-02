//
//  DynamicRouteMapViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 12/1/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Route.h"
#import "Run.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DynamicRouteMapViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>

@property (nonatomic,strong) IBOutlet UIView *draggableView;

@property (nonatomic,retain) NSMutableArray *routeGPSUpdates;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *stopDate;
@property (nonatomic,retain) Route *routeTracked;
@property (nonatomic,retain) Run *currentRun;
@property (nonatomic,assign) bool isTracking;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic, retain) GMSMarker *positionMarker;
@property (nonatomic,retain) IBOutlet UIButton *myLocation;
@property (nonatomic,retain) IBOutlet GMSMapView *mapView;
@property (nonatomic,retain) IBOutlet UILabel *speed;
@property (nonatomic,retain) IBOutlet UILabel *timer;

@property (strong, nonatomic) NSTimer *stopWatchTimer;

-(IBAction)stopTrackingRoute:(id)sender;

-(IBAction)centerMapToLocation:(id)sender;
@end
