//
//  AWindowController.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/6/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AController.h"
#import "AFile.h"
#import "AFormatter.h"
#import "ADragView.h"

@interface AWindowController : AController
{
    IBOutlet NSTextField* byteSearchField;
    IBOutlet NSTextField* textSearchField;
    IBOutlet NSTextField* gotoAddressField;
    
    IBOutlet NSTextField* byteSearchFieldLabel;
    IBOutlet NSTextField* textSearchFieldLabel;
    IBOutlet NSTextField* gotoAddressFieldLabel;
    
    IBOutlet NSPopUpButton* displaySizePopupButton;
    IBOutlet NSTextField* displaySizeLabel;
    
    IBOutlet ADragView* dragView;
    
    IBOutlet NSScrollView* hexScrollView;
    
    NSTextView* hexDumpView;
    
    AFile* currentFile;
    AFormatter* currentFormatter;
}

@property (nonatomic, retain) IBOutlet NSTextField* byteSearchField;
@property (nonatomic, retain) IBOutlet NSTextField* textSearchField;
@property (nonatomic, retain) IBOutlet NSTextField* gotoAddressField;

@property (nonatomic, retain) IBOutlet NSTextField* byteSearchFieldLabel;
@property (nonatomic, retain) IBOutlet NSTextField* textSearchFieldLabel;
@property (nonatomic, retain) IBOutlet NSTextField* gotoAddressFieldLabel;

@property (nonatomic, retain) IBOutlet NSScrollView* hexScrollView;
@property (nonatomic, retain) IBOutlet ADragView* dragView;

@property (nonatomic, retain) IBOutlet NSPopUpButton* displaySizePopupButton;
@property (nonatomic, retain) IBOutlet NSTextField* displaySizeLabel;

@end
