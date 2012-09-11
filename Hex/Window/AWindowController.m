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
@property (readonly) BOOL searchByDisplayOrder;

@end

@implementation AWindowController

@synthesize byteSearchField, textSearchField, gotoAddressField;
@synthesize byteSearchFieldLabel, textSearchFieldLabel, gotoAddressFieldLabel;
@synthesize searchByteTypePopupButton;
@synthesize hexScrollView;
@synthesize dragView;

@synthesize searchResultsLabel;
@synthesize searchResultsPopupButton;

@synthesize displaySizePopupButton;

static NSInteger kSearchAddressFieldTag = 1;
static NSInteger kSearchByteFieldTag = 2;
static NSInteger kSearchTextFieldTag = 3;

static NSInteger searchByteTypeRaw = 0;
static NSInteger searchByteTypeDisplay = 1;

- (BOOL)searchByDisplayOrder
{
    return ([searchByteTypePopupButton indexOfSelectedItem] == searchByteTypeDisplay);
}

- (NSString*)currentFilename
{
    return (currentFile.filename);
}

- (void)setCurrentFilename:(NSString*)f
{
    currentFile.filename = f;
    currentSearcher.data = currentFile.data;
    
    hexDumpView.data = currentFile.data;
    
    [hexDumpView becomeFirstResponder];
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
    hexDumpView.currentDisplaySize = (formatterDisplaySize)[(NSPopUpButton*)sender indexOfSelectedItem] + 1;
}

- (void)selectSearchResult:(NSInteger)index
              fromSelector:(BOOL)isFromSelector
{
    if (!isFromSelector)
        [searchResultsPopupButton selectItemAtIndex:index];
    else
        [hexDumpView selectSelectedAddressIndex:index];
}

- (IBAction)searchResultSelected:(id)sender
{
    [self selectSearchResult:[(NSPopUpButton*)sender indexOfSelectedItem]
                fromSelector:YES];
}

- (void)fillSearchResults:(NSInteger)tag
{
    [searchResultsPopupButton removeAllItems];
    
    if (tag == kSearchByteFieldTag)
    {
        searchResultsLabel.stringValue = [NSString stringWithFormat:@"Byte Search Results (%lu)", hexDumpView.currentAddressesSelected.count];
    }
    else if (tag == kSearchTextFieldTag)
    {
        searchResultsLabel.stringValue = [NSString stringWithFormat:@"Text Search Results (%lu)", hexDumpView.currentAddressesSelected.count];
    }
    [searchResultsLabel sizeToFit];
    
    [searchResultsPopupButton setFrame:CGRectMake (searchResultsLabel.frame.origin.x +
                                                   searchResultsLabel.frame.size.width + 8,
                                                   searchResultsPopupButton.frame.origin.y,
                                                   searchResultsPopupButton.frame.size.width,
                                                   searchResultsPopupButton.frame.size.height)];
    
    NSMutableArray* titleStrings = [NSMutableArray array];
    for (NSValue* addr in hexDumpView.currentAddressesSelected)
    {
        [titleStrings addObject:[NSString stringWithFormat:@"0x%.8X", addr.rangeValue.location]];
    }

    [searchResultsPopupButton addItemsWithTitles:titleStrings];
}

//NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification*)notification
{
    hexDumpView.currentAddressesSelected = nil;
    
    NSTextField* object = [notification object];
    
    if (object.tag == kSearchAddressFieldTag)
    {
        NSInteger address = [currentSearcher extractAddressFromSearchString:object.stringValue];
        
        if (address >= 0)
            [hexDumpView gotoAddress:address];
    }
    else if (object.tag == kSearchByteFieldTag)
    {
        NSData* searchData = [ASearcher dataFromHexString:object.stringValue];

        hexDumpView.currentAddressesSelected = [currentSearcher searchDataForData:(self.searchByDisplayOrder ? [hexDumpView formatDataBasedOnDisplay:searchData] : searchData)];
        
        [self fillSearchResults:object.tag];
    }
    else if (object.tag == kSearchTextFieldTag)
    {
        hexDumpView.currentAddressesSelected = [currentSearcher searchDataForData:[ASearcher dataFromTextString:object.stringValue]];
        
        [self fillSearchResults:object.tag];
    }    
}


//End NSTextFieldDelegate

- (void)fileDragDropped:(NSString*)path
{
    self.currentFilename = path;
}

- (void)awakeFromNib
{
    hexDumpView = [[AHexView alloc] initWithFrame:NSMakeRect(0, 0,
                                    hexScrollView.frame.size.width,hexScrollView.frame.size.height)];
    [hexDumpView setMinSize:NSMakeSize(0.0, hexScrollView.frame.size.height)];
    [hexDumpView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [hexDumpView setVerticallyResizable:YES];
    [hexDumpView setHorizontallyResizable:NO];
    [hexDumpView setAutoresizingMask:NSViewWidthSizable];
    
    hexDumpView.editable = false;
    
    hexDumpView.font = [NSFont fontWithName:@"Courier New"
                                       size:11.0];
    
    [hexDumpView setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor yellowColor],NSBackgroundColorAttributeName, nil]];
    
    hexDumpView.selectable = false;
    
    [[hexDumpView textContainer]
     setContainerSize:NSMakeSize(hexScrollView.frame.size.width, FLT_MAX)];
    [[hexDumpView textContainer] setWidthTracksTextView:YES];
    
    [hexScrollView setDocumentView:hexDumpView];
    
    currentFile = [AFile new];
    currentSearcher = [ASearcher new];
    
    [displaySizePopupButton addItemsWithTitles:hexDumpView.displaySizeStrings];
    [displaySizePopupButton selectItemAtIndex:hexDumpView.currentDisplaySize - 1];
        
    [searchByteTypePopupButton addItemsWithTitles:[NSArray arrayWithObjects:@"Raw", @"Display", nil]];
    [searchByteTypePopupButton selectItemAtIndex:searchByteTypeDisplay];

    [dragView setDropTypes:[NSArray arrayWithObject:NSFilenamesPboardType]
          withDropDelegate:self];
    
    [hexDumpView becomeFirstResponder];
}

- (void)dealloc
{
    self.byteSearchField = 
    self.textSearchField = 
    self.gotoAddressField =
    self.byteSearchFieldLabel = 
    self.textSearchFieldLabel = 
    self.searchResultsLabel = nil;
    
    self.searchResultsPopupButton = nil;
    
    self.searchByteTypePopupButton = nil;
    
    self.gotoAddressFieldLabel = nil;
    self.hexScrollView = nil;
    self.dragView = nil;
    
    self.displaySizePopupButton = nil;
    
    [hexDumpView release];
    
    [currentFile release];
    [currentSearcher release];
    
    [super dealloc];
}

@end
