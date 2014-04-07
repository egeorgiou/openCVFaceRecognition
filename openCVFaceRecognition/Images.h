//
//  Images.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 05/04/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class People;

@interface Images : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) People *person;

@end
