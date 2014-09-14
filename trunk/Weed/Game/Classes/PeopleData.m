//
//  PeopleData.m
//  Weed
//
//  Created by MacCoder on 8/22/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "PeopleData.h"
#import "Utils.h"

@implementation PeopleData

+ (NSArray *)nameListM {
    NSMutableArray *nameList = [NSMutableArray arrayWithObjects:@"David",@"Ben",@"Glen",@"William",@"Jacob",@"Matthew",@"Jonathan",@"Levi",@"Eren",@"Adam",@"Roger",@"Dylan",@"James",@"Justin",@"Jack",@"Lucas",@"Ryan",@"Tyler",@"Charles",@"Thomas",@"Samson",@"Jordan",@"Andrew",@"Robert",@"Luke",@"Gavin",@"Rolan",@"Nolan",@"Carter",@"Howard",@"Henry",@"Kevin",@"Branden",@"Edward", nil];
    return nameList;
}

+ (NSArray *)nameListF {
    NSMutableArray *nameList = [NSMutableArray arrayWithObjects:@"Mary",@"Patricia",@"Linda",@"Barbara",@"Elizabeth",@"Jennifer",@"Maria",@"Susan",@"Margaret",@"Dorothy",@"Lisa",@"Nancy",@"Karen",@"Betty",@"Helen",@"Sandra",@"Donna",@"Carol",@"Ruth",@"Sharon",@"Laura",@"Sarah",@"Kimberly",@"Deborah",@"Jessica",@"Michelle",@"Jessica",@"Shirley",@"Amy",@"Anna",@"Rebecca",@"Lucy",@"Alma",@"Jeanne",@"Vicky",@"Laura",@"Teresa",@"Claire",@"Ella",@"Pearl",@"Allison",@"Joy",@"Stella",@"Lena",@"Penny",@"Sonia",@"Erika",@"Faye",@"Pam",@"Celia",@"Angelica", nil];
    return nameList;
}

+ (NSString *)randomName:(Gender)gender {
    NSString *name = @"";
    NSArray *nameList = [NSMutableArray array];
    if (gender == GenderMale) {
        nameList = [self nameListM];
    } else if (gender == GenderFemale){
        nameList = [self nameListF];
    }
    
    int randomNumber = [Utils randBetweenMinInt:0 max:(int)nameList.count - 1];
    name = [nameList objectAtIndex:randomNumber];
    return name;
}

+ (NSNumber *)randomGender {
    NSNumber *male = [NSNumber numberWithInt:GenderMale];
    NSNumber *female = [NSNumber numberWithInt:GenderFemale];
    NSArray *list = [[NSArray alloc] initWithObjects:
                     male,
                     female,
                     nil];
    NSNumber *gender = [list randomObject];
    return gender;
}

+ (NSString *)generateFace:(Gender)gender {
    NSString *imagePath = @"";
    if (gender == GenderMale) {
        imagePath = @"maleface";
    } else if (gender == GenderFemale){
        imagePath = @"femaleface";
    }
    
    return imagePath;
}

+ (NSString *)randomJob {
    NSArray *jobList = [self jobList];
    NSString *randomJob = [jobList randomObject];
    return randomJob;
}

+ (NSArray *)jobList {
    NSMutableArray *nameList = [NSMutableArray arrayWithObjects:@"a Doctor",@"a Student",@"a Drunker",@"a Homeless",@"a Noble",@"and Family",@"a Celebrity",@"a Programmer",@"a Teacher",@"a Sport Player",@"a Tutor",@"a Karate Master",@"a Pilot",@"a Chief",@"a Dishwasher",@"a Rich Guy",@"the Crazed",@"the Ninja",@"and Imaginary Friends",@"a Robot",@"the Beauty",@"an Astronaut",@"a Pirate",@"the Beast",@"the Impatient",@"the Haunting Ghost",@"the Lazy",@"a Hard Worker",@"the King",@"the normal",@"a Cashier",@"the ArTisT",@"the sneaky",@"a officer",@"the future President",@"the HERO",@"the Lucky",@"the Heartbroken",@"the Thief",@"the Toilet Cleaner",@"the Miracle Bringer",@"the Model",@"from Space",@"the THAT person",@"the Popular",@"the Fortunate",@"the Unfortunate",@"your Buddy",@"your Enemy",@"your BEST friend's friend",@"an Angel", nil];
    return nameList;
}
@end
