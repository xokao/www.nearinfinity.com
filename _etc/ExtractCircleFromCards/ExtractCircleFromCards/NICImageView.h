//
//  NICImageView.h
//  ExtractCircleFromCards
//
//  Created by Jason Harwig on 5/1/12.
//  Copyright (c) 2012 Near Infinity Corporation. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NICImageView : NSImageView
{
    NSInteger currentIndex;
    NSPoint startPoint;
    float magnification;
}
@property (strong) NSMutableArray *cards;
@property (weak) IBOutlet NSImageView *previewView;

- (IBAction)writeImage:(id)sender;


- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@end
