//
//  detailControllTableViewController.m
//  wheather
//
//  Created by Joe Franc on 10/26/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "detailControllTableViewController.h"
#import "SearchVieController.h"
#import "WANetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "detailTableViewCell.h"

static NSString const * kcels = @"\u00B0";



@interface detailControllTableViewController () <UITableViewDelegate, UITableViewDataSource, SDWebImageManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *detailCityLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableViewDetails;
@property (strong, nonatomic) NSString *tempString;
@property (strong,nonatomic) NSMutableArray * tempsStrings;
@property (strong, nonatomic) IBOutlet UILabel *tempDetLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageDetail;
@property (strong, nonatomic) IBOutlet UILabel *txtDateDeteil;
@property (strong, nonatomic) NSString *imgString;
@property (strong, nonatomic) NSString *dataStr;


@end

@implementation detailControllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailCityLabel.text = _detailSearchBarCity;
    self.tableViewDetails.dataSource = self;
    self.tableViewDetails.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden" forIndexPath:indexPath];
   
       [[WANetworkManager sharedInstance] loadWeatherForTown:_detailCityLabel.text completion:^(NSDictionary *resposeData) {
           NSNumber * temperatureNumber = [[resposeData valueForKeyPath: @"list.main.temp"]objectAtIndex:0];
           NSLog(@"==============%@",temperatureNumber);
           temperatureNumber = @([temperatureNumber integerValue]);
           
           NSString * temperatureString = [temperatureNumber stringValue];
        self.tempString = temperatureString;
           
           NSString *numberIcon = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
           NSLog(@"%@=====", numberIcon);
           NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
           self.imgString = url;
           NSString * data = [[resposeData valueForKey:@"list"]valueForKey:@"dt_txt"];
           
           NSLog(@"%@",data);
          self.dataStr = data;
           
           

    }];

    cell.tempDetailLbl.text = _tempString;
    //cell.imageDetail = _imageDet;
    //cell.txtDateil.text = _dataStr;

    

    NSLog(@"=============%@",_tempString);
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
