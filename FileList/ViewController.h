//
//  ViewController.h
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"

@interface ViewController : UIViewController <APIControllerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *appTableView;
@property (nonatomic,strong) NSArray *Movies;
@property (nonatomic,strong) APIController *api;

@end

