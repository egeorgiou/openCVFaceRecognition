//
//  newPersonViewController.m
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 21/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import "newPersonViewController.h"

@interface newPersonViewController ()

@end

@implementation newPersonViewController

@synthesize profilePictureImage, personsNameTextField;

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

- (IBAction)savePersonButtonPressed:(id)sender {
    [personsNameTextField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    People *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:self.managedObjectContext];
    newPerson.name = personsNameTextField.text;
    newPerson.created = [NSDate date];
    
    NSData *imageData = UIImagePNGRepresentation(profilePictureImage.image);
    newPerson.profileimage = imageData;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Profile Saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    myAlertView.delegate = self;
    [myAlertView show];
}

- (IBAction)viewPressed:(id)sender {
    [personsNameTextField resignFirstResponder];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
}

@end
