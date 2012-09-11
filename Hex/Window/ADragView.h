//
//  ADragView.h
//  Hex
//
//  Created by Andrew O'Mahony on 6/11/12.
//  Copyright (c) 2012 Myself. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AView.h"

@interface ADragView : AView
{
    id dropDelegate;
}

@property (nonatomic, assign) id dropDelegate;

- (void)setDropTypes:(NSArray*)dropTypes
    withDropDelegate:(id)dd;

@end
