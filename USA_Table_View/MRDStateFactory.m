//
//  MRDStateFactory.m
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/12/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDStateData.h"
#import "MRDStateFactory.h"

@interface MRDStateFactory ()

@property (nonatomic, strong) NSArray *stateData;
@property (nonatomic, strong) NSDictionary *states;

- (NSString *)_dataFilePath;

@end

@implementation MRDStateFactory

#pragma mark Singleton

+ (MRDStateFactory *)sharedFactory;
{
	static MRDStateFactory *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[MRDStateFactory alloc] init];
	});
	
	return _sharedInstance;
}

- (NSArray *)allStates;
{
	return [[self.states allValues] sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:kMRDStateDataNameKey ascending:YES]]];
}

- (MRDStateData *)stateWithName:(NSString *)name;
{
	return self.states[name];
}

#pragma mark custom accessors
- (NSDictionary *)states;
{
	if(_states == nil) {
		NSMutableDictionary *stateData = [NSMutableDictionary dictionaryWithCapacity:self.stateData.count];
		for (NSDictionary *stateDict in self.stateData) {
			[stateData setObject:[[MRDStateData alloc] initWithAttributes:stateDict] forKey:stateDict[kMRDStateDataNameKey]];
		}
		
		_states = stateData;
	}
	
	return _states;
}

- (NSArray *)stateData;
{
	if(_stateData == nil) {
		_stateData = [NSArray arrayWithContentsOfFile:[self _dataFilePath]];
	}
	
	return _stateData;
}

#pragma mark private helpers

- (NSString *)_dataFilePath;
{
	return [[NSBundle mainBundle] pathForResource:@ "states" ofType:@"plist"];
}

@end
