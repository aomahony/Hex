//
//  ASearcher.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/15/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SEARCHER_BYTE_ORDER_NULL = 0,
    SEARCHER_BYTE_ORDER_LITTLE_ENDIAN,
    SEARCHER_BYTE_ORDER_BIG_ENDIAN
    
}searcherByteOrder;

@interface ASearcher : NSObject
{
    NSData* data;
}

@property (nonatomic, retain) NSData* data;

+ (NSData*)dataFromTextString:(NSString*)string;
+ (NSData*)dataFromHexString:(NSString*)hexString;

- (NSArray*)searchDataForData:(NSData*)d;

- (NSInteger)extractAddressFromSearchString:(NSString*)addressString;

@end
