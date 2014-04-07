//
//  recognitionViewController.m
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 04/04/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import "recognitionViewController.h"

BOOL modeltrained;

@interface recognitionViewController ()

@end

@implementation recognitionViewController

@synthesize videoCamera, previewImage, peopleArray, peopleDictionary, peopleNameDictionary, nameLabel;

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
    
    model = cv::createEigenFaceRecognizer();
    
    //previewImage.layer.borderWidth=5;
    //previewImage.layer.borderColor=[UIColor blackColor].CGColor;
    
    previewImage.layer.shadowColor=[UIColor grayColor].CGColor;
    previewImage.layer.shadowOffset=CGSizeMake(2, 2);
    previewImage.layer.shadowOpacity=1.0;
    
    nameLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    nameLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    nameLabel.shadowBlur = 1.0f;
    nameLabel.innerShadowBlur = 2.0f;
    nameLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    nameLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    
    [self setupCamera];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self trainModel];
    
    [videoCamera start];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [videoCamera stop];
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
    
    if (face.size() > 0) {
        if (modeltrained) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                cv::Mat onlyTheFace;
                cv::cvtColor(image(face[0]), onlyTheFace, CV_RGB2GRAY);
                cv::resize(onlyTheFace, onlyTheFace, cv::Size(100, 100), 0, 0);
                
                int predicted = -1;
                double confidence = 0.0;
                
                model->predict(onlyTheFace, predicted, confidence);
                
                NSString *confidenceText = [[NSString alloc] init];
                
                if (confidence > 3000) {
                    confidenceText = @" (Low)";
                }
                else if (confidence > 2000) {
                    confidenceText = @" (Med)";
                } else if (confidence < 1000) {
                    confidenceText = @" (High)";
                }
                
                //[confidenceLabel setText:[NSString stringWithFormat:@"%f", confidence]];
                
                if (predicted == -1) {
                    [nameLabel setText:@"face not in db"];
                } else {
                    People *record = [peopleArray objectAtIndex:predicted];
                    [nameLabel setText:[NSString stringWithFormat:@"%@%@", record.name, confidenceText]];
                }
            });
        }
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [nameLabel setText:@"face not found"];
        });
        
    }

    for (int i = 0; i < face.size(); i++)
    {
        cv::Point pt1(face[i].x + face[i].width, face[i].y + face[i].height);
        cv::Point pt2(face[i].x, face[i].y);
        
        cv::rectangle(image, pt1, pt2, cvScalar(0, 255, 0, 0), 1, 8 ,0);
    }
}

-(void)trainModel
{
        std::vector<cv::Mat> images;
        std::vector<int> labels;
    
        peopleArray = [[NSMutableArray alloc] init];
        peopleDictionary = [[NSMutableDictionary alloc] init];
        peopleNameDictionary = [[NSMutableDictionary alloc] init];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"People" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError* error;
        NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
        for (int i = 0; i < fetchedRecords.count; i++) {
            People *record = [fetchedRecords objectAtIndex:i];
            [peopleArray addObject:record];
            
            NSSet *set = record.images;
            NSArray *recordArray = [set allObjects];
            
            for (int j = 0; j < set.count; j++)
            {
                Images *imageRecord = [recordArray objectAtIndex:j];
                NSData *imageData = imageRecord.image;
                cv::Mat faceData = cv::Mat(100, 100, CV_8UC1);
                faceData.data = (unsigned char*)imageData.bytes;
                
                images.push_back(faceData);
                labels.push_back(i);
            }
        }
    
        if (images.size() > 0 && labels.size() > 0) {
            model->train(images, labels);
            modeltrained = YES;
        }
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
