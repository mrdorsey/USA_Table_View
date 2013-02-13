//
//  MRDStateData.m
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/11/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDStateData.h"

@interface MRDStateData ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *abbreviation;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *area;
@property (nonatomic, strong) NSNumber *population;
@property (nonatomic, strong) NSString *capital;
@property (nonatomic, strong) NSString *populousCity;

@end

@implementation MRDStateData

- (id)initWithAttributes:(NSDictionary *)attributes;
{
	if (!(self = [super init])) {
		return nil;
	}
	
	NSArray *attributeNames = @[ @"name", @"abbreviation", @"date", @"area", @"population", @"capital", @"populousCity" ];
 	for (NSString *key in attributeNames) {
		[self setValue:attributes[key] forKey:key];
	}
	
	return self;
}

- (UIImage *)imageWithSize:(MRDStateDataImageSize)size;
{
	return [UIImage imageNamed:[self _imageFileNameForSize:size]];
}

#pragma mark private helpers

- (NSString *)_imageFileNameForSize:(MRDStateDataImageSize)size;
{
	NSString *prefix = [[self.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	return [NSString stringWithFormat:@"%@-%u", prefix, size];
}

- (NSString *)_imageFilePathForSize:(MRDStateDataImageSize)size;
{
	return [[NSBundle mainBundle] pathForResource:[self _imageFileNameForSize:size] ofType:@"png"];
}

@end