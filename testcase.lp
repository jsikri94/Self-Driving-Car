%% Test case for left turn. 
road_right(white_line_broken).
road_left(white_line_broken).
cars_behind(no).
car_turnsignal_left(on). 
oncoming_traffic(no). 
pedestrians(no).
cyclists(no).
allowed(left_turn).
need_for(left_turn).

parking_space(empty).
need_for(parking).

%% Test case for reverse
traffic(no). 
need_for(reverse).

%% Weather related test cases
visibility(50).
weather(rain).

%% Test case for yielding to a car at a stop sign
road_sign(stop_sign).
other_car_arrives_same_time(yes).
road_right(car).

%% Test case for yielding to a bus
road_front(bus).
children(yes).