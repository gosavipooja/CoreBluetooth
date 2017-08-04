//
//  HomeViewController.m
//  CoreBluetoothImplementation
//
//  Created by Pooja Gosavi on 7/20/17.
//  Copyright © 2017 Pooja Gosavi. All rights reserved.
//

#import "HomeViewController.h"
#import "Contants.h"
#define CA_GATT_SERVICE_UUID "ADE3D529-C784-4F63-A987-EB69F70EE816"

static CBUUID* g_OICGattServiceUUID = NULL;

@interface HomeViewController ()
@property (strong, nonatomic) NSArray<CBUUID*>* servicesToScanFor;
@property (strong, nonatomic) NSMutableArray *peripheralList;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HomeViewController

@synthesize mTableView;
@synthesize centralManager;
@synthesize cbArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    g_OICGattServiceUUID = [CBUUID UUIDWithString:@CA_GATT_SERVICE_UUID];
    _servicesToScanFor = @[g_OICGattServiceUUID];
    _peripheralList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_peripheralList count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    CBPeripheral *per = _peripheralList[indexPath.row];
    cell.textLabel.text = [per.identifier UUIDString];
    return cell;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString* deviceName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSLog(@"Device = %@",deviceName);
    NSLog(@"Peripheral Identifier = %@",[peripheral.identifier UUIDString]);
    if (![_peripheralList containsObject:peripheral]) {
        [_peripheralList addObject:peripheral];
    }
    NSLog(@"%lu",(unsigned long)[_peripheralList count]);
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    NSLog(@"This is it!");
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *messtoshow;
    
    switch (central.state) {
        case CBManagerStateUnknown:
        {
            messtoshow=[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBManagerStateResetting:
        {
            messtoshow=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBManagerStateUnsupported:
        {
            messtoshow=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBManagerStateUnauthorized:
        {
            messtoshow=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        }
        case CBManagerStatePoweredOff:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            break;
        }
        case CBManagerStatePoweredOn:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            NSDictionary* options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
            [self startTimer];
            [centralManager scanForPeripheralsWithServices:_servicesToScanFor options:options];

            
            break;
        }   
            
    }
    NSLog(@"%@", messtoshow);
}

- (void) startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopTimer) userInfo:nil repeats:nil];
}

- (void) stopTimer {
    [centralManager stopScan];
    [mTableView reloadData];
}

@end
