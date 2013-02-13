//
//  MRDStateFactory.h
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/12/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRDStateData;

@interface MRDStateFactory : NSObject

+ (MRDStateFactory *)sharedFactory;

- (NSArray *)allStates;
- (MRDStateData *)stateWithName:(NSString *)name;

@end
