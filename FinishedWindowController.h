//
//  ProgressWindowController.h
//  Radiopaedia
//
//  Created by Jarrel Seah on 17/04/2016.
//
//


#import <Cocoa/Cocoa.h>
@interface FinishedWindowController : NSWindowController
{
    
}
- (void)windowDidLoad;
@property (strong) id parent;
@property (strong) IBOutlet NSTextField *ridLabel;
@property (strong) IBOutlet NSTextView *hyperlinkLabel;
@end