//
//  newPersonViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 21/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "People.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface newPersonViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)takeProfilePictureButtonPressed:(id)sender;
- (IBAction)savePersonButtonPressed:(id)sender;
- (IBAction)viewPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (strong, nonatomic) IBOutlet UITextField *personsNameTextField;

@end
