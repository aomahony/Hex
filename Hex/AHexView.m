//
//  AHexView.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/21/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "AHexView.h"

@implementation AHexView
@synthesize currentAddressesSelected, data;

- (id)initWithFrame:(NSRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        currentFormatter = [AFormatter new];
        currentFormatter.numberOfCharactersPerLine = 16 + (16 * 3) + (12) + 1;
        
        self.delegate = self;
        
        selectionStartOffset = -1;
    }
    return (self);
}

- (void)setSelectedRange:(NSRange)r
{
    NSLayoutManager *layoutManager = [self layoutManager];
    if (r.location == 0 &&
        r.length == 0)
        [layoutManager removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:NSMakeRange (0, [[self textStorage] length])];
    else
        [self setSelectedRanges:[NSArray arrayWithObject:[NSValue valueWithRange:r]]];
}

- (void)setSelectedRanges:(NSArray*)ranges
{
    NSLayoutManager *layoutManager = [self layoutManager];
    
    [self setSelectedRange:NSMakeRange (0, 0)];
    
    for (NSValue* r in ranges)
    {
        [layoutManager addTemporaryAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor yellowColor], NSBackgroundColorAttributeName, nil] forCharacterRange:r.rangeValue];
    }
}

- (void)scrollToAddress:(NSInteger)address
{
    [self scrollRangeToVisible:NSMakeRange ([currentFormatter getFormattedAddressLineOffset:address], 1)];
}

- (void)selectSelectedAddressIndex:(NSInteger)index
{
    if (index < 0 ||
        index >= [currentAddressesSelected count])
        NSLog (@"setSelectedAddressIndex: Invalid index %ld", index);
    else
        [self scrollToAddress:((NSRange)[[currentAddressesSelected objectAtIndex:index] rangeValue]).location];
}

- (void)setCurrentAddressesSelected:(NSArray*)arr
{
    if ([arr count] == [currentAddressesSelected count])
    {
        BOOL same = YES;
        for (NSValue* range in currentAddressesSelected)
        {
            BOOL found = NO;
            for (NSValue* range1 in arr)
            {
                if (range1.rangeValue.length == range.rangeValue.length &&
                    range1.rangeValue.location == range.rangeValue.location)
                {
                    found = YES;
                    break;
                }
            }
            
            if (!found)
            {
                same = NO;
                break;
            }
        }
        
        if (same)
            return;
    }
        
    if (arr != currentAddressesSelected)
    {
        [currentAddressesSelected release];
        currentAddressesSelected = [arr retain];
    }
        
    NSMutableArray* selectedBinaryRanges = [NSMutableArray array];
    NSMutableArray* selectedTextRanges = [NSMutableArray array];
    
    for (NSValue* range in arr)
    {
        [selectedBinaryRanges addObjectsFromArray:[currentFormatter getFormattedRangesOfAddressRange:range.rangeValue
                                                                                          searchMode:FORMATTER_SEARCH_MODE_BINARY]];
                
        [selectedTextRanges addObjectsFromArray:[currentFormatter getFormattedRangesOfAddressRange:range.rangeValue
                                                                                        searchMode:FORMATTER_SEARCH_MODE_TEXT]];
    }
    
    [selectedBinaryRanges addObjectsFromArray:selectedTextRanges];
    
    [self setSelectedRanges:[NSArray arrayWithArray:selectedBinaryRanges]];
}

- (void)gotoAddress:(NSInteger)address
{
    self.currentAddressesSelected = [NSArray arrayWithObject:[NSValue valueWithRange:NSMakeRange (address, [currentFormatter getDisplaySizeForAddress:address])]];
    
    [self scrollToAddress:address];
}

- (void)setData:(NSData*)d
{
    currentFormatter.data = d;
    self.string = currentFormatter.formattedString;
}

- (NSData*)formatDataBasedOnDisplay:(NSData*)d
{
    return ([currentFormatter formatDataBasedOnDisplay:d]);
}

- (NSArray*)displaySizeStrings
{
    return (currentFormatter.displaySizeStrings);
}

- (void)setCurrentDisplaySize:(formatterDisplaySize)s
{
    currentFormatter.currentDisplaySize = s;
    self.string = currentFormatter.formattedString;
    
    self.currentAddressesSelected = currentAddressesSelected;
}

- (formatterDisplaySize)currentDisplaySize
{
    return (currentFormatter.currentDisplaySize);
}

//NSTextViewDelegate

//End NSTextViewDelegate

- (BOOL)acceptsFirstResponder
{
    return (YES);
}

- (BOOL)becomeFirstResponder
{
    return (YES);
}

//Mouse Stuff

- (void)mouseEntered:(NSEvent*)event
{
    NSLog (@"Mouse entered!");
    mouseEntered = YES;
}

- (void)mouseDown:(NSEvent*)event
{
    selectionStartOffset = -1;
    self.currentAddressesSelected = nil;
}

- (void)mouseDragged:(NSEvent*)event
{
    NSLayoutManager *layoutManager = [self layoutManager];
    NSTextContainer *textContainer = [self textContainer];
    NSUInteger glyphIndex, charIndex;
    NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    NSRect glyphRect;
        
    point.x -= [self textContainerOrigin].x;
    point.y -= [self textContainerOrigin].y;
    
    glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    
    glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:textContainer];
    if (NSPointInRect(point, glyphRect)) 
    {
        charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
     
        if (selectionStartOffset == -1)
        {
            currentSelectionMode = [currentFormatter selectionModeForCharacterIndex:charIndex];
            if (currentSelectionMode != FORMATTER_SELECTION_MODE_NULL)
                selectionStartOffset = charIndex;
        }
        else
        {
            if ([currentFormatter isSelectableCharacterIndex:charIndex])
            {
                NSInteger currentOffset = charIndex;
                             
                NSInteger startAddress = [currentFormatter getAbsoluteAddressForFormattedOffset:selectionStartOffset
                                                                                     searchMode:FORMATTER_SEARCH_MODE_BINARY
                                                                                    roundToByte:YES];
                
                NSInteger address = [currentFormatter getAbsoluteAddressForFormattedOffset:currentOffset
                                                                                searchMode:FORMATTER_SEARCH_MODE_BINARY
                                                                               roundToByte:NO];
                
                if (address == -1)
                {
                    if (currentOffset < selectionStartOffset)
                        address = [currentFormatter getAbsoluteAddressForFormattedOffset:currentOffset + 1
                                                                              searchMode:FORMATTER_SEARCH_MODE_BINARY
                                                                             roundToByte:NO];
                    else if (currentOffset > selectionStartOffset)
                        address = [currentFormatter getAbsoluteAddressForFormattedOffset:currentOffset - 1
                                                                              searchMode:FORMATTER_SEARCH_MODE_BINARY
                                                                             roundToByte:NO]; 
                }
                
                if (address != -1)
                {
                    NSRange r;
                    r.location = (address < startAddress) ? address : startAddress;
                    
                    r.length = abs (address - startAddress) + 1;
                                        
                    self.currentAddressesSelected = [NSArray arrayWithObject:[NSValue valueWithRange:r]];
                }
            }
        }
    }
}

- (void)mouseUp:(NSEvent*)event
{
    selectionStartOffset = -1;
}

- (void)mouseExited:(NSEvent*)event
{
    mouseEntered = NO;
}

//End Mouse Stuff

- (void)dealloc
{
    self.currentAddressesSelected = nil;
    
    [currentFormatter release];
    [super dealloc];
}

@end
