//
//  editPersonViewController.m
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 22/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import "editPersonViewController.h"

@interface editPersonViewController ()

@end

@implementation editPersonViewController

@synthesize personsNameTextField, profilePictureImage, person;

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
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlertView show];
    }
    
    [self getPeopleDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeProfilePictureButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *choosenImage = info[UIImagePickerControllerEditedImage];
    [profilePictureImage setImage:choosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)viewPressed:(id)sender {
    [personsNameTextField resignFirstResponder];
}

- (IBAction)updateButtonPressed:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"People" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self = %@)", person.objectID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchRecords.count == 1) {
        NSManagedObject *updateRecord = [fetchRecords objectAtIndex:0];
        [updateRecord setValue:[NSString stringWithFormat:@"%@", personsNameTextField.text] forKey:@"name"];
        [updateRecord setValue:UIImagePNGRepresentation(profilePictureImage.image) forKey:@"profileimage"];
        
        People *record = [fetchRecords objectAtIndex:0];
        [personsNameTextField setText:[NSString stringWithFormat:@"%@", record.name]];
        [profilePictureImage setImage:[UIImage imageWithData:record.profileimage]];
        
        NSError *saveError;
        if (![self.managedObjectContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
    else
    {
        NSLog(@"error - %@", error);
    }
}

- (void)getPeopleDetails
{
    [personsNameTextField setText:[NSString stringWithFormat:@"%@", person.name]];
    [profilePictureImage setImage:[UIImage imageWithData:person.profileimage]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"trainperson"]) {
        trainPersonViewController *trainPersonSegueViewController = [segue destinationViewController];
        trainPersonSegueViewController.person = person;
    }
}

@end
