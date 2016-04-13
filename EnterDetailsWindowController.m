//
//  EnterDetailsWindowController.m
//  Radiopaedia
//
//  Created by Jarrel Seah on 10/04/2016.
//
//



#import "EnterDetailsWindowController.h"

@implementation EnterDetailsWindowController

-(void) awakeFromNib
{
    [super awakeFromNib];
    
    
}
- (IBAction)OkButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (void)windowDidLoad
{
    [super windowDidLoad];
        
}
- (void)setupSheetTerminationHandling {
    NSWindow *sheet = [self window];
    
    SEL sel = @selector(setPreventsApplicationTerminationWhenModal:);
    if ([sheet respondsToSelector:sel]) {
        // setPreventsApplicationTerminationWhenModal is available in NSWindow
        // on 10.6 and later
        BOOL boolVal = NO;
        NSMethodSignature *sig = [sheet methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:sel];
        [invocation setTarget:sheet];
        [invocation setArgument:&boolVal atIndex:2];
        [invocation invoke];
    }
}
@end