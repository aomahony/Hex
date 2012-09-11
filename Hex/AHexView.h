//
//  AHexView.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/21/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFormatter.h"

@interface AHexView : NSTextView <NSTextViewDelegate>
{
    AFormatter* currentFormatter;
    
    NSArray* currentAddressesSelected;

    BOOL mouseEntered;
    BOOL mouseDown;
    
    NSInteger selectionStartOffset;
    formatterSelectionMode currentSelectionMode;
}

@property (readonly) NSArray* displaySizeStrings;
@property (nonatomic, assign) formatterDisplaySize currentDisplaySize;
@property (nonatomic, retain) NSArray* currentAddressesSelected;

@property (nonatomic, retain) NSData* data;

- (void)gotoAddress:(NSInteger)address;

- (NSData*)formatDataBasedOnDisplay:(NSData*)d;

- (void)selectSelectedAddressIndex:(NSInteger)index;

@end
