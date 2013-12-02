//
//  AddRouteViewController.h
//  routeAnalyzer
//
//  Created by Marco Salazar A on 11/25/13.
//  Copyright (c) 2013 Avantica Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AddRouteViewController : UIViewController<UITextFieldDelegate>{
    
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic,retain) IBOutlet UITextField *name;


-(IBAction)cancel:(id)sender;
-(IBAction)addRoute:(id)sender;

-(void)viewTouched:(UITapGestureRecognizer *)recognizer;
@end
