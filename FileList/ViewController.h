//
//  ViewController.h
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "APIController.h"

@interface ViewController : UIViewController<APIControllerProtocol,UISearchBarDelegate,UISearchControllerDelegate>


@property (nonatomic,strong) APIController *api;
@property (weak, nonatomic) IBOutlet UITableView *appTableView;
@property (nonatomic,strong) NSArray *Movies;
@property (nonatomic,strong) NSMutableArray *filteredMovies;
@property (strong) IBOutlet UISearchBar *MoviesSearchBar;
@property (strong) IBOutlet UISegmentedControl *MoviesSegmentControl;
@property (strong,nonatomic) NSString *APIKey;

@end

