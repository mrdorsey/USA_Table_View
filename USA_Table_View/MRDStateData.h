//
//  MRDStateData.h
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/11/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MRDStateDataImageSize) {
	MRDStateDataImageSizeSmall = 50,
	MRDStateDataImageSizeLarge = 200
};

static NSString * const kMRDStateDataNameKey = @"name";

@interface MRDStateData : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *abbreviation;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSNumber *area;
@property (nonatomic, readonly) NSNumber *population;
@property (nonatomic, readonly) NSString *capital;
@property (nonatomic, readonly) NSString *populousCity;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (UIImage *)imageWithSize:(MRDStateDataImageSize)size;

@end
