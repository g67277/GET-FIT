//
//  PicEntity.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/24/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PicEntity : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * image;

@end
