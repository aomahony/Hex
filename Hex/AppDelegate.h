//
//  AppDelegate.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/6/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow* window;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@end
