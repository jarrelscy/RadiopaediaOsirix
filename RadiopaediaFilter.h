//
//  RadiopaediaFilter.h
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import "EnterDetailsWindowController.h"
#import "ProgressWindowController.h"
@interface RadiopaediaFilter : PluginFilter {
    
}
@property  (nonatomic, strong) NSMutableArray *selectedSeries; // needs to be accessible in the block and also make sure ARC doesn't zombify the thing 
@property (nonatomic, strong) NSMutableArray *zipFiles;
@property (nonatomic, strong) NSMutableArray *seriesNames;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *system;
@property (nonatomic, strong) NSMutableArray *queuedRequests;
@property (nonatomic, strong) EnterDetailsWindowController *detailsController;
@property (nonatomic, strong) ProgressWindowController *progressController;
@property (nonatomic, strong) NSWindow *originalWindow;
@property (nonatomic, strong) GTMOAuth2WindowController *windowController;
-(void) alert:(NSArray *)info;

- (long) filterImage:(NSString*) menuName;
- (void) processSeries:(DicomSeries*) series with:(NSString *)caseId;
-(void) startProgressBarFor:(NSURLConnection *)connection;
-(void) startProcessingQueue;
-(void) continueProcessingQueue;
@end
