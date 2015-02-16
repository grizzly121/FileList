//
//  APIController.h
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIController;
@protocol APIControllerProtocol <NSObject>

-(void) JSONAPIResults: (NSArray *) results;

@end


@interface APIController : NSObject

@property (weak) id<APIControllerProtocol> APIControllerProtocol;
-(void)GetAPIAsyncResults:(NSString *) urlString;

@end
