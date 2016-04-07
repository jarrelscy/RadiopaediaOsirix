//
//  RadiopaediaFilter.m
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import "RadiopaediaFilter.h"
#import "GTMOAuth2WindowController.h"
#import <OsiriXAPI/DicomStudy.h>
#import <OsiriXAPI/DicomSeries.h>
#import <OsiriXAPI/DicomImage.h>
#import <OsiriXAPI/browserController.h>
#import "GTMOAuth2SignIn.h"
#import "Objective-Zip.h"
@implementation RadiopaediaFilter

- (void) initPlugin
{
}

-(void) alert:(NSArray *)info
{
    
    NSAlert *myAlert = [NSAlert alertWithMessageText:[info objectAtIndex:0]
                                       defaultButton:[info objectAtIndex:1]
                                     alternateButton:[info objectAtIndex:2]
                                         otherButton:[info objectAtIndex:3]
                           informativeTextWithFormat:[info objectAtIndex:4]];
    [myAlert runModal];
}
- (void)viewController:(GTMOAuth2WindowController *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        
    } else {
        
        
        // TODO ASK THE USER WHAT THE TITLE AND SYSTEM ID IS
        
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Jarrel Plugin Test", @"title",
                                           @"1", @"system_id",
                                           nil];
        NSString *paramStr = [GTMOAuth2Authentication encodedQueryParametersForDictionary:paramsDict];
        NSMutableURLRequest *request  = [GTMOAuth2SignIn mutableURLRequestWithURL:[NSURL URLWithString:@"http://sandbox.radiopaedia.org/api/v1/cases"]
                                      paramString:paramStr];
        request.HTTPMethod = @"POST";
        
        
        [auth authorizeRequest:request completionHandler:^(NSError *err)
         {
             
             if (err == nil) {
                 // the request has been authorized
                 
                 NSError *requestError = nil;
                 NSURLResponse *urlResponse = nil;
                 NSData *response1 =
                 [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:&urlResponse error:&requestError];
                 NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options: NSJSONReadingMutableContainers error: &requestError];
                 
                 NSString *caseId = [jsonArray objectForKey:@"id"];
                 NSMutableArray *seriesNames = [NSMutableArray array];
                 for (DicomSeries *series in self.selectedSeries) {
                     [self processSeries:series with:caseId using:auth];
                     [seriesNames addObject:[series name]];
                 }
                 
             }
             
             else{
                 // Failed to authorize for some reason
                 NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hello World!"
                                                    defaultButton:@"Hello"
                                                  alternateButton:nil
                                                      otherButton:nil
                                        informativeTextWithFormat:@"Failed %ld", (long)[error code]];
                 
                 [myAlert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:NO];
             }

             
         }];
        
    }
}


- (void) processSeries:(DicomSeries*) series with:(NSString *)caseId using:(GTMOAuth2Authentication *)auth {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [series modality], @"modality",
                                       [series name], @"caption",
                                       nil];
    NSString *paramStr = [GTMOAuth2Authentication encodedQueryParametersForDictionary:paramsDict];
    NSString *urlString = [NSString stringWithFormat:@"http://sandbox.radiopaedia.org/api/v1/cases/%@/studies", caseId];
    NSMutableURLRequest *request  = [GTMOAuth2SignIn mutableURLRequestWithURL:[NSURL URLWithString:urlString]
                                                                  paramString:paramStr];
    request.HTTPMethod = @"POST";
    [auth authorizeRequest:request completionHandler:^(NSError *err)
     {
         
         if (err == nil) {
             // the request has been authorized
             
             NSError *requestError = nil;
             NSURLResponse *urlResponse = nil;
             NSData *response1 =
             [NSURLConnection sendSynchronousRequest:request
                                   returningResponse:&urlResponse error:&requestError];
             NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options: NSJSONReadingMutableContainers error: &requestError];
             
             NSString *studyId = [jsonArray objectForKey:@"id"];
             
             
             // Post images
             
             
             
         }
         
         else{
             // Failed to authorize for some reason
             NSAlert *myAlert = [NSAlert alertWithMessageText:@"Error uploading series!"
                                                defaultButton:@"Ok"
                                              alternateButton:nil
                                                  otherButton:nil
                                    informativeTextWithFormat:@"Failed to upload %@: %@",[series name], [err description]];
             
             [myAlert runModal];
         }
         
         
     }];

    
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

    /*
     
     Many thanks to wonderful blog at http://myfirstosirixplugin.blogspot.com.au/   !!!!
     
     */
    
    BrowserController *currentBrowser = [BrowserController currentBrowser];
    NSArray *selectedItems = [currentBrowser databaseSelection];
    
    if ([selectedItems count] == 0) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:@"No studies/series selected!"];
        [alert runModal];
        
        return 1;
    }    
    self.selectedSeries = [NSMutableArray array];
    self.zipFiles = [NSMutableArray array];
    for (id item in selectedItems) {
        if ([item isKindOfClass:[DicomStudy class]]) {
            DicomStudy *study = (DicomStudy*) item;
            
            for (DicomSeries *series in [study imageSeries])
                [self.selectedSeries addObject:series];
            
        } else if ([item isKindOfClass:[DicomSeries class]])
            [self.selectedSeries addObject:(DicomSeries*) item];
    }
    
    
    // Process dicom series
    NSNumber *compressionFactor = [NSNumber numberWithFloat:0.9];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor
                                                           forKey:NSImageCompressionFactor];
    
    
    
    for (DicomSeries *series in self.selectedSeries)
    {
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        NSString *filename =
        [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-radiopaedia.zip", uuidString]];
        
        
        
        
        OZZipFile *zipFile= [[OZZipFile alloc] initWithFileName:filename                                                     mode:OZZipFileModeCreate];
        
        for (DicomImage *image in [series sortedImages])
        {
            NSImageRep *imageRep = [[[image image] representations] objectAtIndex:0];
            NSData *imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[image instanceNumber] stringValue]];
            OZZipWriteStream *stream= [zipFile writeFileInZipWithName:imageName
                                                     compressionLevel:OZZipCompressionLevelBest];
            [stream writeData:imageData];
            [stream finishedWriting];
        }
        [zipFile close];
        
        [self.zipFiles addObject:filename];
    }
    
    
    NSURL *tokenURL = [NSURL URLWithString:@"http://sandbox.radiopaedia.org/oauth/token"];
    
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page.
    NSString *redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    
    GTMOAuth2Authentication *auth;
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
       
    // Here we try to retrieve the cases
    
   
    return 0;

}

@end
