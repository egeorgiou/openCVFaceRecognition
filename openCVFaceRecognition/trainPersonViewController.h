//
//  trainPersonViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 25/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "People.h"
#import "Images.h"
#import <opencv2/highgui/cap_ios.h>
#import "TYMProgressBarView.h"
#import <CRToast/CRToast.h>

@interface trainPersonViewController : UIViewController <CvVideoCameraDelegate>
{
    cv::CascadeClassifier faceCascade;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) People *person;
@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (nonatomic, strong) TYMProgressBarView *progressBarView;
@property (strong, nonatomic) IBOutlet UIButton *trainingButton;

- (IBAction)switchButtonPressed:(id)sender;
- (IBAction)trainingButtonPressed:(id)sender;

@end
