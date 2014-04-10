//
//  peopleViewController.m
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 21/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import "peopleViewController.h"

@interface peopleViewController ()
{
    UIRefreshControl *refreshControl;
}
@end

@implementation peopleViewController

@synthesize tableview, personArray, indexNumber;

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
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    indexNumber = 0;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableview) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    personArray = [[NSMutableArray alloc] init];
    
    [self getPeopleDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableview
{
    personArray = [[NSMutableArray alloc] init];
    
    [self getPeopleDetails];
    
    [refreshControl endRefreshing];
}

- (void)getPeopleDetails
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"People" inManagedObjectContext:self.managedObjectContext]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchRecords.count > 0) {
        for (int i = 0; i < fetchRecords.count; i++) {
            [personArray addObject:[fetchRecords objectAtIndex:i]];
        }
        
        [tableview reloadData];
    }
    else
    {
        NSLog(@"error - %@", error);
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"List of People";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    People *record = [personArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ (%lu)", record.name, (unsigned long)[record.images count]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", record.created]];
    
    return cell;
}

- (IBAction)editButtonPressed:(id)sender {
    if ([self.tableview isEditing]) {
        [self.tableview setEditing:NO animated:YES];
    }
    else
    {
        [self.tableview setEditing:YES animated:YES];
    }
}

- (IBAction)addButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add New Person" message:@"Enter the name of the new person" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Save", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    [[alert textFieldAtIndex:0] resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        People *record = [personArray objectAtIndex:indexPath.row];
        
        NSManagedObject *objectToDelete = [self.managedObjectContext objectWithID:record.objectID];
        [self.managedObjectContext deleteObject:objectToDelete];

        NSError* error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [personArray removeObjectAtIndex:indexPath.row];
        
        [self.tableview reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexNumber = [NSNumber numberWithInteger:indexPath.item];
    [self performSegueWithIdentifier:@"trainperson" sender:self.view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"trainperson"]) {
        trainPersonViewController *trainPersonSegueViewController = [segue destinationViewController];
        trainPersonSegueViewController.person = [personArray objectAtIndex:[indexNumber integerValue]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        if (![textField.text isEqualToString:@""]) {
            People *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:self.managedObjectContext];
            newPerson.name = textField.text;
            newPerson.created = [NSDate date];
            
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            NSDictionary *options = @{
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                      kCRToastTextKey : @"New person added...",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor orangeColor],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            personArray = [[NSMutableArray alloc] init];
                                            
                                            [self getPeopleDetails];
                                            NSLog(@"Completed");
                                        }];
        }
        else {
            NSDictionary *options = @{
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                      kCRToastTextKey : @"Person not added...",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor orangeColor],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            NSLog(@"Completed");
                                        }];
        }
    }
    else {
        NSDictionary *options = @{
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastTextKey : @"Person not added...",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor orangeColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    }
}

@end
