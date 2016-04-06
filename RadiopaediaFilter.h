//
//  RadiopaediaFilter.h
//  Radiopaedia
//
//  Copyright (c) 2016 Jarrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@interface RadiopaediaFilter : PluginFilter {

}

- (long) filterImage:(NSString*) menuName;

@end
