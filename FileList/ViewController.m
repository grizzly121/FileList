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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *APIKey = @"20203bb711ce93f78036ebc7f576d604";
    NSString *APIBaseUrl = @"http://api.themoviedb.org/3/movie/upcoming?api_key=";
    NSString *urlString = [APIBaseUrl stringByAppendingString:APIKey];
    self.Movies = [[NSMutableArray alloc] initWithObjects:@"TT",nil];
    self.api =[[APIController alloc] init];
    [self.api GetAPIAsyncResults:urlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Movies count];
}

-(void)JSONAPIResults:(NSArray *) results{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.Movies = results;
        [self.appTableView reloadData];
    });
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"Movies";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    NSDictionary *cellData = (NSDictionary *)[self.Movies objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = (NSString *)cellData[@"title"];
    
    return cell;
}

@end
