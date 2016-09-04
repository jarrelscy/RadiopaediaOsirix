//
//  EnterDetailsWindowController.m
//  Radiopaedia
//
//  Created by Jarrel Seah on 10/04/2016.
//
//



#import "EnterDetailsWindowController.h"
#import "RadiopaediaFilter.h"
@implementation EnterDetailsWindowController

-(void) awakeFromNib
{
    [super awakeFromNib];
    
    
}
- (IBAction)OkButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (IBAction)CancelButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}
- (IBAction)LogoutButtonClicked:(id)sender {
    [GTMOAuth2WindowController removeAuthFromKeychainForName:@"Radiopaedia Osirix"];
    NSAlert *myAlert = [[NSAlert alloc] init];
    [myAlert setMessageText:@"You have been logged out"];
    [myAlert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:NO];
}
- (void)windowDidLoad
{
 
    
    
    [super windowDidLoad];
    NSArray *titles = @[@"Empty1",
                        @"Breast",
                        @"Vascular",
                        @"Central Nervous System",
                        @"Chest",
                        @"Empty2",
                        @"Gastrointestinal",
                        @"Head and Neck",
                        @"Hepatobiliary",
                        @"Musculoskeletal",
                        @"Empty3",
                        @"Urogenital",
                        @"Paediatrics",
                        @"Empty4",
                        @"Spine",
                        @"Cardiac",
                        @"Interventional",
                        @"Obstetrics",
                        @"Gynaecology",
                        @"Haematology",
                        @"Empty5",
                        @"Forensic",
                        @"Oncology",
                        @"Trauma"];
    for (NSString *title in titles)
    {
        [self.systemSelect addItemWithTitle:title];
    }
    [self.window makeFirstResponder:self.caseTitleField];
    [self.ageField setStringValue:((RadiopaediaFilter *)self.parent).patientAge];
    [self.genderSelect selectItemWithTitle:((RadiopaediaFilter *)self.parent).patientSex];
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