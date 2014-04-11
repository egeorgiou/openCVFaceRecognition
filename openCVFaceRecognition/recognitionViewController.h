//
//  recognitionViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 04/04/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "People.h"
#import "Images.h"
#import <opencv2/highgui/cap_ios.h>
#import <CRToast/CRToast.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "FXLabel.h"
#import "TYMProgressBarView.h"

@interface recognitionViewController : UIViewController <CvVideoCameraDelegate>
{
    cv::CascadeClassifier faceCascade;
    cv::Ptr<cv::FaceRecognizer> model;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;

@property (strong, nonatomic) NSMutableArray *peopleArray;
@property (strong, nonatomic) NSMutableDictionary *peopleDictionary;
@property (strong, nonatomic) NSMutableDictionary *peopleNameDictionary;

@property (strong, nonatomic) IBOutlet FXLabel *nameLabel;
@property (nonatomic, strong) TYMProgressBarView *progressBarView;

- (IBAction)switchButtonPressed:(id)sender;
@end
