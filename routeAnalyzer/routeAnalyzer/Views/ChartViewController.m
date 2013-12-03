//
//  ChartViewController.m
//  routeAnalyzer
//
//  Created by Marco Salazar on 12/2/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import "ChartViewController.h"
#import "Run.h"

@interface ChartViewController ()

@end

@implementation ChartViewController
@synthesize webView;
@synthesize routeRuns;
@synthesize statsForGraph;
@synthesize activityIndicator;

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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd/MM/yy";
     statsForGraph = [[NSMutableDictionary alloc]init];
    for(Run *r in routeRuns){
        NSNumber *oldValue = [statsForGraph objectForKey:[dateFormatter stringFromDate:r.startDate]];
        if (oldValue) {
            oldValue = [NSNumber numberWithDouble:([oldValue doubleValue]+  [r.totalTime doubleValue] )];
            [statsForGraph setObject:oldValue forKey:[dateFormatter stringFromDate:r.startDate]];
        }
        else {
            [statsForGraph setObject:r.totalTime forKey:[dateFormatter stringFromDate:r.startDate]];
        }
        
    }
    
    [self loadHTML];
    [self generateStatsFromDictionary:statsForGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)timeFromTimeInterval:(NSNumber *)interval {
	NSTimeInterval timeInterval = [interval doubleValue];
	NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *enUSLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
	[dateFormatter setLocale:enUSLocale];
	[dateFormatter setDateFormat:@"mm"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
	return [dateFormatter stringFromDate:timerDate];
}

-(void)loadHTML{

    NSString *htmlHead = [NSString stringWithFormat:@"%@",
    @"<html>"
    "<head>"
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>"
    "<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>"
    "<script type=\"text/javascript\">"
    "google.load(\"visualization\", \"1\", {packages:[\"corechart\"]});"
    "google.setOnLoadCallback(drawChart);"
    "function drawChart() {"
    "var data = google.visualization.arrayToDataTable(["
    "['Day', 'Minutes',{ role: 'annotation' }],"];
    
    NSString *htmlFooter = [NSString stringWithFormat:@"%@",
    @"]);"
    "var options = {"
    "title: 'Route Times (in minutes)',"
    "hAxis: {title: 'Day'},"
    "legend: { position: \"none\" },"
    "};"
    "var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));"
    "chart.draw(data, options);"
    "}"
    "</script>"
    "</head>"
    "<body>"
    "<div id=\"chart_div\" ></div>"
    "</body>"
    "</html>"];
    
    [webView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",htmlHead,[self generateStatsFromDictionary:statsForGraph],htmlFooter]
                    baseURL:nil];


}
-(NSString *) generateStatsFromDictionary:(NSDictionary *)dictionary{

    NSString *stats = @"";
    
    for(NSString * key in dictionary){
        
        NSString *time = [self timeFromTimeInterval:[dictionary objectForKey:key]];
        NSString *row = [NSString stringWithFormat:@"['%@',%@, %@],",key,time,time];
        stats = [stats stringByAppendingString:row];
    
    }
    
    return stats;

}

#pragma mark - UIWebView Delegates
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

@end
