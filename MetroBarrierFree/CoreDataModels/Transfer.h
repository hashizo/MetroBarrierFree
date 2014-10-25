//
//  Transfer.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Line, Platform;

@interface Transfer : NSManagedObject

@property (nonatomic, retain) NSNumber * necessaryTime;
@property (nonatomic, retain) NSString * railDirection;
@property (nonatomic, retain) NSString * railway;
@property (nonatomic, retain) Line *line;
@property (nonatomic, retain) Platform *platform;

@end
