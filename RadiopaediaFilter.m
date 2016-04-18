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
        
        
        
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [self.detailsController.caseTitleField stringValue], @"title",
                                           [NSString stringWithFormat:@"%ld", (long)[self.detailsController.systemSelect indexOfSelectedItem]], @"system_id",
                                           [self.detailsController.ageField stringValue], @"age",
                                           [self.detailsController.genderSelect titleOfSelectedItem], @"gender",
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
                 self.seriesNames = [NSMutableArray array];
                 self.queuedRequests = [NSMutableArray array];
                 NSUInteger i = 0;
                 for (NSMutableArray *seriesArray in self.selectedSeries) {
                     [self processSeriesArray:seriesArray with:caseId using:auth withDicom:[self.selectedStudies objectAtIndex:i]];
                     i++;
                 }
                 
                 // start processing queue of requests
                 [self startProcessingQueue];
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

-(NSString *) parse:(NSString *)modality
{
    if ([modality isEqualToString:@"MR"])
    {
        return @"MRI";
    }
    else if ([modality isEqualToString:@"US"])
    {
        return @"Ultrasound";
    }
    else if ([modality isEqualToString:@"MG"])
    {
        return @"Mammography";
    }
    else if ([modality isEqualToString:@"XA"])
    {
        return @"DSA (angiography)";
    }
    else if ([modality isEqualToString:@"NM"])
    {
        return @"Nuclear medicine";
    }
    else if ([modality isEqualToString:@"CR"])
    {
        return @"X-ray";
    }
    else if ([modality isEqualToString:@"RF"])
    {
        return @"Fluoroscopy";
    }
    else
    {
        return modality;
    }
}
- (void) processSeriesArray:(NSMutableArray*) seriesArray with:(NSString *)caseId using:(GTMOAuth2Authentication *)auth withDicom:(DicomStudy *)study {
    
    
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [self parse:[study modality]], @"modality",
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
             NSUInteger seriesArrayIndex = [self.selectedSeries indexOfObject:seriesArray];
             
             // Post image stack (series)
             NSUInteger seriesIndex =0;
             for (DicomSeries *series in seriesArray)
             {
                 NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      nil];
                 NSString *paramStr = [GTMOAuth2Authentication encodedQueryParametersForDictionary:paramsDict];
                 NSString *urlString = [NSString stringWithFormat:@"http://sandbox.radiopaedia.org/api/v1/cases/%@/studies/%@/images", caseId, studyId];
                 NSMutableURLRequest *request2  = [GTMOAuth2SignIn mutableURLRequestWithURL:[NSURL URLWithString:urlString]
                                                                              paramString:paramStr];
                 request2.HTTPMethod = @"POST";
                 
                 
                 NSString *contentType = [NSString stringWithFormat:@"application/zip"];
                 [request2 addValue:contentType forHTTPHeaderField: @"Content-Type"];
                 
                 NSData *data = [NSData dataWithContentsOfFile:[self.zipFiles[seriesArrayIndex] objectAtIndex:seriesIndex]];
                 request2.HTTPBody = data;
                 [auth authorizeRequest:request2 completionHandler:^(NSError *err)
                  {
                      if (err == nil) {
                          [self.queuedRequests addObject:request2];
                      }
                      else{
                      }
                      
                  }];
                 [self.seriesNames addObject:[series name]];
                 seriesIndex++;
             }
             
             
         }
         
         else{
             // Failed to authorize for some reason
             NSAlert *myAlert = [NSAlert alertWithMessageText:@"Error uploading study!"
                                                defaultButton:@"Ok"
                                              alternateButton:nil
                                                  otherButton:nil
                                    informativeTextWithFormat:@"Failed to upload %@: %@",[study name], [err description]];
             
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
    
    self.selectedStudies = [NSMutableArray array];
    self.selectedSeries = [NSMutableArray array];
    self.zipFiles = [NSMutableArray array];
    for (id item in selectedItems) {
        if ([item isKindOfClass:[DicomStudy class]]) {
            DicomStudy *study = (DicomStudy*) item;
            
            [self.selectedStudies addObject:study];
            
            NSMutableArray *tempArray = [NSMutableArray array];
            [self.selectedSeries addObject:tempArray];
            
            for (DicomSeries *series in [study imageSeries])
            {
                [tempArray addObject:series];
            }
            
        } else if ([item isKindOfClass:[DicomSeries class]])
        {
            DicomSeries *series = (DicomSeries *)item;
            NSMutableArray *tempArray;
            if (![self.selectedStudies containsObject:[series study]])
              {
                  // insert new study and create temp array
                  [self.selectedStudies addObject:[series study]];
                  tempArray = [NSMutableArray array];
                  [self.selectedSeries addObject:tempArray];
              }
            else
            {
                // get previous temp array
                NSUInteger *i = [self.selectedStudies indexOfObject:[series study]];
                tempArray = [self.selectedSeries objectAtIndex:i];
            }
            
            [tempArray addObject:(DicomSeries*) item];
        }
    }
    
    
    // Process dicom series
    NSNumber *compressionFactor = [NSNumber numberWithFloat:0.5];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor
                                                           forKey:NSImageCompressionFactor];
    
    
    
    for (NSMutableArray *seriesArray in self.selectedSeries)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        [self.zipFiles addObject:tempArray];
        for (DicomSeries *series in seriesArray)
        {
            NSString *uuidString = [[NSUUID UUID] UUIDString];
            NSString *filename =
            [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-radiopaedia.zip", uuidString]];
            
            
            
            
            OZZipFile *zipFile= [[OZZipFile alloc] initWithFileName:filename mode:OZZipFileModeCreate legacy32BitMode:YES];
            
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
            
            [tempArray addObject:filename];
        }
    }
    
    
    
    // Here we try to retrieve the cases
    self.detailsController = [[EnterDetailsWindowController alloc] initWithWindowNibName:@"EnterDetailsWindow"];
    //[self.detailsController showWindow:nil];
    
    // REMEMBER MEMORY ON XIB FILE SHOULD BE BUFFERED
    self.originalWindow = [NSApp keyWindow];
    [self.originalWindow beginSheet:self.detailsController.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK)
        {
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
            
            
            self.windowController = [GTMOAuth2WindowController controllerWithAuthentication:auth
                                                                      authorizationURL:authURL
                                                                      keychainItemName:@"Radiopaedia Osirix"
                                                                        resourceBundle:nil];
            
            NSString *html = @"<html><body><div align=center>Loading sign-in page...</div></body></html>";
            [self.windowController setInitialHTMLString:html];
            [self.windowController signInSheetModalForWindow:self.originalWindow
                                               delegate:self
                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        }
    }];
   
    return 0;

}
-(void) startProgressBarFor:(NSURLConnection *)connection
{
    
}

