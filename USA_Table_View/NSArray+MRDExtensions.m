//
//  NSArray+MRDExtensions.m
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/12/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "NSArray+MRDExtensions.h"

@implementation NSArray (MRDExtensions)

- (NSArray *)sortedStringArray;
{
	return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		assert([obj1 isKindOfClass:[NSString class]]);
		assert([obj2 isKindOfClass:[NSString class]]);
		return [(NSString *)obj1 compare:(NSString *)obj2];
	}];
}

@end
