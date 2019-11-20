[~,~,batting_info] = xlsread('Batting.xls');
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


% save regular season batter data based on players we want 
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

