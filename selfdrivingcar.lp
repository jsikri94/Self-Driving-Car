%% Including test cases here. These are different scenarios being considered.
%% It is assumed that there exists some way to capture the surroundings of the car
%% and convert that information as accurately as possible to facts.

#include 'testcase.lp'.


%% Basic facts related to different lanes and turns possible

lane(middle_lane).
lane(left_lane).
lane(right_lane).
turn(left_turn).
turn(right_turn).
turn(u_turn).


%% Rules for position of the car, considering the information that has been provided.
%% Here it is considered that the only information required to know the position of the car
%% are the road markings.
%% A car is said to be in the left lane if to the left of it is a divider/yellow lines/double yellow lines
%% with one broken line and to the right is a white broken line.
%% A car is said to be in the right lane if to the right of it is the curb and to the left of it
%% is a white broken line.
%% A car is said to be in the middle lane if to the right and to the left of it is a white broken line.

car_position(left_lane):- road_left(divider), road_right(white_line_broken).
car_position(left_lane):- road_left(yellow_lines), road_right(white_line_broken).
car_position(left_lane):- road_left(doubleyellow_lines_broken), road_right(white_line_broken).
car_position(middle_lane):- road_right(white_line_broken), road_left(white_line_broken).
car_position(right_lane):- road_left(white_line_broken), road_right(curb).


%% Changing lanes from lane X to lane Y
%% The first rule considers the possibility of changing lanes from the right lane to the middle/left lane and 
%% from the middle lane to the left lane.
%% The second rule considers the possibility of changing lanes from the left lane to the middle/right lane and 
%% from the middle lane to the right lane.
%% Lane Y must be safe to change into, i.e. there should not be cars behind and also lane changing should be allowed
%% i.e. white broken line must be on the right or left of the car as a road marking.

change_lane(X,Y):- lane(X),lane(Y), road_left(white_line_broken), safe(Y), car_turnsignal_left(on).
change_lane(X,Y):- lane(X),lane(Y), road_right(white_line_broken), safe(Y), car_turnsignal_right(on).


%% Checking safety of lanes
%% A lane is safe if there are no cars visible behind or the cars are far behind
%% A turn is considered safe when there is no oncoming traffic and no pedestrians or cyclists crossing the road.

safe(X):- lane(X), cars_behind(no).
safe(X):- turn(X), oncoming_traffic(no), pedestrians(no), cyclists(no).


%% Rules for what action the car can perform considering the current scenario provided.

%% These rules consider the basic car actions pretaining to stopping, going or waiting depending
%% on the surroundings.
%% Here the traffic signals, pedestrians and cyclists have been considered, to give the final action 
%% that the car will take.

car_action(stop):-traffic_signal(red).
car_action(stop):- not road_sign(yield_for_pedestrian), pedestrian(yes).
car_action(stop):- traffic_signal(yellow), cross_traffic(no), pedestrians(yes).
car_action(slow_down):- not road_sign(yield_for_pedestrian), pedestrian(far).
car_action(wait):- traffic_signal(green), pedestrians(yes).
car_action(go):- traffic_signal(yellow), cross_traffic(no), pedestrians(no), cyclists(no).
car_action(go):- traffic_signal(green), pedestrians(no), cyclists(no).


%% Rules related to basic functionalitites of a car
%% When wipers, headlights or hazard lights should be used under certain weather conditions etc.

car_wipers(speed1):- weather(drizzle).
car_wipers(speed2):- weather(rain).
car_wipers(speed2):- weather(snow).
car_wipers(speed3):- weather(heavy_rain).
car_headlights(low_beam):- weather(rain). 
car_headlights(low_beam):- weather(heavy_rain).
car_headlights(low_beam):- weather(fog).
car_headlights(low_beam):- weather(snow).
car_headlights(low_beam):- weather(sleet).
car_headlights(low_beam):- visibility(X), X<150. %% visibility is in metres
car_hazard_signal(on):- collision_ahead(yes).
car_hazard_signal(on):- problem_with_car(yes).


%% Here we consider the car actions regarding turns.
%% The appropriate turn can only be executed if certain conditions are true, eg. the car should be in the correct lane, the turn signal should be on,
%% turning should be allowed and it should be safe.

car_action(left_turn):- car_position(left_lane), not road_sign(no_left_turn), car_turnsignal_left(on), safe(left_turn), allowed(left_turn), need_for(left_turn).
car_action(left_turn):- car_position(middle_lane), change_lane(middle_lane,left_lane), not road_sign(no_left_turn), car_turnsignal_left(on), safe(left_turn), allowed(left_turn), need_for(left_turn).
car_action(left_turn):- car_position(right_lane), change_lane(right_lane,left_lane), not road_sign(no_left_turn), car_turnsignal_left(on), safe(left_turn), allowed(left_turn), need_for(left_turn).

