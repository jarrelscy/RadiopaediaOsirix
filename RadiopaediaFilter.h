//
//  RadiopaediaFilter.h
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OsiriXAPI/PluginFilter.h"
#import "EnterDetailsWindowController.h"
#import "ProgressWindowController.h"
#import "FinishedWindowController.h"
@interface RadiopaediaFilter : PluginFilter {
    
}
@property  (nonatomic, strong) NSMutableArray *selectedStudies;
@property  (nonatomic, strong) NSMutableArray *selectedSeries; // needs to be accessible in the block and also make sure ARC doesn't zombify the thing 
@property (nonatomic, strong) NSMutableArray *zipFiles;
@property (nonatomic, strong) NSMutableArray *seriesNames;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *patientAge;
@property (nonatomic) float patientAgeFloat;
@property (nonatomic) bool isSignedIn;
@property (nonatomic) float compressionValue;
@property (nonatomic, strong) NSDate *caseDate;
@property (nonatomic, strong) NSString *patientSex;
@property (nonatomic, strong) NSString *returnedCaseTitle;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSString *system;
@property (nonatomic) long caseCreationStatus;
@property (nonatomic, strong) NSMutableArray *queuedRequests;
@property (nonatomic, strong) NSMutableArray *seriesDescriptions;
@property (nonatomic, strong) FinishedWindowController* finishedWindowController;
@property (nonatomic, strong) EnterDetailsWindowController *detailsController;
@property (nonatomic, strong) ProgressWindowController *progressController;
@property (nonatomic, strong) NSWindow *originalWindow;
@property (nonatomic, strong) GTMOAuth2WindowController *windowController;
@property (nonatomic) bool addStudyDaysAsCaption;
@property (nonatomic) bool addStudyNamesAsFindings;
-(void) alert:(NSArray *)info;

- (long) filterImage:(NSString*) menuName;
- (void) processSeriesArray:(NSMutableArray*) seriesArray with:(NSString *)caseId using:(GTMOAuth2Authentication *)auth withDicom:(DicomStudy *)study;
-(void) startProgressBarFor:(NSURLConnection *)connection;
-(void) startProcessingQueue;
-(void) continueProcessingQueue;
@end