-(void) startProcessingQueue
{
    // TODO count total bytes etc and adjust progress bar
    self.progressController = [[ProgressWindowController alloc] initWithWindowNibName:@"ProgressWindow"];
    [self.progressController showWindow:nil];
    [self continueProcessingQueue];

}
-(void) continueProcessingQueue
{
    NSURLRequest *request = [self.queuedRequests lastObject];
    NSString *seriesName = [self.seriesNames lastObject];
    [self.progressController.progressIndicator setDoubleValue:0.0];
    [self.progressController.seriesLabel setStringValue:seriesName];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self
                                   startImmediately:YES];
    
    // NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response2 options: NSJSONReadingMutableContainers error: &requestError];
    [self performSelectorOnMainThread:@selector(startProgressBarFor:) withObject:connection waitUntilDone:NO];
}
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    [self.progressController.progressIndicator incrementBy:(double)bytesWritten * 100.0 / (double)totalBytesExpectedToWrite];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.queuedRequests removeLastObject];
    [self.seriesNames removeLastObject];
    if ([self.queuedRequests count] > 0)
    {
        [self continueProcessingQueue];
    }
    else
    {
        [self.progressController close];
        NSAlert *myAlert = [NSAlert alertWithMessageText:@"Finished upload!"
                                           defaultButton:@"Ok"
                                         alternateButton:nil
                                             otherButton:nil
                               informativeTextWithFormat:@""];
        [myAlert runModal];

    }
    /*
     <NSHTTPURLResponse: 0x7f88b9923040> { URL: http://sandbox.radiopaedia.org/api/v1/cases/110/studies/43979/images } { status code: 201, headers {
     Age = 0;
     "Cache-Control" = "max-age=0, private, must-revalidate";
     Connection = "keep-alive";
     "Content-Length" = 155;
     "Content-Type" = "application/json";
     Date = "Thu, 07 Apr 2016 21:17:18 GMT";
     Etag = "\"3043e56510ae52e1d05e6830ca72bc39\"";
     Location = "http://sandbox.radiopaedia.org/cases/110/images/23422";
     Status = "201 Created";
     "X-Powered-By" = TrikeApps;
     "X-UA-Compatible" = "IE=Edge,chrome=1";
     } }
     
     */ 

}


@end
