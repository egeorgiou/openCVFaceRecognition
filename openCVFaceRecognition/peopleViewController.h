//
//  peopleViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 21/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "People.h"
#import "trainPersonViewController.h"
#import <CRToast/CRToast.h>

@interface peopleViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSNumber *indexNumber;
@property (retain, nonatomic) NSMutableArray *personArray;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@end
