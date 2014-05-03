//
//  ButtonView.m
//  2048 5x5 Blitz
//
//  Created by MacCoder on 4/30/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ButtonView.h"
#import "GameConstants.h"
#import "GameLayoutView.h"
#import "ConfirmMenu.h"

@implementation ButtonView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
//    self.layer.cornerRadius = 20.f * IPAD_SCALE;
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = 20.f * IPAD_SCALE;
    return self;
}

- (void)setupWithType:(ButtonViewType)type {
    self.type = type;
    [self refresh];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [[[ConfirmMenu alloc] init] show:self];
    
    [self refresh];
}

- (void)refresh {
    switch (self.type) {
        case ButtonViewTypeShuffle:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].shuffleCost];
            // image shuffle
            // cost label
            self.backgroundColor = [UIColor redColor];
            break;
        case ButtonViewTypeBomb2:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].bomb2Cost];
            self.backgroundColor = [UIColor blackColor];
            break;
        case ButtonViewTypeBomb4:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].bomb4Cost];
            self.backgroundColor = [UIColor blueColor];
            break;
        case ButtonViewTypeLostShuffle:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].lostGameCost];
            self.backgroundColor = [UIColor blueColor];
            break;
        case ButtonViewTypeLostBomb2:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].lostGameCost];
            self.backgroundColor = [UIColor blueColor];
            break;
        case ButtonViewTypeLostBomb4:
            self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].lostGameCost];
            self.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
}

- (int)priceCheck{
    switch (self.type) {
        case ButtonViewTypeShuffle:
            return [GameData instance].shuffleCost;
            break;
        case ButtonViewTypeBomb2:
            return [GameData instance].bomb2Cost;
            break;
        case ButtonViewTypeBomb4:
            return [GameData instance].bomb4Cost;
            break;
        case ButtonViewTypeLostShuffle:
            return [GameData instance].shuffleCostLost;
            break;
        case ButtonViewTypeLostBomb2:
            return [GameData instance].bomb2CostLost;
            break;
        case ButtonViewTypeLostBomb4:
            return [GameData instance].bomb4CostLost;
            break;
        default:
            break;
    }
}

@end
