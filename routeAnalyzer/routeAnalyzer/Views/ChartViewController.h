//
//  ChartViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar on 12/2/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSArray *routeRuns;
@property (nonatomic,retain) NSMutableDictionary * statsForGraph;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
