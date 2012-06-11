//
//  ADragView.m
//  Hex
//
//  Created by Andrew O'Mahony on 6/11/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import "ADragView.h"

@implementation ADragView

- (void)setDropTypes:(NSArray*)dropTypes
    withDropSelector:(SEL)ds
{
    dropSelector = ds;
}

@end
