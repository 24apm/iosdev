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

    self.coinContainerView.layer.cornerRadius = 8.f * IPAD_SCALE;
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
    int cost = 0;
    switch (self.type) {
        case ButtonViewTypeShuffle:
           cost = [GameData instance].shuffleCost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb_shuffle.png"] forState: UIControlStateNormal];
            break;
        case ButtonViewTypeBomb2:
            cost = [GameData instance].bomb2Cost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb2"] forState: UIControlStateNormal];
            break;
        case ButtonViewTypeBomb4:
            cost = [GameData instance].bomb4Cost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb4"] forState: UIControlStateNormal];

            break;
        case ButtonViewTypeLostShuffle:
            cost = [GameData instance].lostGameCost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb_shuffle.png"] forState: UIControlStateNormal];
            break;
        case ButtonViewTypeLostBomb2:
            cost = [GameData instance].lostGameCost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb2"] forState: UIControlStateNormal];
            break;
        case ButtonViewTypeLostBomb4:
            cost = [GameData instance].lostGameCost;
            [self.buttonView setBackgroundImage:[UIImage imageNamed:@"button_powerup_bomb4"] forState: UIControlStateNormal];
            break;
        default:
            break;
    }
    
    if (cost > 0) {
        self.quantityLabel.text = [NSString stringWithFormat:@"%d",[GameData instance].shuffleCost];
    } else {
        self.quantityLabel.text = @"FREE";
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
