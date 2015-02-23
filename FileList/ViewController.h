//
//  ViewController.h
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "APIController.h"
#include "MovieDetailsViewController.h"

@interface ViewController : UIViewController<APIControllerProtocol,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>


@property (nonatomic,strong) APIController *api;
@property (weak, nonatomic) IBOutlet UITableView *appTableView;
@property (nonatomic,strong) NSArray *Movies;
@property (nonatomic,strong) NSMutableArray *filteredMovies;
@property (strong) IBOutlet UISegmentedControl *MoviesSegmentControl;
@property (strong,nonatomic) NSString *APIKey;
@property (strong,nonatomic) UISearchController *resultSearchController;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFileWasFirstResponder;
@property (strong,nonatomic) NSDictionary *MovieResult;
@property (strong,nonatomic) dispatch_group_t group;

@end

