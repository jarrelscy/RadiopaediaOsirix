//
//  RadiopaediaFilter.h
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import "EnterDetailsWindowController.h"
@interface RadiopaediaFilter : PluginFilter {
    NSMutableArray *selectedSeries;
    NSMutableArray *zipFiles;
    NSString *title;
    NSString *system;
    EnterDetailsWindowController *detailsController;
    
}
@property  (nonatomic, strong) NSMutableArray *selectedSeries; // needs to be accessible in the block and also make sure ARC doesn't zombify the thing 
@property (nonatomic, strong) NSMutableArray *zipFiles;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *system;
@property (nonatomic, strong) EnterDetailsWindowController *detailsController;
-(void) alert:(NSArray *)info;

- (long) filterImage:(NSString*) menuName;
- (void) processSeries:(DicomSeries*) series with:(NSString *)caseId;
-(void) startProgressBarFor:(NSURLConnection *)connection;
@end
