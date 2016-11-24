//
//  EnterDetailsWindowController.h
//  Radiopaedia
//
//  Created by Jarrel Seah on 10/04/2016.
//
//

#ifndef EnterDetailsWindowController_h
#define EnterDetailsWindowController_h


#endif /* EnterDetailsWindowController_h */


#import <Cocoa/Cocoa.h>
#import "GTMOAuth2WindowController.h"
#import "GTMOAuth2SignIn.h"
@interface EnterDetailsWindowController : NSWindowController
{

}
@property (strong) NSArray *titles;
@property (strong) NSArray *indexOfSelected;
-(long) getSelectedIndex;
- (void)windowDidLoad;
-(void) awakeFromNib;
@property (strong) id parent;
@property (strong) IBOutlet NSButton *logoutButton;
@property (strong) IBOutlet NSButton *okButton;
@property (strong) IBOutlet NSSlider *compressionSlider;
@property (strong) IBOutlet NSTextField *compressionValueField;
@property (strong) IBOutlet NSTextField *caserIDField;
@property (strong) IBOutlet NSTextField *caseTitleField;
@property (strong) IBOutlet NSPopUpButton *systemSelect;
@property (strong) IBOutlet NSTextField *ageField;
@property (strong) IBOutlet NSPopUpButton *genderSelect;
@property (strong) IBOutlet NSTextField *presentationField;
@property (strong) IBOutlet NSTextField *discussionField;
- (void)setupSheetTerminationHandling ;
@end
