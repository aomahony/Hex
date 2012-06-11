//
//  AFormatter.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/9/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    FORMATTER_DISPLAY_SIZE_NULL = 0,
    FORMATTER_DISPLAY_SIZE_BYTE,
    FORMATTER_DISPLAY_SIZE_WORD,
    FORMATTER_DISPLAY_SIZE_DWORD,
    FORMATTER_DISPLAY_SIZE_QWORD
    
}formatterDisplaySize;

typedef enum
{
    FORMATTER_SEARCH_MODE_NULL = 0,
    FORMATTER_SEARCH_MODE_BINARY,
    FORMATTER_SEARCH_MODE_TEXT
    
}formatterSearchMode;

@interface AFormatter : NSObject
{
    formatterDisplaySize currentDisplaySize;
    NSData* data;
    
    NSInteger stride;
}

@property (nonatomic, assign) formatterDisplaySize currentDisplaySize;
@property (nonatomic, retain) NSData* data;
@property (readonly) NSString* formattedString;

@property (readonly) NSArray* displaySizeStrings;

- (NSArray*)getFormattedRangesForSearchQuery:(NSString*)query
                                  searchMode:(formatterSearchMode)searchMode;

- (NSInteger)getFormattedAddressOffset:(NSString*)address;

@end
