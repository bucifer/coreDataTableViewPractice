//
//  Celeb.h
//  Terry Practice Core Data
//
//  Created by Aditya Narayan on 9/19/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Celeb : NSManagedObject

@property (nonatomic, strong) NSNumber *celeb_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;


@end