car_action(right_turn):- car_position(left_lane), not road_sign(no_right_turn), car_turnsignal_right(on), safe(right_turn), need_for(right_turn).
car_action(right_turn):- car_position(middle_lane), not road_sign(no_right_turn), change_lane(middle_lane,right_lane), car_turnsignal_right(on), safe(right_turn), need_for(right_turn).
car_action(right_turn):- car_position(right_lane),not road_sign(no_right_turn), car_turnsignal_right(on), safe(right_turn), need_for(right_turn).

car_action(u_turn):- car_position(left_lane), not road_sign(no_u_turn), car_turnsignal_left(on), safe(u_turn), allowed(u_turn), need_for(u_turn).
car_action(u_turn):- car_position(middle_lane), not road_sign(no_u_turn), change_lane(middle_lane,left_lane), car_turnsignal_left(on), safe(u_turn), allowed(u_turn), need_for(u_turn).
car_action(u_turn):- car_position(right_lane),not road_sign(no_u_turn), change_lane(right_lane,left_lane), car_turnsignal_left(on), safe(u_turn), allowed(u_turn), need_for(u_turn).


%% Here we consider scenarios where the car action is to yield under certain conditions.
%% At a stop sign, car must in general yield, then proceed if it is safe to do so.
%% At a stop sign yield to another car if it was already present, since first in first out is applicable.
%% Always yield for a pedestrian, under any circumstance.
%% At a four way stop sign the car on the left yields to the car on the right.
%% Yield to traffic in general when going from a single/ double laned road to a road with more than three lanes.
%% Yield to traffic in general when going from an unpaved road to a paved road.
%% Yield to traffic in general when turning at the end of a t intersection onto a road with continuing traffic.
%% Yield to authorized vehicles when flashing lights are seen or sirens are heard.
%% Yield to a bus on your side of the road or the opposite side of the road if not on a divided highway or controlled highway.
%% Yield to a train if the crossing gate has been lowered or a signal is flashing or a flagger is indicating the incoming train.
%% Or yield to the train if it can be heard or seen.

car_action(yield_to_car):- road_sign(stop_sign), car_already_present(yes).
car_action(yield_to_pedestrian):- road_sign(yield_for_pedestrian), pedestrian(yes).
car_action(yield_to_car):- road_sign(stop_sign), other_car_arrives_same_time(yes), road_right(car).
car_action(yield_to_traffic):- traffic(three_or_more_lanes), car_location(single_lane).
car_action(yield_to_traffic):- traffic(three_or_more_lanes), car_location(double_lane).
car_action(yield_to_traffic):- traffic(paved_roads), car_location(unpaved_road).
car_action(yield_to_traffic):- traffic(continuing_road),car_location(t_intersection_ending).
car_action(yield_to_authorized_vehicle):- visible(flashing_lights).
car_action(yield_to_authorized_vehicle):- hear(sirens).
car_action(yield_to_bus):- road_front(bus), visible(flashing_red_lights).
car_action(yield_to_bus):- road_front(bus), children(yes).
car_action(yield_to_bus):- road_opposite(bus), not car_location(divided_highway), not car_location(controlled_highways).
car_action(yield_to_train):- road_front(lowered_crossing_gate).
car_action(yield_to_train):- road_front(flashing_signal).
car_action(yield_to_train):- road_front(flagger).
car_action(yield_to_train):- hear(train_signal).
car_action(yield_to_train):- visible(train).


%% Rule regarding parking.
%% Rules regarding what precautions need to be taken when parking on a hill with a curb and without a curb.
%% If there is no curb then turn tires towards the right, when parking uphill or downhill.
%% When parking uphill with a curb, turn the tires towards the left.
%% When parking downhill with a curb, turn the tires towards the right. 

car_action(parking):- not road_sign(no_parking), not road_sign(reserved_parking), parking_space(empty), not road_sign(no_parking_any_time), need_for(parking).
car_action(turn_tires_towards_left):- car_action(parking), car_location(uphill), road_right(curb).
car_action(turn_tires_towards_right):- car_action(parking), car_location(downhill), road_right(curb).
car_action(turn_tires_towards_right):- car_action(parking), car_location(uphill), not road_right(curb).
car_action(turn_tires_towards_right):- car_action(parking), car_location(downhill), not road_right(curb).


%% Rule to reverse the car, possible when there are no pedestrians/cyclists or traffic behind.

car_action(reverse):- pedestrians(no), cyclists(no), traffic(no), need_for(reverse).

car_action(keep_going_straight):- not car_action(stop),not car_action(go),not car_action(slow_down),not car_action(wait),not car_action(reverse),not car_action(parking),not car_action(turn_tires_towards_left),not car_action(turn_tires_towards_right),not car_action(left_turn),not car_action(right_turn),not car_action(u_turn),not car_action(yield_to_car),not car_action(yield_to_pedestrian),not car_action(yield_to_traffic),not car_action(yield_to_bus),not car_action(yield_to_train),not car_action(yield_to_authorized_vehicle).