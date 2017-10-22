//
//  SearchVieController.m
//  wheather
//
//  Created by Joe Franc on 10/11/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "SearchVieController.h"
#import "WANetworkManager.h"

static NSInteger const kcelsius = 273.15;
static NSString * kcels = @"\u00B0";

@interface SearchVieController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarCity;
@property (strong, nonatomic) IBOutlet UITableView *tableVIewSearch;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;





@end

@implementation SearchVieController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBarCity.delegate = self;
    self.tableVIewSearch.delegate = self;
    self.tableVIewSearch.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}






- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [[WANetworkManager sharedInstance] loadWeatherForTown:_searchBarCity.text completion:^(NSDictionary *resposeData) {
        NSLog(@"%@", resposeData[@"weather"]);
       NSNumber * temperatureNumber = [[resposeData valueForKey:@"main"]objectForKey:@"temp"];
        temperatureNumber = @([temperatureNumber integerValue] - kcelsius);
        NSString * temperatureString = [temperatureNumber stringValue];
        self.cityLable.text = [resposeData objectForKey:@"name"];
        self.tempLabel.text = [NSString stringWithFormat: @"%@%@",temperatureString,kcels];
        self.iconImg.image = [[resposeData valueForKey:@"weather[]"]objectForKey:@"icon"];
        
    }];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *cellIden;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden"];
    cell = [[UITableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    NSString *str = @"";
    cell.textLabel.text = str;
    return cell;
}













@end
