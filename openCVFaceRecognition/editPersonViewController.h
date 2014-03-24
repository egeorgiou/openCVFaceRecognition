//
//  editPersonViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 22/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "People.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface editPersonViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectID *personID;

@property (strong, nonatomic) IBOutlet UITextField *personsNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImage;

- (IBAction)takeProfilePictureButtonPressed:(id)sender;
- (IBAction)viewPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;

@end
