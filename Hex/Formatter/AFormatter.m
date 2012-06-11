//
//  AFormatter.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/9/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "AFormatter.h"

@implementation AFormatter
@synthesize currentDisplaySize, data;

- (id)init
{
    if (self = [super init])
    {
        currentDisplaySize = FORMATTER_DISPLAY_SIZE_QWORD;//BYTE;
        stride = 16;
    }
    return (self);
}

- (NSInteger)displaySize
{
    if (currentDisplaySize == FORMATTER_DISPLAY_SIZE_BYTE)
        return (1);
    else if (currentDisplaySize == FORMATTER_DISPLAY_SIZE_WORD)
        return (2);
    else if (currentDisplaySize == FORMATTER_DISPLAY_SIZE_DWORD)
        return (4);
    else if (currentDisplaySize == FORMATTER_DISPLAY_SIZE_QWORD)
        return (8);
    return (0);
}

- (NSArray*)displaySizeStrings
{
    return ([NSArray arrayWithObjects:@"1 byte", @"2 bytes", @"4 bytes", @"8 bytes", nil]);
}

- (NSString*)getLineFromOffset:(NSInteger)offset
{
    NSInteger displayByteSize = [self displaySize];
    unsigned char* displayByteBuffer = (unsigned char*)malloc (displayByteSize);
    
    NSInteger currentSpaceCounter = 0;
    NSInteger maxSpaceCounter = displayByteSize;
    
    NSInteger numLineBytes = MIN ([data length] - offset, stride);    
    NSInteger numDisplayWords = numLineBytes / displayByteSize;
    NSInteger numPaddingBytes = numLineBytes % displayByteSize;
    NSInteger numXBytes = (stride - numLineBytes) % stride;
    
    NSMutableString* string = [NSMutableString new];
    
    [string appendFormat:@"0x%.8X: ", offset];
    
    for (NSInteger i = 0; i < numDisplayWords; i ++)
    {
        [data getBytes:displayByteBuffer
                 range:NSMakeRange (offset + (i * displayByteSize), displayByteSize)];
    
        if (displayByteSize == 1)
            [string appendFormat:@"%.2X ", *displayByteBuffer];
        else if (displayByteSize == 2)
            [string appendFormat:@"%.4X ", *(unsigned short*)displayByteBuffer];
        else if (displayByteSize == 4)
            [string appendFormat:@"%.8X ", *(unsigned int*)displayByteBuffer];
        else if (displayByteSize == 8)
            [string appendFormat:@"%.16X ", *(long long*)displayByteBuffer];
    }
    
    NSInteger paddingOffset = (offset + (numDisplayWords * displayByteSize));
    for (NSInteger i = 0; i < numPaddingBytes; i ++)
    {
        [data getBytes:displayByteBuffer
                 range:NSMakeRange (paddingOffset + i, 1)];
    
        [string appendFormat:@"%.2X", *displayByteBuffer];
        currentSpaceCounter ++;
        if (currentSpaceCounter == maxSpaceCounter)
        {
            [string appendString:@" "];
            currentSpaceCounter = 0;
        }
    }
    
    for (NSInteger i = 0; i < numXBytes; i ++)
    {
        [string appendString:@"XX"];
        currentSpaceCounter ++;
        if (currentSpaceCounter == maxSpaceCounter)
        {
            [string appendString:@" "];
            currentSpaceCounter = 0;
        }        
    }
    
    unsigned char lineByteArray [numLineBytes];
    [data getBytes:lineByteArray
             range:NSMakeRange (offset, numLineBytes)];
    for (NSInteger i = 0; i < stride; i ++)
    {
        if (isprint (lineByteArray [i]) &&
            (i < numLineBytes))
            [string appendFormat:@"%c", lineByteArray [i]];
        else
            [string appendString:@"."];
    }
    
    [string appendString:@"\n"];
    NSString* ret = [NSString stringWithString:string];
    [string release];
    
    free (displayByteBuffer);
    
    return (ret);
}

- (NSString*)formattedString
{
    NSMutableString* string = [[NSMutableString alloc] init];
    
    @autoreleasepool
    {
        for (NSInteger i = 0; i < [data length]; i += stride)
        {    
            [string appendString:[self getLineFromOffset:i]];
        }
    }
    
    NSString* ret = [NSString stringWithString:string];
    [string release];
    
    return (ret);
}

- (void)setData:(NSData*)d
{
    if (data != d)
    {
        [data release];
        data = [d retain];
    }
}

- (NSInteger)getFormattedAddressOffset:(NSString*)address
{
    return (([address integerValue] / stride));
}

- (NSArray*)getFormattedRangesForSearchQuery:(NSString*)query
                                  searchMode:(formatterSearchMode)searchMode
{
    return ([NSArray new]);
}

- (NSRange)getFormattedAddressRange:(NSString*)address
{
    return (NSMakeRange (0, 0));
}

- (void)dealloc
{
    self.data = nil;
    [super dealloc];
}

@end
