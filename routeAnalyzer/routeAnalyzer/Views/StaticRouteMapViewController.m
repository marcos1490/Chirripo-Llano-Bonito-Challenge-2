//
//  StaticRouteMapViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar on 11/30/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "StaticRouteMapViewController.h"
#import "GPSPoint.h"
@interface StaticRouteMapViewController ()

@end

@implementation StaticRouteMapViewController
@synthesize mapView;
@synthesize route;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (route) {
        [self drawRoute];
       
    }
}

-(void)drawRoute{
    GMSMutablePath *path = [GMSMutablePath path];
    GMSMarker *startMarker = [[GMSMarker alloc] init];
    GMSMarker *endMarker = [[GMSMarker alloc] init];
    GPSPoint *start = [route firstObject];
    GPSPoint *end = [route lastObject];
    
    for(GPSPoint *point in route){
        
        [path addCoordinate:CLLocationCoordinate2DMake([point.lat doubleValue], [point.lng doubleValue])];
    }
    
    
    startMarker.position = CLLocationCoordinate2DMake([start.lat doubleValue], [start.lng doubleValue]);
    startMarker.title = @"Start";
    startMarker.snippet = [NSString stringWithFormat: @"%@",[self formatDate:start.date]];
    startMarker.map = mapView;
    
    endMarker.position = CLLocationCoordinate2DMake([end.lat doubleValue], [end.lng doubleValue]);
    endMarker.title = @"Finish";
    endMarker.snippet = [NSString stringWithFormat: @"%@",[self formatDate:end.date]];
    endMarker.map = mapView;
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 10.f;
    polyline.geodesic = YES;
    polyline.map = mapView;
    
    
    [mapView animateToLocation:startMarker.position];
    
    [mapView animateToZoom:16];



}
#pragma mark - Time Helpers

- (NSString *)formatDate:(NSDate *)date {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy hh:mm a"];
	return [dateFormat stringFromDate:date];
}

-(NSString *)timeFromTimeInterval:(NSNumber *)interval{
    
    NSTimeInterval timeInterval = [interval doubleValue];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
    [dateFormatter setLocale:enUSLocale];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    return [dateFormatter stringFromDate:timerDate];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
