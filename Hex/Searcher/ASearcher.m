//
//  ASearcher.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/15/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "ASearcher.h"

@implementation ASearcher
@synthesize data;

+ (NSData*)dataFromTextString:(NSString*)string
{
    return ([string dataUsingEncoding:NSASCIIStringEncoding]);
}

+ (NSData*)dataFromHexString:(NSString*)hexString
{
    NSMutableData* data = [NSMutableData new];
    
    @autoreleasepool
    {
        NSInteger length = [hexString length] - ([hexString length] % 2);
        
        for (NSInteger i = 0; i < length; i += 2)
        {
            NSInteger value = strtol ([[[hexString substringWithRange:NSMakeRange (i, 2)] uppercaseString]
                                       cStringUsingEncoding:NSASCIIStringEncoding], NULL, 16);
            
            [data appendBytes:(const void*)&value
                       length:1];
        }
    }
    
    NSData* ret = [NSData dataWithData:data];
    [data release];
    
    return (ret);
}

- (NSArray*)searchDataForData:(NSData*)d
{
    NSMutableArray* array = [NSMutableArray new];
    
    @autoreleasepool
    {
        NSInteger searchLength = [d length];
        NSInteger totalLength = [data length];
        
        if (searchLength > 0)
        {        
            NSInteger i = 0;
            while (i < totalLength)
            {
                if (totalLength - i < searchLength)
                    break;
                
                if ([d isEqualToData:[data subdataWithRange:NSMakeRange (i, searchLength)]])
                {
                    [array addObject:[NSValue valueWithRange:NSMakeRange (i, searchLength)]];
                    i += searchLength;
                }
                else
                    i ++;
            }
        }
    }
    
    NSArray* ret = [NSArray arrayWithArray:array];
    [array release];
    
    return (ret);
}

- (NSInteger)extractAddressFromSearchString:(NSString*)addressString
{
    if (![addressString length])
        return (-1);
    
    NSString* extractedAddress = nil;
    [addressString getCapturesWithRegexAndReferences:@"^((0x|0X)?([0-9A-Fa-f]{1,8}))$",
     @"$3", &extractedAddress, nil];
        
    if (!extractedAddress)
        return (-1);
     
    return (strtol ([[extractedAddress uppercaseString] cStringUsingEncoding:NSASCIIStringEncoding], NULL, 16));
}

- (void)dealloc
{
    self.data = nil;
    [super dealloc];
}

@end
