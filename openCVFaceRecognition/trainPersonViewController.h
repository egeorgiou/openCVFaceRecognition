//
//  trainPersonViewController.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 25/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>

@interface trainPersonViewController : UIViewController <CvVideoCameraDelegate>
{
    
}

@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;

@end
