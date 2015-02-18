//
//  ViewController.m
//  FileList
//
//  Created by grizzly on 12.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize api;
@synthesize MoviesSearchBar;
@synthesize APIKey;
@synthesize MoviesSegmentControl;


#pragma mark - UITableView
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    APIKey = @"20203bb711ce93f78036ebc7f576d604";
    [self PopularMovieInformation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Movies count];
}

- (IBAction)segmentControlAction:(id)sender {
    NSInteger segIndex = MoviesSegmentControl.selectedSegmentIndex;
    switch (segIndex) {
        case 0:
            [self PopularMovieInformation];
            break;
        case 1:
            [self UpcomingMovieInformation];
            break;
        case 2:
            [self TopRatedMovieInformation];
            break;
    }
}

#pragma mark - UITableViewDataSource
-(void)JSONAPIResults:(NSArray *) results{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.Movies = results;
        self.filteredMovies = [NSMutableArray arrayWithCapacity:self.Movies.count];
        [self.appTableView reloadData];
    });
}

#pragma mark - MovieArrayFill
-(void)GenerateMovieInformation:(NSString *)Request{
    
    NSString *APIBaseUrl = Request;
    NSString *urlString = [APIBaseUrl stringByAppendingString:APIKey];
    api = [[APIController alloc] init];
    api.APIControllerProtocol = self;
    [self.api GetAPIAsyncResults:urlString];
}

#pragma mark - MovieArrayFill
-(void)UpcomingMovieInformation{
    
    [self GenerateMovieInformation:@"http://api.themoviedb.org/3/movie/upcoming?api_key="];
}

#pragma mark - MovieArrayFill
-(void)PopularMovieInformation{
    
    [self GenerateMovieInformation:@"http://api.themoviedb.org/3/movie/popular?api_key="];
}

#pragma mark - MovieArrayFill
-(void)TopRatedMovieInformation{
    
    [self GenerateMovieInformation:@"http://api.themoviedb.org/3/movie/top_rated?api_key="];
    
}


#pragma mark Content Filtering
-(void)filterContentforSearchText:(NSString *)searchText scope:(NSString *)string{
    
    [self.filteredMovies removeAllObjects];
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"Self.name contains[c]",searchText];
    self.filteredMovies = [NSMutableArray arrayWithArray:[self.Movies filteredArrayUsingPredicate:scopePredicate]];
}

#pragma mark - UISearchControllerDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"MovieResultCell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:Identifier];
    }
    
    NSDictionary *cellData = [self.Movies objectAtIndex:indexPath.row];
    cell.textLabel.text = cellData[@"title"];
    
    
    
    return cell;
}

@end
