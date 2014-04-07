//
//  People.h
//  openCVFaceRecognition
//
//  Created by Evangelos Georgiou on 05/04/2014.
//  Copyright (c) 2014 Evangelos Georgiou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Images;

@interface People : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileimage;
@property (nonatomic, retain) NSSet *images;
@end

@interface People (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Images *)value;
- (void)removeImagesObject:(Images *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
