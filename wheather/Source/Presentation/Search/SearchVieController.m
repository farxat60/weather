//
//  SearchVieController.m
//  wheather
//
//  Created by Joe Franc on 10/11/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "SearchVieController.h"
#import "WANetworkManager.h"
#import "WANetworkingManagerDay.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "detailControllTableViewController.h"
#import "detailTableViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "City+CoreDataClass.h"
#import "City+CoreDataProperties.h"



static NSInteger const kcelsius = 273.15;
static NSString const * kcels = @"\u00B0";
static NSString const * kimageIcon = @"http://openweathermap.org/img/w/";
//static NSInteger const kmmHG = 0.7500616;

@interface SearchVieController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SDWebImageManagerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarCity;
@property (strong, nonatomic) IBOutlet UITableView *tableVIewSearch;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (strong, nonatomic) IBOutlet UILabel *descrLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailsViewController;
@property (strong, nonatomic) NSArray * cityArray;



@end

@implementation SearchVieController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBarCity.delegate = self;
    self.tableVIewSearch.delegate = self;
    self.tableVIewSearch.dataSource = self;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.tableVIewSearch reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [[WANetworkManagerDay sharedInstance] loadWeatherForTownDay:_searchBarCity.text completion:^(NSDictionary *resposeData) {
//          self.cityLable.text = [resposeData valueForKeyPath:@"city.name"];
        NSNumber * temperatureNumber = [[resposeData valueForKey:@"main"]objectForKey:@"temp"];
        temperatureNumber = @([temperatureNumber integerValue] - kcelsius);
        NSString * temperatureString = [temperatureNumber stringValue];
        self.cityLable.text = [resposeData objectForKey:@"name"];
        self.tempLabel.text = [NSString stringWithFormat: @"%@%@",temperatureString,kcels];
        NSString *numberIcon = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
        NSLog(@"%@=====", numberIcon);
        NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:url]];
        NSNumber *numberWind = [[resposeData valueForKey:@"wind"]objectForKey:@"speed"];
        self.windLabel.text = [NSString stringWithFormat:@"wind: %@ m/s",numberWind];
        NSNumber *numberClouds = [[resposeData valueForKey:@"clouds"]valueForKey:@"all"];
        self.cloudsLabel.text = [NSString stringWithFormat:@"clouds: %@ %%",numberClouds];
        NSString * descriprions = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"description"];
        self.descrLabel.text = descriprions;
        
        
        
        
    }];

}
- (IBAction)addCity:(id)sender {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * localContext) {
    
        City *cityName = [City MR_createEntity];
        cityName.name = _cityLable.text;
        NSLog(@"%@", cityName);
        self.cityArray = [City MR_findAll];
        
        NSLog(@"%@", _cityArray);
        NSLog(@"%lu", (unsigned long)_cityArray.count);
        [City MR_importFromArray:_cityArray];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
    }];
  
}
- (void)fetchNotes {
    // Fetch Notes
    self.cityArray = [NSMutableArray arrayWithArray:[City MR_findAll]];
}





- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *cellIden;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden"];
    cell = [[UITableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    City *city = [self.cityArray objectAtIndex:indexPath.row];
  
    if([_cityArray count] > 0 && [_cityArray count] > indexPath.row){
        
        [cell.textLabel setText:[city name]];
        
        
        
        NSLog(@"%@-------------------------city",city);
        
    }
    else{

    }
    
    
    // Configure Cell
   // [cell.textLabel setText:[city name]];
    


    NSLog(@"%@-------------------------city",city);

    
    return cell;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailWeather"]){
         detailControllTableViewController*vc = segue.destinationViewController;
        vc.detailSearchBarCity = _cityLable.text;
        
    }
}















@end
