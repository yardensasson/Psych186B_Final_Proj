[~,~,batting_info] = xlsread('Batting.xlsx');
batting_info(1,:) = [];
[~,~,HOF_names] = xlsread('HallOfFame.xls');
HOF_names(1,:) = [];
[~,~, All_Star_List] = xlsread('AllstarFull.xls');
All_Star_List(1,:) = [];
[~,~,Awards_list] = xlsread('AwardsPlayers.xls');
Awards_list(1,:) = [];
[~,~,postseason_batting] = xlsread('BattingPost.xls');
postseason_batting(1,:) = [];


% Extract only players
count = 0;
HOF_players = cell(10,9);
for i = 1:size(HOF_names, 1) 
    if strcmp(HOF_names{i,8}, 'Player') == 1
        %id = char(HOF_names(i,1));
        count = count + 1;
        for col_fill = 1:9
            HOF_players{count,col_fill} = HOF_names{i,col_fill};
        end
    end
end


% remove duplicates in the data due to multiple voting for each player
for i = 1:size(HOF_players,1)
    id_vector{i} = char(HOF_players{i,1}); % store all names in a vector
end
id_vector = unique(id_vector)';


% save regular season batter data based on players included in HOF data set
HOF_batting_data = cell(1,1);
count = 0;
for i = 1:size(id_vector,1)
    currName = id_vector(i);
    for j = 1:size(batting_info,1)
        if strcmp(batting_info{j,1},currName)
            count = count + 1;
            for col_fill = 1:22
                HOF_batting_data{count,col_fill} = batting_info{j,col_fill};
            end
        end
    end
end
HOF_batting_data(:,5) = []; % remove league

clear batting_info; 


% combine season by season data into career totals
HOF_career_totals = cell(1,1);
currPlayerVec = cell(1,1);
for i = 1:size(id_vector,1) % iterate through the list of names 
    currName = id_vector(i);
    count = 0;
    games = 0;
    ab = 0;
    runs = 0;
    hits = 0;
    doubles = 0;
    triples = 0;
    hr = 0;
    rbi = 0;
    sb = 0;
    bb = 0;
    ibb = 0;
    for j = 1:size(HOF_batting_data,1) % iterate through all seasons for all players
        if strcmp(HOF_batting_data{j,1},currName)
            count = count + 1;
            games = games + HOF_batting_data{j,5};
            ab = ab + HOF_batting_data{j,6};
            runs = runs + HOF_batting_data{j,7};
            hits = hits + HOF_batting_data{j,8};
            doubles = doubles + HOF_batting_data{j,9};
            triples = triples + HOF_batting_data{j,10};
            hr = hr + HOF_batting_data{j,11};
            rbi = rbi + HOF_batting_data{j,12};
            sb = sb + HOF_batting_data{j,13};
            bb = bb + HOF_batting_data{j,15};
            ibb = ibb + HOF_batting_data{j,17};
        end
    end
    currPlayerVec{i,1} = currName;
    currPlayerVec{i,2} = count; % years played
    currPlayerVec{i,3} = games; % total num games played
    currPlayerVec{i,4} = ab;
    currPlayerVec{i,5} = runs;
    currPlayerVec{i,6} = hits;
    currPlayerVec{i,7} = doubles;
    currPlayerVec{i,8} = triples;
    currPlayerVec{i,9} = hr;
    currPlayerVec{i,10} = rbi;
    currPlayerVec{i,11} = sb;
    currPlayerVec{i,12} = bb;
    currPlayerVec{i,13} = ibb;
    for k=1:13
        HOF_career_totals(i,k) = currPlayerVec(i,k);
    end
     clear currPlayerVec;
end
        
abs = cell2mat(HOF_career_totals(:,6)); % number of at bats 
pitcher_inds = find(abs < 500); % pitchers with less than 500 
HOF_career_totals(pitcher_inds,:)=[]; %Removes all pitchers approx
    

