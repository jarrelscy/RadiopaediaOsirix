//
//  RadiopaediaFilter.h
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@interface RadiopaediaFilter : PluginFilter {
    NSMutableArray *selectedSeries;
    NSMutableArray *zipFiles;
}
@property  (nonatomic, strong) NSMutableArray *selectedSeries; // needs to be accessible in the block and also make sure ARC doesn't zombify the thing 
@property (nonatomic, strong) NSMutableArray *zipFiles;
-(void) alert:(NSArray *)info;
- (long) filterImage:(NSString*) menuName;
- (void) processSeries:(DicomSeries*) series with:(NSString *)caseId;
@end
