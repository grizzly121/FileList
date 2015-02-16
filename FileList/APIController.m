//
//  APIController.m
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import "APIController.h"

@implementation APIController


-(void)GetAPIAsyncResults:(NSString *) urlString{
    
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *Request = [NSURLRequest requestWithURL:url
                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:Request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      
        if(connectionError != nil){
            NSError *error = nil;
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers
                                                                      error:&error ];
    
    
            if (error != nil) {
                NSLog(@"%@",[error localizedDescription]);
            }
            else{
                if ([jsonResults count] > 0 && [jsonResults[@"results"] count] > 0 ) {
                
                    NSArray *results = (NSArray *)jsonResults[@"results"];
                    [self.APIControllerProtocol JSONAPIResults:results];
                }
            }
        }else{
        
            NSLog(@"%@",[connectionError localizedDescription]);
        }
        
    }];
}

@end
