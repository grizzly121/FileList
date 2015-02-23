//
//  MovieDetailsView.m
//  FileList
//
//  Created by grizzly on 19.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import "MovieDetailsViewController.h"

@implementation MovieDetailsViewController

@synthesize MovieName;
@synthesize MovieDetails;
@synthesize MoviePoster;
@synthesize MovieTitle;
@synthesize Details;
@synthesize Poster;

-(void)viewDidLoad{

    [super viewDidLoad];
    
    MovieName.text = MovieTitle;
    MovieDetails.text = Details;
    MoviePoster.image = Poster;
}

@end
