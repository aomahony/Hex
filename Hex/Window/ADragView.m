//
//  ADragView.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/11/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "ADragView.h"

@implementation ADragView
@synthesize dropDelegate;

- (void)setDropTypes:(NSArray*)dropTypes
    withDropDelegate:(id)dd
{
    dropDelegate = dd;
    [self registerForDraggedTypes:dropTypes];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender 
{
    NSPasteboard* pasteBoard = [sender draggingPasteboard];
        
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType])
    {
        NSArray* paths = [pasteBoard propertyListForType:NSFilenamesPboardType];
        
        if (![paths count])
            return (NSDragOperationNone);
        
        NSError* error = nil;
        NSString* fileType = [[NSWorkspace sharedWorkspace] typeOfFile:[paths objectAtIndex:0]
                                                                 error:&error];
    
        if ([[NSWorkspace sharedWorkspace] type:fileType conformsToType:(id)kUTTypeFolder])        
            return (NSDragOperationNone);
    }
    
    return (NSDragOperationEvery);
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender 
{
    NSPasteboard* pasteBoard = [sender draggingPasteboard];
    
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType])
    {
        NSArray* paths = [pasteBoard propertyListForType:NSFilenamesPboardType];
        
        if (![paths count])
            return (NSDragOperationNone);
        
        [dropDelegate performSelector:@selector (fileDragDropped:)
                           withObject:[paths objectAtIndex:0]];
    }
    
    return YES;
}

@end
