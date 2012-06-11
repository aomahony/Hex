//
//  AFile.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/7/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "AFile.h"

@implementation AFile
@synthesize filename;

- (NSData*)data
{
    return (data);
}

- (void)setFilename:(NSString*)f
{
    if (f != filename)
    {
        [filename release];
        filename = [f retain];
        
        [data release];
        data = [[NSData alloc] initWithContentsOfFile:f];
    }
}

- (void)dealloc
{
    self.filename = nil;
    [data release];
    [super dealloc];
}

@end
