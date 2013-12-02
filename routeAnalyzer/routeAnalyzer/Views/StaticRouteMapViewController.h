//
//  StaticRouteMapViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 11/30/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface StaticRouteMapViewController : UIViewController


@property (nonatomic,retain) IBOutlet GMSMapView *mapView;
@property (nonatomic,strong) NSArray *route;

@end
