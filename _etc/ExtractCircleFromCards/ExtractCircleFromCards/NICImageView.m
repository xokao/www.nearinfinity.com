//
//  NICImageView.m
//  ExtractCircleFromCards
//
//  Created by Jason Harwig on 5/1/12.
//  Copyright (c) 2012 Near Infinity Corporation. All rights reserved.
//

#import "NICImageView.h"

@implementation NICImageView
@synthesize previewView, cards=_cards;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.cards = [[NSMutableArray alloc] init];
        [self setEditable:YES];
        magnification = 1.0;
    }
    return self;
}

- (void)awakeFromNib {
    [self setAcceptsTouchEvents:YES];
    [self.window makeFirstResponder:self];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (IBAction)next:(id)sender {
    [self loadImage:++currentIndex];
}
- (IBAction)previous:(id)sender {
    [self loadImage:--currentIndex];
}

- (void)magnifyWithEvent:(NSEvent *)event {
    magnification += [event magnification];
    NSLog(@"mag = %f", [event magnification]);
    [self drawit];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    startPoint = [self convertPoint:event_location fromView:nil];
    [self drawit];
}
- (void)drawit {
    NSPoint local_point = startPoint;
    
    NSSize size = NSMakeSize(128,128);
    NSPoint start = NSMakePoint(local_point.x - size.width / 2, local_point.y - (self.bounds.size.height - self.image.size.height) - size.height / 2);
    NSRect rect = (NSRect){start, size};
    NSRect targetRect = (NSRect){NSZeroPoint, size};
    
    NSImage *target = [[NSImage alloc]initWithSize:size];    
    [target lockFocus];
    
    NSShadow * shadow = [NSShadow new];
    [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.3]];
    [shadow setShadowBlurRadius: 6.0f];
    [shadow setShadowOffset: NSMakeSize(0, 0)];
    [shadow set];
    [[NSColor whiteColor] setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSInsetRect(targetRect, 5, 5)] fill];
    
    [[NSBezierPath bezierPathWithOvalInRect:NSInsetRect(targetRect, 10, 10)] addClip];
    
    float m = 10*magnification;
    [self.image drawInRect:targetRect
                  fromRect:CGRectInset(rect, m, m)
                 operation:NSCompositeCopy fraction:1.0];    
    [target unlockFocus];
    previewView.image = target;
}

- (IBAction)writeImage:(id)sender {
    NSImage *target = previewView.image;
    [target lockFocus];    
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, target.size.width, target.size.height)];    
    [target unlockFocus];
    
    NSData *data = [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
    [data writeToFile:[[NSString stringWithFormat:@"~/Desktop/%@", [[_cards objectAtIndex:currentIndex] lastPathComponent]] stringByExpandingTildeInPath] atomically: NO];
    
    [self loadImage:++currentIndex];  
}

- (void)loadImage:(NSInteger)index {
    if (index < 0) {
        index = 0;
        currentIndex = 0;
    }
    if (index < [_cards count]) {
        self.image = [[NSImage alloc] initWithContentsOfFile:[_cards objectAtIndex:index]];
    } else currentIndex = [_cards count] - 1;
}


#pragma mark - Drop Support

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    if (context == NSDraggingContextOutsideApplication)
        return NSDragOperationAll;
    
    return NSDragOperationNone;
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
    if (sender.draggingSource != nil)
        return NSDragOperationNone;
    
    NSPasteboard *pb = [sender draggingPasteboard];
    if ([[pb types] containsObject:NSURLPboardType]) {
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender {
    return [sender draggingSource] == nil ? NSDragOperationCopy : NSDragOperationNone;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSPasteboard *pb = [sender draggingPasteboard];
    
    if ([[pb types] containsObject:NSFilenamesPboardType]) {
        NSArray *pl = [pb propertyListForType:NSFilenamesPboardType];
        if ([pl count] > 0) {
            NSLog(@"%@", [[pl objectAtIndex:0] class]);
            self.cards = [NSMutableArray arrayWithArray:pl];
            currentIndex = 0;
            [self loadImage:currentIndex];
            return YES;
        }
    }
    
    return NO;
}


@end
