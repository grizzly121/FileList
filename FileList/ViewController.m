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
@synthesize APIKey;
@synthesize MoviesSegmentControl;
@synthesize resultSearchController;
@synthesize appTableView;
@synthesize Movies;
@synthesize filteredMovies;
@synthesize searchControllerSearchFileWasFirstResponder;
@synthesize searchControllerWasActive;
@synthesize MovieResult;
@synthesize group;

#pragma mark - UITableView
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    APIKey = @"20203bb711ce93f78036ebc7f576d604";
    [self PopularMoviesInformation];
    resultSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    [self.resultSearchController.searchBar sizeToFit];
    self.appTableView.tableHeaderView = self.resultSearchController.searchBar;
    group = dispatch_group_create();
    [self.appTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.resultSearchController.active)
    {
        return [self.filteredMovies count];
    }else{
        return [self.Movies count];
    }
}

- (IBAction)segmentControlAction:(id)sender {
    NSInteger segIndex = MoviesSegmentControl.selectedSegmentIndex;
    switch (segIndex) {
        case 0:
            [self PopularMoviesInformation];
            break;
        case 1:
            [self UpcomingMoviesInformation];
            break;
        case 2:
            [self TopRatedMoviesInformation];
            break;
    }
}



#pragma mark - UITableViewDataSource
-(void)JSONAPIResults:(NSArray *) results{
    dispatch_queue_t MovieQueue =  dispatch_queue_create("Movies", NULL);
    dispatch_async(MovieQueue, ^{
        self.Movies = results;
        self.filteredMovies = [NSMutableArray arrayWithCapacity:[self.Movies count]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.appTableView reloadData];
        });
    });
}

-(void)JSONAPIResult:(NSDictionary *) result{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.MovieResult = result;
        [self.appTableView reloadData];
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"MovieDetail"]){
        NSIndexPath *indexPath = [self.appTableView indexPathForSelectedRow];
        MovieDetailsViewController *destViewController = segue.destinationViewController;
        NSDictionary *MoviesData = [self.Movies objectAtIndex:indexPath.row];
        NSString *FilmIdData = [NSString stringWithFormat:@"%@",MoviesData[@"id"]];
        NSString *FilmID = [FilmIdData stringByAppendingString:@"?api_key="];
        [self GenerateMovieInfoBy:FilmID];
        destViewController.MovieTitle = MovieResult[@"title"];
        destViewController.Details = MovieResult[@"overview"];
        NSString *baseURL = @"http://image.tmdb.org/t/p/w300";
        NSString *movieURLString = MovieResult[@"poster_path"];
        NSString *urlString = [baseURL stringByAppendingString:movieURLString];
        NSURL *imgURL = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:imgURL];
        destViewController.Poster = [[UIImage alloc] initWithData:imgData];
    }
}


#pragma mark - MovieArrayFill
-(void)GenerateMoviesInformation:(NSString *)Request{
    
    NSString *APIBaseUrl = Request;
    NSString *urlString = [APIBaseUrl stringByAppendingString:APIKey];
    api = [[APIController alloc] init];
    api.APIControllerProtocol = self;
    [self.api GetAPIAsyncResultsListFilms:urlString];
}

-(void)GenerateMovieInfoBy:(NSString *)FilmID{
    
    NSString *APIBaseUrl = @"http://api.themoviedb.org/3/movie/";
    NSString *Request = [APIBaseUrl stringByAppendingString:FilmID];
    NSString *urlString = [Request stringByAppendingString:APIKey];
    MovieResult = [api GetResultsAboutFilmsById:urlString];
}

#pragma mark - MovieArrayFill
-(void)UpcomingMoviesInformation{
    
    [self GenerateMoviesInformation:@"http://api.themoviedb.org/3/movie/upcoming?api_key="];
}

#pragma mark - MovieArrayFill
-(void)PopularMoviesInformation{
    
    [self GenerateMoviesInformation:@"http://api.themoviedb.org/3/movie/popular?api_key="];
}

#pragma mark - MovieArrayFill
-(void)TopRatedMoviesInformation{
    
    [self GenerateMoviesInformation:@"http://api.themoviedb.org/3/movie/top_rated?api_key="];
    
}



-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
 
    [self.filteredMovies removeAllObjects];
    
    NSArray *filtered = [Movies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF['title'] beginswith[c] %@",searchController.searchBar.text]];
    
    if([filtered count] > 0)
    {
        filteredMovies = [NSMutableArray arrayWithArray:filtered];
    }

    [self.appTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if(self.searchControllerWasActive){
    
        self.resultSearchController.active = searchControllerWasActive;
        searchControllerWasActive = NO;
    }
    
    if (self.searchControllerSearchFileWasFirstResponder) {
        [self.resultSearchController.searchBar becomeFirstResponder];
        searchControllerSearchFileWasFirstResponder = NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"MovieDetail" sender:self];
}

#pragma mark - TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"MovieResultCell"; 
    
    UITableViewCell *cell = [self.appTableView dequeueReusableCellWithIdentifier:Identifier];
    
    
    NSDictionary *cellData = nil;
   
    if(resultSearchController.active && filteredMovies != nil ){
        cellData = [self.filteredMovies objectAtIndex:indexPath.row];
    }
    else{
        cellData = [self.Movies objectAtIndex:indexPath.row];
    }
    
    if(cellData != nil ){
        cell.textLabel.text = cellData[@"title"];
        NSString *baseURL = @"http://image.tmdb.org/t/p/w300";
        NSString *movieURLString = cellData[@"poster_path"];
        NSString *urlString = [baseURL stringByAppendingString:movieURLString];
        NSURL *imgURL = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:imgURL];
        cell.imageView.image = [[UIImage alloc] initWithData:imgData];
        NSString *releaseDate = cellData[@"release_date"];
    
        cell.detailTextLabel.text = releaseDate;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
