//
//  ProgressWindowController.h
//  Radiopaedia
//
//  Created by Jarrel Seah on 17/04/2016.
//
//

#ifndef ProgressWindowController_h
#define ProgressWindowController_h


#endif /* ProgressWindowController_h */

#import <Cocoa/Cocoa.h>
@interface ProgressWindowController : NSWindowController
{
    
}
@property (strong) IBOutlet NSTextField *seriesLabel;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@end