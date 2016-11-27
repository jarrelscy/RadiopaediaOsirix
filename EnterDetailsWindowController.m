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
-(bool) checkTextField:(NSTextField *)field
{
    
    return (([field stringValue] != nil) && ([[field stringValue] length] > 0));
}
-(bool) checkTextFieldContainsNumeric:(NSTextField *)field
{
    NSString *s = [field stringValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    return !([numberFormatter numberFromString:s] == nil);
    
}
-(void) updateOKButton
{
    if ([self checkTextField:self.caserIDField] || ([self checkTextField:self.caseTitleField] && ![self checkTextFieldContainsNumeric:self.caseTitleField]))
    {
        [self.okButton setEnabled:true];
    }
    else
        [self.okButton setEnabled:false];
}
- (void)controlTextDidChange:(NSNotification *)notification {
    [self updateOKButton];
}

- (IBAction)OkButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (IBAction)CancelButtonClicked:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}
- (IBAction)LogoutButtonClicked:(id)sender {
    [GTMOAuth2WindowController removeAuthFromKeychainForName:KEYCHAIN_ITEM];
    NSAlert *myAlert = [[NSAlert alloc] init];
    [myAlert setMessageText:@"You have been logged out"];
    RadiopaediaFilter *p = (RadiopaediaFilter *)self.parent;
    p.isSignedIn = false;
    [self.logoutButton setEnabled:false];
    [myAlert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:NO];
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}
-(long) getSelectedIndex
{
   
    int s = (int )[self.systemSelect indexOfSelectedItem];
    long ret = (long)[(NSNumber *)[self.indexOfSelected objectAtIndex:s] intValue];
    return ret;
}
- (void)windowDidLoad
{
    [self.supportLabel setAllowsEditingTextAttributes: YES];
    [self.supportLabel setSelectable: YES];

    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"Become a Radiopaedia Supporter!"];
    [str addAttribute: NSLinkAttributeName value: @"https://radiopaedia.org/supporters" range: NSMakeRange(0, str.length)];
    [self.supportLabel setAttributedStringValue:str];
    
    RadiopaediaFilter *p = (RadiopaediaFilter *)self.parent;
    if ([p isSignedIn])
    {
        [self.logoutButton setEnabled:true];
    }
    self.caseTitleField.delegate = self;
    self.caserIDField.delegate = self;
    self.indexOfSelected = @[@1,@2,@3,@4,@6,@7,@8,@9,@11,@12,@14,@15,@16,@17,@18,@19,@21,@22,@23];
    self.titles =  @[@"",
                                      @"Breast",
                                      @"Vascular",
                                      @"Central Nervous System",
                                      @"Chest",
                                      @"",
                                      @"Gastrointestinal",
                                      @"Head and Neck",
                                      @"Hepatobiliary",
                                      @"Musculoskeletal",
                                      @"",
                                      @"Urogenital",
                                      @"Paediatrics",
                                      @"",
                                      @"Spine",
                                      @"Cardiac",
                                      @"Interventional",
                                      @"Obstetrics",
                                      @"Gynaecology",
                                      @"Haematology",
                                      @"",
                                      @"Forensic",
                                      @"Oncology",
                                      @"Trauma"];
    
    self.titles =  @[@"Breast",
                     @"Vascular",
                     @"Central Nervous System",
                     @"Chest",
                     @"Gastrointestinal",
                     @"Head and Neck",
                     @"Hepatobiliary",
                     @"Musculoskeletal",
                     @"Urogenital",
                     @"Paediatrics",
                     @"Spine",
                     @"Cardiac",
                     @"Interventional",
                     @"Obstetrics",
                     @"Gynaecology",
                     @"Haematology",
                     @"Forensic",
                     @"Oncology",
                     @"Trauma"];

    
    [super windowDidLoad];
    
    for (NSString *title in self.titles)
    {
        [self.systemSelect addItemWithTitle:title];
    }
    [self.window makeFirstResponder:self.caseTitleField];
    [self.ageField setStringValue:((RadiopaediaFilter *)self.parent).patientAge];
    [self.genderSelect selectItemWithTitle:((RadiopaediaFilter *)self.parent).patientSex];
}
- (IBAction)sliderValueChanged:(id)sender {
    [self.compressionValueField setStringValue:[NSString stringWithFormat:@"%f", [self.compressionSlider floatValue]]];
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
- (IBAction)openTipsAndTricks:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://radiopaedia.org/blog/radiopaedia-case-uploader-plugin-for-horos-osirix"]];
}
@end
