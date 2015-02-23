//
//  MovieDetailsView.h
//  FileList
//
//  Created by grizzly on 19.02.15.
//  Copyright (c) 2015 grizzly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface MovieDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *MovieName;
@property (weak, nonatomic) IBOutlet UIImageView *MoviePoster;
@property (strong,nonatomic) NSString *MovieTitle;
@property (strong,nonatomic) NSString *Details;
@property (strong,nonatomic) UIImage *Poster;

@property (weak, nonatomic) IBOutlet UITextView *MovieDetails;

@end
