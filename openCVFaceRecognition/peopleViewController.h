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
#import "editPersonViewController.h"

@interface peopleViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSNumber *indexNumber;

@property (retain, nonatomic) NSMutableArray *personIdArray;
@property (retain, nonatomic) NSMutableArray *personNameArray;
@property (retain, nonatomic) NSMutableArray *personCreatedDateArray;

- (IBAction)editButtonPressed:(id)sender;

@end
