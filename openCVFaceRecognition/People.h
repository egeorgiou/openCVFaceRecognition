//
//  People.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 21/03/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileimage;
@property (nonatomic, retain) NSDate * created;

@end
