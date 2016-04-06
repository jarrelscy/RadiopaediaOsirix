//
//  RadiopaediaFilter.m
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import "RadiopaediaFilter.h"
#import "GTMOAuth2WindowController.h"
@implementation RadiopaediaFilter

- (void) initPlugin
{
}
- (void)viewController:(GTMOAuth2WindowController *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hello World!"
                                           defaultButton:@"Hello"
                                         alternateButton:nil
                                             otherButton:nil
                               informativeTextWithFormat:@"Failed %ld", (long)[error code]];
        
        [myAlert runModal];
    } else {
        NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hello World!"
                                           defaultButton:@"Hello"
                                         alternateButton:nil
                                             otherButton:nil
                               informativeTextWithFormat:@"%Success"];
        
        [myAlert runModal];
    }
}
- (long) filterImage:(NSString*) menuName
{
   /* NSString* message = [[NSUserDefaults standardUserDefaults] stringForKey:@"HelloWorld_Message"];
    if (!message) message = @"Define this message in the Hello World plugin's preferences";
    
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hello World!"
                                       defaultButton:@"Hello"
                                     alternateButton:nil
                                         otherButton:nil
                           informativeTextWithFormat:@"%@", message];
    
    [myAlert runModal];*/

    
    
    NSURL *tokenURL = [NSURL URLWithString:@"http://sandbox.radiopaedia.org/oauth/token"];
    
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page.
    NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    
    GTMOAuth2Authentication *auth;
    @try {
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Radiopaedia"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:@"9c2d8456fb2798a7bf0406fa4c6a516f57d74b1b0abd13889e4bf831ba5a2735"
                                                         clientSecret:@"4ace663418bbe8e4557d0df18452eca90cd768204f1a950984fcae359dc555b0"];
        auth.scope = @"cases";
        NSURL *authURL = [NSURL URLWithString:@"http://sandbox.radiopaedia.org/oauth/authorize"];
        
        GTMOAuth2WindowController *windowController;
        windowController = [GTMOAuth2WindowController controllerWithAuthentication:auth
                                                                  authorizationURL:authURL
                                                                  keychainItemName:@"Radiopaedia Osirix"
                                                                    resourceBundle:nil];
        
        NSString *html = @"<html><body><div align=center>Loading sign-in page...</div></body></html>";
        [windowController setInitialHTMLString:html];
        [windowController signInSheetModalForWindow:[NSApp keyWindow]
                                           delegate:self
                                   finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    }
    
    @catch (NSException *exception)
    {
        NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hello World!"
                                           defaultButton:@"Hello"
                                         alternateButton:nil
                                             otherButton:nil
                               informativeTextWithFormat:@"%@", exception];
        
        [myAlert runModal];
    }
    
    return 0;

}

@end
