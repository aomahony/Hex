//
//  AFile.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/7/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFile : NSObject
{
    NSString* filename;
    NSData* data;
}

@property (nonatomic, retain) NSString* filename;
@property (readonly) NSData* data;

@end
