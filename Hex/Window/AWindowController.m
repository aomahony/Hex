//
//  AWindowController.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/6/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "AWindowController.h"

@interface AWindowController ()

@property (assign) NSString* currentFilename;

@end

@implementation AWindowController

@synthesize byteSearchField, textSearchField, gotoAddressField;
@synthesize byteSearchFieldLabel, textSearchFieldLabel, gotoAddressFieldLabel;
@synthesize hexScrollView;

@synthesize displaySizePopupButton;
@synthesize displaySizeLabel;

- (NSString*)currentFilename
{
    return (currentFile.filename);
}

- (void)setCurrentFilename:(NSString*)f
{
    currentFile.filename = f;
    currentFormatter.data = currentFile.data;
    
    hexDumpView.string = currentFormatter.formattedString;
}

- (IBAction)openDocument:(id)sender
{
    NSOpenPanel* panel = [[NSOpenPanel openPanel] retain];
    
    panel.canChooseDirectories = NO;
    panel.canChooseFiles = YES;
    panel.allowsMultipleSelection = NO;
    
    void (^panelComplete)(NSInteger) = ^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            self.currentFilename = [[panel.URLs objectAtIndex:0] path];
        }
        [panel release];
    };
    
    [panel beginWithCompletionHandler:panelComplete];
}

- (IBAction)displaySizeSelected:(id)sender
{
    currentFormatter.currentDisplaySize = (formatterDisplaySize)[(NSPopUpButton*)sender indexOfSelectedItem] + 1;
    hexDumpView.string = currentFormatter.formattedString;
}

- (void)awakeFromNib
{
    hexDumpView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0,
                                   hexScrollView.frame.size.width,hexScrollView.frame.size.height)];
    [hexDumpView setMinSize:NSMakeSize(0.0, hexScrollView.frame.size.height)];
    [hexDumpView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [hexDumpView setVerticallyResizable:YES];
    [hexDumpView setHorizontallyResizable:NO];
    [hexDumpView setAutoresizingMask:NSViewWidthSizable];
    
    hexDumpView.editable = false;
    
    hexDumpView.font = [NSFont fontWithName:@"Courier New"
                                       size:11.0];
    
    [hexDumpView setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor yellowColor], 
                                            NSBackgroundColorAttributeName, nil]];
    
    //theTextView.selectable = false;
    
    //[theTextView setSelectedRanges:[NSArray arrayWithObjects:[NSValue valueWithRange:NSMakeRange(0, 10)],
      //                              [NSValue valueWithRange:NSMakeRange (15, 4)], nil]];
    
    [[hexDumpView textContainer]
     setContainerSize:NSMakeSize(hexScrollView.frame.size.width, FLT_MAX)];
    [[hexDumpView textContainer] setWidthTracksTextView:YES];
    
    [hexScrollView setDocumentView:hexDumpView];
    
    /*NSString* extractedString = nil;
    [@"You owe: 1234.56 (tip not included)" getCapturesWithRegexAndReferences:@"(\\d+\\.\\d+)",
     @"$1", &extractedString,
     nil];
    
    NSLog (@"%@", extractedString);*/
    
    currentFile = [AFile new];
    currentFormatter = [AFormatter new];
    
    [displaySizePopupButton addItemsWithTitles:currentFormatter.displaySizeStrings];
    [displaySizePopupButton selectItemAtIndex:currentFormatter.currentDisplaySize - 1];
}

- (void)dealloc
{
    self.byteSearchField = 
    self.textSearchField = 
    self.gotoAddressField =
    self.byteSearchFieldLabel = 
    self.textSearchFieldLabel = 
    self.displaySizeLabel = nil;
    
    self.gotoAddressFieldLabel = nil;
    self.hexScrollView = nil;
    
    self.displaySizePopupButton = nil;
    
    [hexDumpView release];
    
    [currentFile release];
    [currentFormatter release];
    
    [super dealloc];
}

@end
