//
//  EnterDetailsWindowController.m
//  Radiopaedia
//
//  Created by Jarrel Seah on 10/04/2016.
//
//



#import "FinishedWindowController.h"

#import "RadiopaediaFilter.h"
@implementation FinishedWindowController
- (IBAction)OkButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (void)windowDidLoad
{
    if (((RadiopaediaFilter *)(self.parent)).caseId != nil)
   {
    
     [self.ridLabel setStringValue:((RadiopaediaFilter *)(self.parent)).caseId];
    NSString *s = [NSString stringWithFormat:@"https://radiopaedia.org/cases/%@", ((RadiopaediaFilter *)(self.parent)).caseId];
    
    [self.hyperlinkLabel setAutomaticLinkDetectionEnabled:TRUE];
    
    [self.hyperlinkLabel setString:s];
    [self.hyperlinkLabel checkTextInDocument:nil];
   }
}
@end
