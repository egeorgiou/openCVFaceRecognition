//
//  trainPersonViewController.m
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 25/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import "trainPersonViewController.h"

int sampleNumber = 0;
int frameNumber = 0;

@interface trainPersonViewController ()

@end

@implementation trainPersonViewController

@synthesize videoCamera, previewImage, person, sampleTakenLabel, progressBarView;

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
    
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    
    if (!faceCascade.load([faceCascadePath UTF8String])) {
        NSLog(@"Could not load face cascade: %@", faceCascadePath);
    }
    
    progressBarView = [[TYMProgressBarView alloc] initWithFrame:CGRectZero];
    progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat offsetX = 30.0f;
    CGFloat offsetY = 70.0f;
    CGFloat width = (self.view.bounds.size.width - offsetX * 2);
    progressBarView.frame = CGRectMake(offsetX, offsetY, width, 26.0f);
    [self.view addSubview:self.progressBarView];
    
    previewImage.layer.shadowColor=[UIColor grayColor].CGColor;
    previewImage.layer.shadowOffset=CGSizeMake(2, 2);
    previewImage.layer.shadowOpacity=1.0;
    
    [self setupCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCamera
{
    videoCamera = [[CvVideoCamera alloc] initWithParentView:previewImage];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 23;
    videoCamera.grayscaleMode = NO;
}

- (void)processImage:(cv::Mat&)image
{
    cv::Mat grayscaleFrame;
    cvtColor(image, grayscaleFrame, CV_BGR2GRAY);
    equalizeHist(grayscaleFrame, grayscaleFrame);
    
    std::vector<cv::Rect> face;
    faceCascade.detectMultiScale(grayscaleFrame, face, 1.1, 2, CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH, cv::Size(60, 60));
    
    if (frameNumber == 23) {
        if (face.size() > 0) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                cv::Mat onlyTheFace;
                cv::cvtColor(image(face[0]), onlyTheFace, CV_RGB2GRAY);
                cv::resize(onlyTheFace, onlyTheFace, cv::Size(100, 100), 0, 0);
                NSData *imageData = [[NSData alloc] initWithBytes:onlyTheFace.data length:onlyTheFace.elemSize() * onlyTheFace.total()];
                
                /*Images *record = [[Images alloc] init];
                record.image = imageData;
                record.person = person;
                [person addImagesObject:record];*/
                
                Images *newImage = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:self.managedObjectContext];
                newImage.image = imageData;
                newImage.person = person;
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                
                sampleNumber++;
                [sampleTakenLabel setText:[NSString stringWithFormat:@"%d", sampleNumber]];
                frameNumber = 0;
            });
        }
    } else
    { frameNumber++; }
    
    for (int i = 0; i < face.size(); i++)
    {
        cv::Point pt1(face[i].x + face[i].width, face[i].y + face[i].height);
        cv::Point pt2(face[i].x, face[i].y);
        
        cv::rectangle(image, pt1, pt2, cvScalar(0, 255, 0, 0), 1, 8 ,0);
    }
}

- (IBAction)startTrainingButtonPressed:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"People" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self = %@)", person.objectID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchRecords.count == 1) {
        People *record = [fetchRecords objectAtIndex:0];
        [record removeImages:record.images];
        
        NSError *saveError;
        if (![self.managedObjectContext save:&saveError]) {
            NSLog(@"Whoops, couldn't save: %@", [saveError localizedDescription]);
        }
    }
    else
    {
        NSLog(@"error - %@", error);
    }
    
    sampleNumber = 0;
    [videoCamera start];
}

- (IBAction)stopTrainingButtonPressed:(id)sender {
    sampleNumber = 0;
    [videoCamera stop];
}

- (IBAction)switchButtonPressed:(id)sender {
    [videoCamera stop];
    
    if (videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionFront) {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    } else {
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    
    [videoCamera start];
}

@end
